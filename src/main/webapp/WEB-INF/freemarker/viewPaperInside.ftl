<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />

<div id='topBar' class='topPanel' style='top:50px'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        View ${ICN} (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})
    </span>
<#if paper?has_content>
    <div style='position:relative'>
        <div id='paperMenu' style='padding:9px 10px 10px;float:right;margin:0;font-size:20px;border-radius:0'
             class='btn btn-default btn-primary'><span style='display:block;' class='fa fa-bars'></span></div>

        <div class='paper_buttons'
             style='margin-left:20px;display:none;position:absolute;top:40px;right:0;background:white;z-index:100'>
            <a href="${baseUrl}/user/" class='menuButton'>Back to ${ICN} list</a>
            <a href="${baseUrl}/user/${paper._id}" class='menuButton'>Edit ${ICN} info</a>
            <a href="${baseUrl}/user/viewColumnList/${paper._id}" class='menuButton'>Edit columns</a>
            <a href="${baseUrl}/user/addStudentList/${paper._id}" class='menuButton'>Import student list</a>
            <a href="${baseUrl}/user/importStudentData/${paper._id}" class='menuButton'>Import student data</a>
        </div>

    <div id='layoutButton' style='padding:5px 10px 6px;float:right;margin:0;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><img style='width:20px;height:20px;margin-top:-1px' src="${baseUrl}/assets/img/layout1.svg" /></div>

        <div class='layout_buttons' style='margin-left:20px;display:none;position:absolute;top:100px;right:81px;background:white;color:#0886AF'>
            <div class='menuButton'>
                <div class='layout1 layout'></div>
                <div style='float:left;margin-left:5px'>Layout 1</div>
                <div style='clear:both'></div>
            </div>
            <div class='menuButton'>
                <div class='layout2 layout'></div>
                <div style='float:left;margin-left:5px'>Layout 2</div>
                <div style='clear:both'></div>
            </div>
        </div>
    </div>
</#if>
</div>

<div style='position:absolute;left:0;right:0;bottom:0;top:90px;overflow-y:scroll;overflow-x: hidden'>

    <div class="gridster">
        <ul>
            <#if !paper.gridData?has_content> <#-- default dashboard layout -->
                <li id='panel1' class='sres_panel' data-row="1" data-col="1" data-sizex="2" data-sizey="1" data-paneltype="columns">
                    <div class='innerContent'>
                        <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                    </div>
                </li>
                <li id='panel2' class='sres_panel' data-row="2" data-col="1" data-sizex="2" data-sizey="1" data-paneltype="filters">
                    <div class='innerContent'>
                        <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                    </div>
                </li>
                <li id='panel3' class='sres_panel' data-row="3" data-col="1" data-sizex="2" data-sizey="2" data-paneltype="studentData">
                    <div class='innerContent'>
                        <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                    </div>
                </li>
                <li id='panel4' class='sres_panel' data-row="1" data-col="3" data-sizex="1" data-sizey="2" data-paneltype="paperInfo">
                    <div class='innerContent'>
                        <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                    </div>
                </li>

                <li class='sres_panel' data-row="3" data-col="3" data-sizex="1" data-sizey="1"
                    style='background:white;overflow:hidden' data-paneltype="dataOverview">
                    <div class='innerContent'>
                        <h4 style='margin:0;padding:10px;background:#043B4E'>Data overview <span class='fa fa-times deletePanel' style='float:right'></span></h4>
                    <#--      <#list columns as c>
                                <div id="${c._id}" class="${c._id} chart chart_${c_index} pieChart" style="margin:0 auto"></div>
                            </#list> -->
                    </div>
                </li>

                <li id='panel6' class='sres_panel' data-row="4" data-col="3" data-sizex="1" data-sizey="1" data-paneltype="interventions">
                    <div class='innerContent'>
                        <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                    </div>

                </li>
            </#if>
        </ul>
    </div>

</div>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

