<%@page import="com.mss.ediscv.util.AppConstants"%>
<%@page import="com.mss.ediscv.utilities.CodeListBean"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page buffer="50kb" autoFlush="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>Miracle Supply Chain Visibility Portal</title>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="cache-control" content="no-cache" />
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <link rel="stylesheet" href='<s:url value="/includes/bootstrap/css/userdefined.css"/>'>
        <%-- <script type="text/javascript" src="//cdn.jsdelivr.net/bootstrap.daterangepicker/2/daterangepicker.js"></script> --%>
        <link rel="stylesheet" href='<s:url value="/includes/plugins/datatables/dataTables.bootstrap.css"/>' type="text/css">
        <link rel="stylesheet" href='<s:url value="/includes/plugins/daterangepicker/daterangepicker.css"/>' type="text/css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script>
            function doOnLoad() {
                $("#utilities").addClass("active");
                $("#codeList").addClass("active");
                $("#codeList i").addClass("text-red");
                document.getElementById('loadingAcoountSearch').style.display = "none";
            }
            $(function () {
                if (document.getElementById("items").value == 0)
                {
                    $('#results').DataTable({
                        "paging": false,
                        "lengthChange": true,
                        "searching": true,
                        "ordering": false,
                        "info": true,
                        "autoWidth": false,
                        "scrollX": true

                    });
                }
                else
                {
                    $('#results').DataTable({
                        "paging": false,
                        "lengthChange": true,
                        "searching": true,
                        "ordering": false,
                        "info": true,
                        "autoWidth": false,
                        "scrollX": true,
                        "scrollY": 300
                    });
                }
            });

            var count = 0;
            $(document).ready(function () {
                window.setTimeout(function () {
                    // This will execute 5 seconds later
                    document.getElementById('messagediv').innerHTML = "";

                }, 5000);
                $('#add').click(function () {
                    var rowCount = $('#results tr').length;
                    if (rowCount == 2)
                    {
                        $('#results').dataTable().fnDestroy();
                        count = $('#results tr').length;

                        $('#results').append(
                                '<tr><td><input type="checkbox" name="check' + count + '" id="check' + count + '" theme="simple"/></td>' +
                                '<td><input type="text" id="senderItem' + count + '" name="senderItem' + count + '"/><input type="hidden" value="" id="senderId' + count + '" name="senderId' + count + '"/><input type="hidden" value="" id="listName' + count + '" name="listName' + count + '"/></td>' +
                                '<td><input type="text" id="recItem' + count + '" name="recItem' + count + '" onchange="checkItems(' + count + ')"/></td>' +
                                '<td><input type="text" id="desc' + count + '" name="desc' + count + '"/></td>' +
                                '<td><input type="text" id="text1' + count + '" name="text1' + count + '"/></td>' +
                                '<td><input type="text" id="text2' + count + '" name="text2' + count + '"/></td><input type="hidden" value="" id="recId' + count + '" name="recId' + count + '"/>' +
                                '<td><input type="text" id="text3' + count + '" name="text3' + count + '"/></td><input type="hidden" value="" id="listVersion' + count + '" name="listVersion' + count + '"/>' +
                                '<td><input type="text" id="text4' + count + '" name="text4' + count + '"/></td>' +
                                '<td><input type="text" id="text5' + count + '" name="text5' + count + '"/></td>' +
                                '<td><input type="text" id="text6' + count + '" name="text6' + count + '"/></td>' +
                                '<td><input type="text" id="text7' + count + '" name="text7' + count + '"/></td>' +
                                '<td><input type="text" id="text8' + count + '" name="text8' + count + '"/></td>' +
                                '<td><input type="text"  id="text9' + count + '" name="text9' + count + '"/></td>' +
                                '</tr>');
                        // $('#results').dataTable();
                        $('#results').DataTable({
                            "paging": false,
                            "lengthChange": true,
                            "searching": true,
                            "ordering": false,
                            "info": true,
                            "autoWidth": false,
                            "scrollX": true,
                            "scrollY": 100
                        });
                    } else {
                        count = $('#results tr').length;
                        $('#results').append(
                                '<tr><td><input type="checkbox" name="check' + count + '" id="check' + count + '" theme="simple"/><input type="hidden" value="" id="listName' + count + '" name="listName' + count + '"/></td>' +
                                '<td><input type="text" id="senderItem' + count + '" name="senderItem' + count + '"/></td>' +
                                '<td><input type="text" id="recItem' + count + '" name="recItem' + count + '" onchange="checkItems(' + count + ')"/></td>' +
                                '<td><input type="text" id="desc' + count + '" name="desc' + count + '"/></td>' +
                                '<td><input type="text" id="text1' + count + '" name="text1' + count + '"/><input type="hidden" value="" id="senderId' + count + '" name="senderId' + count + '"/></td>' +
                                '<td><input type="text" id="text2' + count + '" name="text2' + count + '"/></td>' +
                                '<td><input type="text" id="text3' + count + '" name="text3' + count + '"/></td>' +
                                '<td><input type="text" id="text4' + count + '" name="text4' + count + '"/></td>' +
                                '<td><input type="text" id="text5' + count + '" name="text5' + count + '"/></td><input type="hidden" value="" id="recId' + count + '" name="recId' + count + '"/>' +
                                '<td><input type="text" id="text6' + count + '" name="text6' + count + '"/></td><input type="hidden" value="" id="listVersion' + count + '" name="listVersion' + count + '"/>' +
                                '<td><input type="text" id="text7' + count + '" name="text7' + count + '"/></td>' +
                                '<td><input type="text" id="text8' + count + '" name="text8' + count + '"/></td>' +
                                '<td><input type="text"  id="text9' + count + '" name="text9' + count + '"/></td>' +
                                '</tr>');
                    }
                    return false;
                });
            });

            $(function () {
                $('#clear').click(function () {
                    $('#results').DataTable().clear().draw();
                    $('#selectedName').val("");
                    $('#modifieddate').val("");
                    $('#items').val("");
                    $('#listName').val("-1");
                    $('#messagediv').empty();
                    $('#checkboxAll').attr("checked", false);

                });
            });
        </script>
        <style>
            @media (min-width: 992px) and (max-width: 1192px) {
                #set_align1{
                    margin: 0 -13px !important;
                }
            }
            .content-wrapper
            {
                min-height: 800px !important;
            }
            div.dataTables_wrapper {
                width: 1000px;
                margin: 0 auto;
                overflow-x: hidden;
            }
            #site_content .f1{
                background-color:transparent;
                border: 0;

            }
            table.dataTable thead > tr > th{
                white-space: nowrap;
            }

        </style>



    </head>

    <body class="hold-transition skin-blue sidebar-mini" onload="doOnLoad()"> 

        <div>
            <s:include value="../includes/template/header.jsp"/>
        </div>
        <div>
            <s:include value="../includes/template/sidemenu.jsp"/>
        </div>
        <!-- Content Wrapper. Contains page content -->

        <div class="content-wrapper">
            <!-- Intro -->

            <section class="content-header">
                <h1>
                    Code List Editor
                    <small>Code List</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a ><i class="fa fa-gavel"></i>Code List Editor</a></li>
                    <li class="active">Code List</li>
                </ol>
            </section>
            <center> <div id="responseString">
                    <%
                        if (session.getAttribute(AppConstants.REQ_RESULT_MSG) != null) {
                            String responseString = session.getAttribute(AppConstants.REQ_RESULT_MSG).toString();
                            out.println(responseString);
                            session.setAttribute(AppConstants.REQ_RESULT_MSG, null);
                        }
                    %>
                </div> 
            </center>

            <s:form action="../utilities/getCodeListName.action" method="post" cssClass="contact-form" name="certForm" id="certForm" theme="simple">
                <div class="col-md-12" style="padding-top: 9px">
                    <div class="box box-primary">
                        <div class="box-body">

                            <div class="col-sm-3">
                                <label>Name Search</label>
                                <s:textfield name="name" id="name" cssClass="form-control" value="%{name}" tabindex="1"/> 
                            </div>
                            <div class="col-sm-3" style="padding-top: 25px"> 
                                <div>
                                    <s:submit value="Search" cssClass="btn btn-primary" id="button" name="button" tabindex="2" /> 
                                </div>
                            </div>
                            <div class="col-sm-3"> 
                                <label>Code List </label>
                                <s:select headerKey="-1" headerValue="--Select Type--" cssClass="form-control" list="listNameMap" name="listName" id="listName" value="%{listName}" onchange="getList();" tabindex="3"/> 
                            </div>


                        </div> 
                    </div>


                    <br>




                </s:form>
            </div>
            <br>
            <br>

            <div id="loadingAcoountSearch" class="loadingImg">
                <span id ="LoadingContent" > <img src="<s:url value="/includes/images/Loader2.gif"/>"   ></span>
            </div>
            <div class="col-md-12">
                <div id="site_content"> 
                    <div class="box box-primary">

                        <div class="box-body">
                            <div class="row col-md-12 col-sm-12">
                                <div class="col-sm-5">
                                    <label style="float: left">Code List Selected :</label>
                                    <s:textfield name="selectedName" id="selectedName" style="width: 200px;position: relative;bottom: 7px;float: left" cssClass="f1 form-control" value="%{selectedName}" tabindex="7" readonly="true"/> 
                                </div>
                            </div>
                            <br>
                            <br>
                            <div class="row col-md-12 col-sm-12" style="margin-top: 20px">
                                <div class="col-sm-3 col-md-3 col-xs-3">
                                    <label style="float: left">Last Date Modified :</label>
                                    <s:textfield id="modifieddate" name="modifieddate" style="width:90px;float: left;position: relative;bottom:8px;right:3px" cssClass="f1 form-control" value="%{modifieddate}" readonly="true"/>
                                </div>
                                <div class="col-sm-3" style="float : right"><label> Number Of Code List Items :</label>
                                    <s:textfield id="items"  style="width:60px;float:right;position: relative;bottom: 32px;" name="items" value="%{items}" cssClass="f1 form-control" readonly="true"/>
                                </div>
                            </div> 

                            <br>

                            <div id="gridDiv"> 
                                <%-- <s:if test="#session.codeList != null"> 
                                GRid start --%>
                                <section class="content">
                                    <div class="row">
                                        <div class="col-md-12 col-sm-12 col-xs-12">
                                            <div class="box">
                                                <div class="box-header">
                                                    <h3 class="box-title"></h3>
                                                </div><!-- /.box-header -->
                                                <div class="box-body">
                                                    <%!String cssValue = "whiteStripe";
                                                        int resultsetTotal;%>
                                                    <div>
                                                        <table align="left" width="100%" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td style="background-color: white;">
                                                                    <table id="results" class="table table-bordered table-hover">
                                                                        <thead><tr>
                                                                                <th><input type="checkbox" id="checkboxAll" name="checkboxAll" onclick="selectAllRecords();"/>&nbsp;SELECT</th>
                                                                                    <%-- <th>LIST_NAME <font class="text-danger">*</font></th> 
                                                                                     <th>SENDER_ID</th>
                                                                                     <th>RECEIVER_ID</th>
                                                                                     <th>LIST_VERSION</th> --%>
                                                                                <th>SENDER_CODE <font class="text-danger">*</font></th>
                                                                                <th>RECEIVER_CODE <font class="text-danger">*</font></th>
                                                                                <th>DESCRIPTION <font class="text-danger">*</font></th>
                                                                                <th>TEXT1</th>
                                                                                <th>TEXT2</th>
                                                                                <th>TEXT3</th>
                                                                                <th>TEXT4</th>
                                                                                <th>TEXT5</th>
                                                                                <th>TEXT6</th>
                                                                                <th>TEXT7</th> 
                                                                                <th>TEXT8</th> 
                                                                                <th>TEXT9</th> 
                                                                            </tr> </thead>
                                                                        <tbody>

                                                                            <%if (session.getAttribute("codeList") != null) {
                                                                                    java.util.List codeList = new java.util.ArrayList();
                                                                                    CodeListBean codeListBean = null;
                                                                                    codeList = (java.util.List) session.getAttribute("codeList");
                                                                                    System.out.println("list size is " + codeList.size());
                                                                                    int count;
                                                                                    for (int j = 0; j < codeList.size(); j++) {
                                                                                        codeListBean = (CodeListBean) codeList.get(j);


                                                                            %><tr> <td><input type="checkbox" id="check<%=j + 1%>" name="check<%=j + 1%>" onclick="selectAllCheck();"/></td>
                                                                        <input type="hidden" value="<%=codeListBean.getListName()%>" id="listName<%=j + 1%>" name="listName<%=j + 1%>"/>
                                                                        <input type="hidden" value="<%=codeListBean.getSender_id()%>" id="senderId<%=j + 1%>" name="senderId<%=j + 1%>"/>
                                                                        <input type="hidden" value="<%=codeListBean.getReceiver_id()%>" id="recId<%=j + 1%>" name="recId<%=j + 1%>"/>
                                                                        <input type="hidden" value="<%=codeListBean.getList_version()%>" id="listVersion<%=j + 1%>" name="listVersion<%=j + 1%>"/>
                                                                        <td><input value="<%=codeListBean.getSender_item()%>" id="senderItem<%=j + 1%>" name="senderItem<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getReceiver_item()%>" id="recItem<%=j + 1%>" name="recItem<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getDescription()%>" id="desc<%=j + 1%>" name="desc<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText1()%>" id="text1<%=j + 1%>" name="text1<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText2()%>" id="text2<%=j + 1%>" name="text2<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText3()%>" id="text3<%=j + 1%>" name="text3<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText4()%>" id="text4<%=j + 1%>" name="text4<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText5()%>" id="text5<%=j + 1%>" name="text5<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText6()%>" id="text6<%=j + 1%>" name="text6<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText7()%>" id="text7<%=j + 1%>" name="text7<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText8()%>" id="text8<%=j + 1%>" name="text8<%=j + 1%>"/></td>
                                                                        <td><input value="<%=codeListBean.getText9()%>" id="text9<%=j + 1%>" name="text9<%=j + 1%>"/></td>
                                                                            <%
                                                                                    }
                                                                                }%>
                                                                        </tbody>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td align="right" colspan="28" style="background-color: white;">
                                                                    <div align="right" id="pageNavPosition"></div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                        <%-- <input type="hidden" name="sec_po_list" id="sec_po_list" value="<%=list.size()%>"/> --%>
                                                    </div>
                                                </div>
                                                <%-- Grid End --%>
                                            </div>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="row col-sm-12">
                                        <center><div id="messagediv"></div> </center>
                                        <div class="col-sm-3"> 
                                            <label>New Code List Name</label>
                                            <s:textfield name="newname" id="newname" cssClass="form-control" value="%{newname}" tabindex="10"/> 
                                        </div> 
                                        <div class="col-sm-3" style="margin-top: 25px">

                                            <input type="button" class="btn btn-primary" value="New CodeList SI Import" id="import" tabindex="11" onclick="getRowValue(this.id)"/>

                                        </div>

                                        <div class=" col-sm-6" style="margin-top: 25px">
                                            <div class="col-sm-3 " style="margin-left: -10px"> 
                                                <input type="button" id="add" name="add" class="btn btn-primary" value="Add Row" tabindex="4"/>
                                            </div> 
                                            <div class="col-sm-3 " style="margin-left: -33px"> 
                                                <input type="button" class="btn btn-primary" value="Delete Row" id="deleteRow" tabindex="5" onclick="getRowValue(this.id)"/>
                                            </div>
                                            <div class="col-sm-3 " style="margin-left: -19px"> 
                                                <input type="button" class="btn btn-primary" value="Update Existing Codelist" id="update" tabindex="5" onclick="getUpdateRow()"/>
                                            </div>
                                            <div class="col-sm-3 " style="margin-left: 58px"> 
                                                <input type="button" id="clear" class="btn btn-primary" value="Clear Grid" tabindex="6"/>
                                            </div>

                                        </div>
                                    </div>



                            </div>
                            </section>
                            <%-- </s:if> --%>
                        </div>
                    </div></div>

            </div>
        </div>

        <!-- /Highlights -->
        <div>
            <s:include value="../includes/template/footer.jsp"/>
        </div>
        <!-- <script>
        $('input[name="daterange"]').daterangepicker();
        </script>-->
        <script language="JavaScript" src='<s:url value="/includes/js/DateValidation.js"/>'></script>
        <script language="JavaScript" src='<s:url value="/includes/js/GridNavigation.js"/>'></script>
        <script language="JavaScript" src='<s:url value="/includes/js/GeneralAjax.js"/>'></script>
        <script language="JavaScript" src='<s:url value="/includes/js/downloadAjax.js"/>'></script>

        <%-- <script src='<s:url value="../includes/plugins/daterangepicker/daterangepicker.js"/>'></script> --%>
        <script src='<s:url value="../includes/bootstrap/js/app.min.js"/>'></script>
        <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
        <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>

        <script type="text/javascript">


                                                    $(function () {
                                                        $('#deleteRow').click(function () {
                                                            $('input:checked').each(function () {
                                                                $(this).closest('tr').remove();
                                                            })
                                                        });

                                                    });

                                                    function getList()
                                                    {
                                                        var listName = document.getElementById("listName").value;
                                                        document.getElementById("selectedName").value = listName;
                                                        window.location = "../utilities/codeListSearch.action?listName=" + listName + "&selectedName=" + document.getElementById("selectedName").value;
                                                    }

                                                    function getRowValue(flag) {
                                                        var checkedCount = 0;
                                                        var ips = {"jsonData": []};
                                                        var rowCount = $('#results tr').length;
                                                        for (i = 1; i < rowCount; i++) {
                                                            if (document.getElementById('check' + i).checked) {
//                        if (document.getElementById("listName" + i).value == "")
//                        {
//                            if (flag == 'deleteRow') {
//                                document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please select rows with data  to delete</font>";
//                                return false;
//                            }
//                            document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please enter list name</font>";
//                            return false;
//                        }
//                        if (document.getElementById('listVersion' + i).value == "")
//                        {
//                            document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please enter list version</font>";
//                            return false;
//                        }else{
//                            var listVer = document.getElementById('listVersion' + i).value
//                             if(!listVer.match(/^\d+/)){
//                                  alert("Please only enter only numerics  in list version  (Allowed input:0-9)");
//                             }
//                             return false;
//                        }
                                                                var listName = "";
                                                                if (flag == 'deleteRow') {
                                                                    listName = document.getElementById("listName" + i).value;
                                                                    if (listName == "") {
                                                                        document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please select rows with data  to delete</font>";
                                                                        return false;
                                                                    }
                                                                } else if (flag == 'import')
                                                                {
                                                                    listName = document.getElementById("newname").value;
                                                                    if (listName == "") {
                                                                        document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please Enter New List Name</font>";
                                                                        return false;
                                                                    }
                                                                }
                                                                if (document.getElementById('senderItem' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please enter sender code</font>";
                                                                    return false;
                                                                }
                                                                if (document.getElementById('recItem' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please enter receiver code</font>";
                                                                    return false;
                                                                }
                                                                if (document.getElementById('desc' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please enter description</font>";
                                                                    return false;
                                                                }
                                                                ips["jsonData"].push({
                                                                    "listName1": listName,
                                                                    "senderIdInst": document.getElementById('senderId' + i).value,
                                                                    "recId": document.getElementById('recId' + i).value,
                                                                    "listVerson": document.getElementById('listVersion' + i).value,
                                                                    "senderItem": document.getElementById('senderItem' + i).value,
                                                                    "recItem": document.getElementById('recItem' + i).value,
                                                                    "text1": document.getElementById('text1' + i).value,
                                                                    "text2": document.getElementById('text2' + i).value,
                                                                    "text3": document.getElementById('text3' + i).value,
                                                                    "text4": document.getElementById('text4' + i).value,
                                                                    "desc": document.getElementById('desc' + i).value,
                                                                    "text5": document.getElementById('text5' + i).value,
                                                                    "text6": document.getElementById('text6' + i).value,
                                                                    "text7": document.getElementById('text7' + i).value,
                                                                    "text8": document.getElementById('text8' + i).value,
                                                                    "text9": document.getElementById('text9' + i).value
                                                                });
                                                                checkedCount++;
                                                            }
                                                        }

                                                        var array = JSON.stringify(ips["jsonData"]);
                                                        if (flag == 'import') {
                                                            if (checkedCount == 0)
                                                            {
                                                                document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please select rows to insert</font>";
                                                                return false;
                                                            }
                                                            window.location = "../utilities/codeListAdd.action?json=" + encodeURIComponent(array);
                                                        }
                                                        else if (flag == 'deleteRow')
                                                        {
                                                            if (checkedCount == 0)
                                                            {
                                                                document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please select rows to delete</font>";
                                                                return false;
                                                            }
                                                            window.location = "../utilities/codeListDelete.action?json=" + encodeURIComponent(array) + "&listName=" + document.getElementById('listName').value + "&selectedName=" + document.getElementById('selectedName').value;
                                                        }
                                                    }

                                                    function selectAllRecords() {
                                                        var rowCount = $('#results tr').length;
                                                        if (document.getElementById("checkboxAll").checked)
                                                        {
                                                            for (var i = 1; i < rowCount; i++) {

                                                                document.getElementById('check' + i).checked = true;
                                                            }
                                                        } else {
                                                            for (var i = 1; i < rowCount; i++) {
                                                                document.getElementById('check' + i).checked = false;
                                                            }
                                                        }
                                                    }

                                                    function getUpdateRow() {
                                                        var checkedCount = 0;
                                                        var ips = {"jsonData": []};
                                                        var rowCount = $('#results tr').length;
                                                        var listName;
                                                        //alert("rowCount"+rowCount);
                                                        for (i = 1; i < rowCount; i++) {
                                                            if (document.getElementById('check' + i).checked) {
                                                                checkedCount++;
                                                                if (i <= document.getElementById("items").value) {
//                                                                    listName = document.getElementById('listName' + i).value;
//                                                                }
//                                                                else
//                                                                {
                                                                    alert('listName----'+listName);
                                                                    listName = document.getElementById('listName1').value;
//                                                                    if (listName == "")
//                                                                    {
//                                                                        document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please Enter New List Name</font>";
//                                                                        return false;
//                                                                    }
                                                                    document.getElementById('senderId' + i).value = "";
                                                                    document.getElementById('recId' + i).value = "";
                                                                    document.getElementById('senderId' + i).value = "";
                                                                    document.getElementById('listVersion' + i).value = 1;
                                                                }
                                                                if (document.getElementById('senderItem' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>Please enter sender code</font>";
                                                                    return false;
                                                                }
                                                                if (document.getElementById('recItem' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please enter receiver code</font>";
                                                                    return false;
                                                                }
                                                                if (document.getElementById('desc' + i).value == "")
                                                                {
                                                                    document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please enter description</font>";
                                                                    return false;
                                                                }
                                                                ips["jsonData"].push({
                                                                    "listName1": listName,
                                                                    "senderIdInst": document.getElementById('senderId' + i).value,
                                                                    "recId": document.getElementById('recId' + i).value,
                                                                    "listVerson": document.getElementById('listVersion' + i).value,
                                                                    "senderItem": document.getElementById('senderItem' + i).value,
                                                                    "recItem": document.getElementById('recItem' + i).value,
                                                                    "text1": document.getElementById('text1' + i).value,
                                                                    "text2": document.getElementById('text2' + i).value,
                                                                    "text3": document.getElementById('text3' + i).value,
                                                                    "text4": document.getElementById('text4' + i).value,
                                                                    "desc": document.getElementById('desc' + i).value,
                                                                    "text5": document.getElementById('text5' + i).value,
                                                                    "text6": document.getElementById('text6' + i).value,
                                                                    "text7": document.getElementById('text7' + i).value,
                                                                    "text8": document.getElementById('text8' + i).value,
                                                                    "text9": document.getElementById('text9' + i).value
                                                                });

                                                            }


                                                        }
                                                        if (checkedCount == 0)
                                                        {
                                                            document.getElementById("messagediv").innerHTML = "<font class='text-danger'>please select rows to update</font>";
                                                            return false;
                                                        }
                                                        var array = JSON.stringify(ips["jsonData"]);
                                                        //alert(document.getElementById('listName').value );
                                                        window.location = "../utilities/codeVersionUpdate.action?listName=" + listName + "&json=" + encodeURIComponent(array);
                                                    }
                                                              function selectAllCheck() {
                                                        var rowCount = $('#results tr').length;
                                                            for (var i = 1; i < rowCount; i++) {
                                                                //alert('hiii');
                                                                if(document.getElementById('check' + i).checked == false){
                                                                    document.getElementById("checkboxAll").checked=false;
                                                                } 
                                                            }
                                                    
                                                    }

        </script> 
    </body>
</html>
