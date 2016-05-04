<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/viewPaper/${paperId}">View paper</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">View columns</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">Edit column info</a> >
Edit column restrictions
</span>
<div style='clear:both'></div>
<@showProgress 3 3/>

<form name="editColumnForm" method="post" action="${baseUrl}/user/saveScanningInformation">

<h1 style='margin:0 20px'>
    Step 3: edit scanning information (optional)
    <button type="submit" class="btn btn-default btn-primary"
            style='float:right;border-radius:0;padding:10px 10px 9px;'>
        Finish</button>
    <a href="${baseUrl}/user/addStudentList/${id}" class="btn btn-default btn-primary"
       style='float:right;border-radius:0;padding:10px 10px 9px;margin-right:20px'><span
            class='fa fa-caret-left'></span> Previous step</a>
</h1>

<div class='info_text'>
    These options are for use with the SRES scanning app. Frst, you can specify predefined values to show when inputting data - the display text field will show on the app, and the value field will be saved as the student data (e.g. show 'Correct' on the app and save '100' as the data).
    Second, when a user is scanned for this column, you can display custom information on the app (e.g. data from another column in SRES, or specific student fields). Copy and paste the shortcodes into the custom display textbox to display data from the SRES on the scanning app.
</div>

    <div class='info_text side1' style='position:relative;padding:0;margin:20px 10px 20px 20px;width:calc(34% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>
                <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">1</i>
                </span>
            Predefined values (<span class='extraFieldsSize'>0</span>)
        </h4>

        <div class='topPanel'>
            <div class='btn btn-default btn-primary' id="addKeyValue"  style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'>
                Add new predefined value
            </div>
        </div>

    <#if paperId?has_content>
        <input type="hidden" name="paperId" value="${paperId}"/>
    </#if>
    <#if column?has_content>
        <input type="hidden" name="_id" value="${column._id}"/>
    </#if>
        <input type="hidden" name="size" value="0"/>
        <table style='width:100%;margin-top:60px'>

            <tr id='addNewColumnAttribute'></tr>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:20px 20px 20px 10px;width:calc(66% - 30px);float:right'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>
                <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">2</i>
                </span>
            Custom display
        </h4>

        <table style='width:100%;margin-top:20px'>
            <tr>
                <td style='padding:0 20px'>
                    <textarea class='form-control' name="customDisplay" style='border-radius:0;resize:vertical;min-height:200px'><#if (column.customDisplay)?has_content>${column.customDisplay}</#if></textarea>
                </td>
            </tr>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:0 10px 20px 10px;width:calc(33% - 25px);clear:right;float:left'>
        <h4 style='margin:0;padding:10px;background:#043B4E;'>
            Student fields shortcodes
        </h4>

        <table style='width:100%;'>
            <#list paper.studentFields as f>
                <tr>
                    <td style='padding:5px 5px 0'>
                        <div class='input-group input-group1' style="width:100%">
                            <span class='input-group-addon sres_name shortcode_name' style='width:35%'>${f}:</span>
                            <input type="text" class="form-control shortcode" value="{{user.${f}}}"/>
                        </div>
                    </td>
                </tr>
            </#list>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:0 20px 20px 10px;width:calc(33% - 25px);float:left'>
        <h4 style='margin:0;padding:10px;background:#043B4E;'>
            Column shortcodes
        </h4>

        <table style='width:100%;'>
            <#list columns as c>
                <tr>
                    <td style='padding:5px 5px 0'>
                        <div class='input-group input-group1' style="width:100%">
                            <span class='input-group-addon sres_name shortcode_name' style='width:35%'>${c.name!}:</span>
                            <input type="text" class="form-control shortcode" value="{{data.${c._id}}}"/>
                        </div>
                    </td>
                </tr>
            </#list>
        </table>
    </div>
</form>


<script type="text/javascript">
    $(function () {

        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.side1').css("height", newHeight + "px");
        $('.side2').css("height", (newHeight/2 -10) + "px");
        $('.side3').css("height", (newHeight/2 -10) + "px");

        $.fn.shortText = function (str, length) {
            var item = $(this);
            var toset = str;
            if (str.length > length)
                toset = str.substring(0, length) + '...';
            item.text(toset).attr('title', str);
        };

        $('.shortcode_name').each(function(){
            var self = $(this);
            if (self.find("input").length == 0) {
                var text = self.text();
                self.shortText(text, 20);
            }
        });

        var index = 0;
        <#if extra?has_content>
            index = ${extra?keys?size};
            $('input[name=size]').val(index);
        </#if>

        $('#addKeyValue').on('click', function () {
            var newRow = "<tr class='predefined'><td style='padding:0 10px 5px 20px;width:40%'><div class='input-group input-group1' style='width:100%'><span class='input-group-addon sres_name' style='text-align:left'>Value:</span><input class='form-control' type='text' name='value' value='' style='vertical-align: top;display:inline-block;'/></div></td><td style='padding:0 20px 5px 0'><div class='input-group input-group2' style='width:100%'><span class='input-group-addon sres_name' style='text-align:left'>Display text:</span><input class='form-control' type='text' name='display' value='' style='vertical-align: top;display:inline-block;'/></div></td></tr>";
            index++;
            $('input[name=size]').val(index);
            $('#addNewColumnAttribute').before(newRow);
            $('.extraFieldsSize').text($('.predefined').length);
            return false;
        });

    });
</script>