$(function () {

    var third = 1 / 3;
    var quarter = 1 / 4;
    var gap = 10;
    var screenwidth = $(document).width() - (gap * 10);
    var firstPanelStart = 50 + $('#topBar').height() + (gap * 2);
    var screenheight = $(document).height() - firstPanelStart - (gap * 8);

    var gridster = $(".gridster ul").gridster({
        widget_margins: [gap, gap],
        widget_base_dimensions: [(screenwidth * third), (screenheight * quarter)],
        max_cols: 3,
        resize: {
            enabled: true,
            stop : function(){
                saveGridData();
            }
        },
        serialize_params: function($w, wgd) {
            return {
                id: $w.attr('id'),
                col: wgd.col,
                row: wgd.row,
                size_x: wgd.size_x,
                size_y: wgd.size_y,
                paneltype: $w.data('paneltype')
            };
        },
        draggable : {
            stop : function(){
                //save grid layout here
                saveGridData();
            }
        }
    }).data('gridster') ;

    <#if paper.gridData?has_content>
        var gridData = JSON.parse("${paper.gridData?js_string}");
        gridData = Gridster.sort_by_row_and_col_asc(gridData);
        $.each(gridData, function(i,e){
            gridster.add_widget("<li id='" + this.id + "' data-paneltype='" + this.paneltype + "' class='sres_panel'><div class='innerContent'><img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' /></div></li>", this.size_x, this.size_y, this.col, this.row);
        });
    </#if>

    function saveGridData(){
        var gridData = JSON.stringify(gridster.serialize());
        $.post("${baseUrl}/user/saveDashboardLayout",
                {gridData:gridData,paperId:"${paper._id}"},
                function(response){

                });
    }

    //async loading of panels-------------------------------------------------

    $('.sres_panel').each(function(i,e){
        var self = $(this);
        var id = self.attr('id');
        var pt = self.data("paneltype");
        if(pt == "columns"){
            $.get("${baseUrl}/user/getColumns/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(id);
            });
        } else if (pt == "filters"){
            $.get("${baseUrl}/user/getFilters/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(id);
                filterList = $('#filterList');
                filterDivHtml = $('.filterDiv').html();
            });
        } else if (pt == "studentData"){
            $.get("${baseUrl}/user/getStudentData/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(id);

                self.find('th').each(function () {
                    var slf = $(this);
                    if (slf.find("input").length == 0) {
                        var text = slf.text();
                        slf.shortText(text, 20);
                    }
                });
            });
        } else if (pt == "paperInfo"){
            $.get("${baseUrl}/user/getPaperInfo/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(id);
            });
        } else if (pt == "interventions") {
            $.get("${baseUrl}/user/getInterventions/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(id);
            });
        }
    });

    //-------------------------------------------------------------------------


    $(document).on('click', 'input[name=usernameAll]', function () {
        if ($(this).is(':checked')) {
            $('input[name=usernames]').prop('checked', true);
            $('input[name=usernames]').next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        else {
            $('input[name=usernames]').prop('checked', false);
            $('input[name=usernames]').next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
        }
    });

    $(document).on('click', 'input[name=columnsAll]', function () {
        $('input[name=columns]').each(function () {
            var self = $(this);
            self.click();
            var checked = self.is(":checked");

            if (checked) {
                self.prop('checked', true);
                self.next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
            }
            else {
                self.prop('checked', false);
                self.next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
            }
        });
    });

    $(document).on('click', '.deletePanel', function () {
        var self = $(this);
        var parent = self.parents('.sres_panel');
        gridster.remove_widget(parent);
        saveGridData();
    });

    function replaceCheckboxes(div_id){
        $('input[type=checkbox]','#'+div_id).each(function (i, e) {
            var self = $(this);
            var newCheckbox = "";
            if (self.is(":checked")) {
                newCheckbox = "<span class='sres_checkbox fa fa-check-circle'></span>";
            } else {
                newCheckbox = "<span class='sres_checkbox fa fa-circle-thin'></span>";
            }
            self.after(newCheckbox);
            self.css('display', 'none');
        });
    }


    $(document).on('click', '.sres_checkbox', function () {
        var self = $(this);
        if (self.hasClass('fa-check-circle')) {
            self.removeClass('fa-check-circle').addClass('fa-circle-thin');
        } else {
            self.addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        self.prev('input[type=checkbox]').click();
    });

    $('.chart').css('margin-top', '5px').css('width', (screenwidth * third) + 'px').css("height", (screenheight * quarter - 30) + "px");

    var filterList = $('#filterList');
    var filterDivHtml = $('.filterDiv').html();
    $('.operatorDiv').remove();

    $.fn.shortText = function (str, length) {
        var item = $(this);
        var toset = str;
        if (str.length > length)
            toset = str.substring(0, length) + '...';
        item.text(toset).attr('title', str);
    };

   /*
    $('.colourPicker').on('click', function(){
        var self = $(this);
        var column = self.data('column');
        console.log('colour');
        //TODO: change colours
    });  */


    $(document).on('click', 'span.newFilter', function () {
        var div = $('<div/>').addClass('filterDiv').html(filterDivHtml).appendTo(filterList);
        div.prev('.filterDiv').find('input[name=value]').css('width', '25%');
        div.prev('.filterDiv').find('select[name=join]').css('display', 'inline-block');
        $('span.removeFilter').show();
    });

    var columns = $('.topLeftPanel:last').html();
    var filters = $('.midLeftPanel:last').html();
    var studentList = $('.bottomLeftPanel:last').html();
    var paperInfo = $('.topRightPanel:last').html();
    var dataOverview = $('.midRightPanel:last').html();

    var p;

    $(document).on('click', '.addPanel', function () {
        var self = $(this);
        p.popup_simple('destroy');
        var placeholder = p.data('placeholder');
        var div = placeholder.next('.sres_panel');
        placeholder.hide();
        if (self.hasClass("addColumns"))
            div.html(columns).show();
        else if (self.hasClass("addFilters"))
            div.html(filters).show();
        else if (self.hasClass('addStudentList'))
            div.html(studentList).show();
        else if (self.hasClass('addPaperInfo'))
            div.html(paperInfo).show();
        else if (self.hasClass("addDataOverview"))
            div.html(dataOverview).show();
    });

    $('.placeHolder').on('click', function () {
        var self = $(this);
        p = $("<div></div>").appendTo("body");
        p.data('placeholder', self);

        var inner = $("<div></div>");
        var table = $("<table style='width:100%'></table>");
        var tr1 = $("<tr></tr>");
        var tr2 = $("<tr></tr>");
        var button1 = "<td><button class='addPanel addColumns btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-bars' style='font-size:32px;transform:rotate(90deg)' ></span><br/>Columns</button></td>";
        var button2 = "<td><button class='addPanel addFilters btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-sitemap' style='font-size:32px;' ></span><br/>Filters</button></td>";
        var button3 = "<td><button class='addPanel addStudentList btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-bars' style='font-size:32px;' ></span><br/>Student list</button></td>";

        var button4 = "<td><button class='addPanel addDataOverview btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-pie-chart' style='font-size:32px;' ></span><br/>Data overview</button></td>";
        var button5 = "<td><button class='addPanel addPaperInfo btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-file-text-o' style='font-size:32px;' ></span><br/>${ICN_C} info</button></td>";
        var button6 = "<td><button class='addPanel btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-envelope' style='font-size:32px;' ></span><br/>Email log</button></td>";

        tr1.append(button1, button2, button3);
        tr2.append(button4, button5, button6);
        table.append(tr1, tr2);

        inner.append("<h4 style='color:#021E27'>Add a panel</h4>");
        inner.append(table);

        p.popup_simple('init', {
            content: inner,
            extraClasses: ["mainPopup"],
            confirm: false,
            cancel: true
        }).popup_simple("show").popup_simple("centre");
    });

    <#if json?has_content>
        {
            var jsonString = "${json?js_string}";
            if (jsonString) {
                var array = $.parseJSON(jsonString);
                console.log('array', array);
                for (var i = 0; i < array.length; i++) {
                    var join = array[i].join;
                    var colref = array[i].colref;
                    var operator = array[i].operator;
                    var value = array[i].value;
                    if (i == 0) {
                        var filterDiv = $('.filterDiv');
                        $('[name=colref]', filterDiv).val(colref);
                        $('[name=operator]', filterDiv).val(operator);
                        $('[name=value]', filterDiv).val(value);
                    } else {
                        $('span.newFilter').click();
                        var filterDiv = $('.filterDiv:last');
                        $('[name=join]', filterDiv).val(join);
                        $('[name=colref]', filterDiv).val(colref);
                        $('[name=operator]', filterDiv).val(operator);
                        $('[name=value]', filterDiv).val(value);
                    }
                }
            }
        }
    </#if>

    $(document).on('click', 'div.removeFilter', function () {
        $(this).parent().remove();
    });

    $(document).on('click', 'button.submit', function () {
        var id = $('[name=id]').val();
        var array = [];
        $('.filterDiv').each(function (i, e) {
            var slf = $(this);
            var obj = {};
            obj.join = $('[name=join]', slf).val();
            obj.colref = $('[name=colref]', slf).val();
            obj.operator = $('[name=operator]', slf).val();
            obj.value = $('[name=value]', slf).val();
            array.push(obj);
        });
        var jsonString = JSON.stringify(array);
        console.log('json string', jsonString);
        $('[name=json]').val(jsonString);
        $('[name=filterForm]').submit();
    });

    $(document).on("dblclick", '#studentList td', function () {
        var slf = $(this);
        var id = slf.data('id');
        var userId = slf.data("userid");
        var columnId = slf.data("columnid");
        if ((id != null) || ((userId != null) && (columnId != null))) {
            var oldValue = $.trim(slf.text());
            var input = $('<input/>').attr('type', 'text').attr('value', oldValue);
            slf.html(input);
            input.focus();
            input.select();
            input.on('keydown', function (e) {
                if (e.keyCode == 13) {
                    saveChanges(slf, input, oldValue);
                    return false;
                } else if (e.keyCode == 27)
                    changeInputBackToText(slf, input, oldValue);
            });
            input.on('blur', function (e) {
                var value = $.trim(input.val());
                if (value != oldValue) {
                    if (confirm('Do you want to save your changes?'))
                        saveChanges(slf, input, oldValue);
                    else
                        changeInputBackToText(slf, input, oldValue);
                }
            });
        }
    });

    $(document).on('change', 'input.columnCheckbox', function () {
        var slf = $(this);
        var value = slf.val();
        if (slf.is(':checked')) {
            $('.' + value).show();
        } else {
            $('.' + value).hide();
        }
    });

    function saveChanges(td, input, oldValue) {
        var value = $.trim(input.val());
        if (value != oldValue) {
            var id = td.data('id');
            var userId = td.data("userid");
            var columnId = td.data("columnid");
            $.post('${baseUrl}/user/saveColumnValue',
                    { id: id, userId: userId, columnId: columnId, value: value },
                    function (json) {
                        if (json.success) {
                            if (json.detail) {
                                console.log("detail", json.detail);
                                td.data("id", json.detail);
                            }
                            changeInputBackToText(td, input, value);
                        } else if (json.detail)
                            alert(json.detail);
                    });
        } else
            changeInputBackToText(td, input, value);
    }

    function changeInputBackToText(td, input, value) {
        td.text(value);
        input.remove();
    }

    var arrayOfColours = [
        ["#1A90C7", "#26A7E3", "#4AB6E8", "#6FC4EC", "#93D3F1", "#072736", "#0C415A", "#105C7E", "#1576A2"],
        ["#C71AAD", "#E326C7", "#E84AD0", "#F193E3", "#F6B7EC", "#36072F", "#5A0C4E", "#7E106E", "#A2158D"],
        ["#1AC78D", "#26E3A4", "#4AE8B3", "#6FECC2", "#93F1D2", "#073626", "#0C5A40", "#107E5A", "#15A273"],
        ["#C7651A", "#E37826", "#E88F4A", "#ECA56F", "#F1BC93", "#361B07", "#5A2E0C", "#7E4010", "#A25215"],
        ["#C71A1A", "#E32626", "#E84A4A", "#EC6F6F", "#F19393", "#360707", "#5A0C0C", "#7E1010", "#A21515"]
    ];

   // google.load('visualization', '1.1', {packages: ['corechart'], callback: drawCharts});
 <#--
    function drawCharts() {

    <#list columns as c>
        var column = {};
        column.name = "${c.name?js_string}";
        column.id = "${c._id}";
        column.data = {};
        $('td.' + column.id).each(function (i, e) {
            var value = $(e).data('value');
            if ((value == null) || (value == ""))
                value = "[blank]";
            if (!column.data[value])
                column.data[value] = 1;
            else
                column.data[value] += 1;
        });
        console.log('column.data', column.data);

        var arrayOfArray = [
            ['Task', 'sdd']
        ];
        $.each(column.data, function (i, e) {
            arrayOfArray.push([i, e]);
        });

        var data = google.visualization.arrayToDataTable(arrayOfArray);

        var options = {
            title: column.name,
            backgroundColor: 'transparent',
            legend: {textStyle: {color: '#000'}, position: "labeled"},
            pieSliceTextStyle: {
                color: 'transparent'
            },
            colors: arrayOfColours[${c_index}% arrayOfColours.length
    ],
        chartArea: {
            width:"100%", left:20, right:20
        }
    };

        var chart = new google.visualization.PieChart(document.getElementById(column.id));
        chart.draw(data, options);
    </#list>
    }
      -->
    $(document).on('click', '.emailStudents', function () {
        $('#resultsForm').submit();
        return false;
    });

    var $paperButtons = $('.paper_buttons');
    var $layoutButtons = $('.layout_buttons');
    $('html').on('click', function () {
        if ($paperButtons.is(":visible"))
            $paperButtons.hide();
        if ($layoutButtons.is(":visible"))
            $layoutButtons.hide();
    });

    $('#paperMenu').on('click', function (event) {
        if ($paperButtons.is(':hidden'))
            $paperButtons.show();
        else
            $paperButtons.hide();
        if ($layoutButtons.is(":visible"))
            $layoutButtons.hide();
        event.stopPropagation();
    });

  <#--  var colTotal = ${columns?size};
    var colCount = 0;

    var interval = setInterval(function () {
        $('.chart_' + (colCount % colTotal)).css('display', 'none');
        colCount++;
        $('.chart_' + (colCount % colTotal)).css('display', 'inline-block');
    }, 5000);       -->

    $('td.userCheck').on("mouseover", function () {
        var slf = $(this);
        slf.find('span').show();
    });

    $('td.userCheck').on("mouseout", function () {
        var slf = $(this);
        slf.find('span').hide();
    });

    $('span.deleteUser').on('click', function () {
        if (confirm("Are you sure you want to remove this user from current paper?")) {
            var slf = $(this);
            var id = slf.data('id');
            console.log('delete user here', id);
            var paperId = "${id}";
            $.post('${baseUrl}/user/removeUser',
                    {id: id, paperId: paperId},
                    function (json) {
                        if (json.success) {
                            console.log('removed user', id, 'from', paperId);
                            slf.closest('tr').remove();
                        }
                    });
        }
    });

});

</script>