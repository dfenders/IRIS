package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.DeleteResult;
import nz.ac.otago.edtech.spring.bean.UploadLocation;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.ServletUtil;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.input.BOMInputStream;
import org.apache.commons.lang3.StringUtils;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.mongodb.client.model.Filters.eq;
import static java.util.Arrays.asList;

/**
 * name here.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/02/16
 *         Time: 9:09 AM
 */
@Controller
@RequestMapping("/user")
public class UserController {

    private static final Logger log = LoggerFactory.getLogger(UserController.class);


    private static final String[] USER_FIELDS = {"username", "givenNames", "surname", "preferredName", "email", "phone"};

    @Autowired
    private UploadLocation uploadLocation;


    DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.ENGLISH);


    @Autowired
    MongoClient mongoClient;

    @Value("${mongodb.dbname}")
    private String dbName;


    private String collectionNamePaper = "papers";

    MongoDatabase db =null;

    @PostConstruct
    public void init() {
         db = mongoClient.getDatabase(dbName);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String home(ModelMap model) {

        List<Document> documents = MongoUtil.getAllDocuments(db, collectionNamePaper);
        model.put("list", documents);
        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/addPaper", method = RequestMethod.GET)
    public String addPaper(ModelMap model) {
        model.put("pageName", "addPaper");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/addPaper", method = RequestMethod.POST)
    public String addPaper(HttpServletRequest request) {
        ObjectId id = MongoUtil.insertOne(request, db, collectionNamePaper);
        log.debug("id {}", id);
        return "redirect:/user/addStudentList/" + id.toString();
    }

    @RequestMapping(value = "/addStudentList/{id}", method = RequestMethod.GET)
    public String editStudentList(@PathVariable String id, ModelMap model) {
        model.put("id", id);
        model.put("pageName", "addStudentList");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/addStudentList", method = RequestMethod.POST)
    public String editStudentList(
            @RequestParam("files") MultipartFile file,
            @RequestParam("id") String id,
            ModelMap model) {
        File upload = new File(uploadLocation.getUploadDir(), file.getOriginalFilename());
        if (StringUtils.isNotBlank(upload.getPath())) {
            try {
                file.transferTo(upload);
                List<String[]> list = new ArrayList<String[]>();
                int index = 0;
                BufferedReader in = new BufferedReader(new FileReader(upload));
                for (String line; (line = in.readLine()) != null; ) {
                    index++;
                    if (index > 3)
                        break;
                    String[] columns = line.split(",");
                    list.add(columns);
                }
                model.put("list", list);
                model.put("id", id);
                model.put("filename", upload.getName());
            } catch (IOException e) {
                log.error("Exception", e);
            }
        }
        model.put("fields", USER_FIELDS);
        model.put("pageName", "mapFields");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/importUser", method = RequestMethod.POST)
    public String importUser(HttpServletRequest request,
                             @RequestParam("id") String id,
                             @RequestParam("size") int size,
                             ModelMap model) {

        boolean hasHeader = false;

        if (request.getParameter("hasHeader") != null)
            hasHeader = true;

        int[] index = new int[USER_FIELDS.length];

        for (int i = 0; i < USER_FIELDS.length; i++) {
            index[i] = ServletUtil.getParameter(request, USER_FIELDS[i], -1);
        }

        Map<String, Integer> extraFields = new HashMap<String, Integer>();

        for (int i = 0; i < size; i++) {
            if (request.getParameter("extra" + i) != null) {
                String key = request.getParameter("key" + i);
                int value = ServletUtil.getParameter(request, "value" + i, -1);
                extraFields.put(key, value);
            }
        }


        String filename = request.getParameter("filename");


        try {

            Iterable<CSVRecord> records = null;
            List<Document> list = new ArrayList<Document>();

            File file = new File(uploadLocation.getUploadDir(), filename);
            if (file.exists()) {
                if (hasHeader) {
                    // read csv file with header
                    InputStream input = new FileInputStream(file);
                    Reader reader = new InputStreamReader(new BOMInputStream(input), "UTF-8");
                    records = new CSVParser(reader, CSVFormat.EXCEL.withHeader());
                } else {
                    // read csv file without header
                    Reader in = new FileReader(file);
                    records = CSVFormat.EXCEL.parse(in);
                }

                for (CSVRecord record : records) {
                    ModelMap map = new ModelMap();
                    map.put("role", "student");
                    for (int i = 0; i < USER_FIELDS.length; i++) {
                        if (index[i] != -1)
                            map.put(USER_FIELDS[i], record.get(index[i]));
                    }
                    Document doc = new Document(map);
                    if (!extraFields.isEmpty()) {
                        ModelMap extra = new ModelMap();
                        for (String k : extraFields.keySet()) {
                           int ii = extraFields.get(k);
                            if(ii !=-1) {
                                extra.put(k, record.get(ii));
                            }
                        }
                        if(!extra.isEmpty()) {
                            Document extraDoc = new Document(extra);
                            doc.append("extra", extraDoc);
                        }
                    }
                    list.add(doc);
                }
                ObjectId ii = new ObjectId(id);
                db.getCollection(collectionNamePaper).updateOne(new Document("_id", ii),
                        new Document("$set", new Document("users", list)));
            }
        } catch (FileNotFoundException e) {
            log.error("Exception", e);
        } catch (IOException ioe) {
            log.error("IOException", ioe);
        }
        return "redirect:/user";
    }

    @RequestMapping(value = "/deletePaper/{id}", method = RequestMethod.GET)
    public ResponseEntity<String> deletePaper(@PathVariable String id) {
        String action = "deletePaper";
        boolean success = false;
        String detail = null;

        ObjectId oi = new ObjectId(id);

        DeleteResult result =  db.getCollection(collectionNamePaper).deleteOne(eq("_id", oi));
        if(result.getDeletedCount() ==1)
            success = true;
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/viewPaper/{id}", method = RequestMethod.GET)
    public String viewPaper(@PathVariable String id, ModelMap model) {
        model.put("id", id);
        model.put("doc", MongoUtil.getDocument(db, collectionNamePaper, id));
        model.put("pageName", "viewPaper");
        return Common.DEFAULT_VIEW_NAME;
    }



    @RequestMapping(value = "/viewStudentList/{id}", method = RequestMethod.GET)
    public String viewStudentList(@PathVariable String id, ModelMap model) {
        model.put("id", id);



        Document doc = MongoUtil.getDocument(db, collectionNamePaper, id);
        model.put("doc", doc);
        model.put("pageName", "viewStudentList");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/mongo", method = RequestMethod.GET)
    public String mongo(HttpServletRequest request, ModelMap model) {



        List<Document> documents = new ArrayList<Document>();

        ObjectId id = new ObjectId("56c29ee5628be38bcea305bf");

        FindIterable<Document> iterable = db.getCollection(collectionNamePaper).find(eq("_id", id));


        for (Document document : iterable) {
            log.debug("document {}", document);
            documents.add(document);


        }


        model.put("list", documents);

        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/insert", method = RequestMethod.GET)
    public String insert(HttpServletRequest request, ModelMap model) {

        try {
            db.getCollection("restaurants").insertOne(
                    new Document("address",
                            new Document()
                                    .append("street", "2 Avenue")
                                    .append("zipcode", "10075")
                                    .append("building", "1480")
                                    .append("coord", asList(-73.9557413, 40.7720266)))
                            .append("borough", "Manhattan")
                            .append("cuisine", "Italian")
                            .append("grades", asList(
                                    new Document()
                                            .append("date", format.parse("2014-10-01T00:00:00Z"))
                                            .append("grade", "A")
                                            .append("score", "32"),
                                    new Document()
                                            .append("date", format.parse("2014-01-16T00:00:00Z"))
                                            .append("grade", "B")
                                            .append("score", "28")))
                            .append("name", "Vella")
                            .append("restaurant_id", "4795458"));

        } catch (ParseException pe) {
            log.error("ParseException", pe);
        }

        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;

    }

}