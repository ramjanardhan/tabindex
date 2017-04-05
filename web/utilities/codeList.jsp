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
            }
        </script>
        <style>
            @media  (min-width: 992px) and (max-width: 1192px) {
                #set_align1{
                    margin: 0 -13px !important;
                }
            }
        </style>



    </head>

    <body class="hold-transition skin-blue sidebar-mini" onload="doOnLoad()">    
        <script type="text/javascript" src='<s:url value="/includes/js/wz_tooltip.js"/>'></script>
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
                    <li><a href="#"><i class="fa fa-gavel"></i>Code List Editor</a></li>
                    <li class="active">Code List</li>
                </ol>
            </section>
         <section class="content">
         <!--  <h3>Trading Partner</h3> -->		
            <!-- Highlights - jumbotron -->
            <div id="site_content"  style="padding-top: 9px;  width:50%;float: left">
                <div class="box box-primary">
                    
                    <div class="box-body">
                    <s:form action="../admin/getCodeListName.action" method="post" cssClass="contact-form" name="certForm" id="certForm" theme="simple">
                        <div class="">
                            <div class="row">
                                <div class="col-sm-3">
                                    <label>Name Search</label>
                                    <s:textfield name="name"  id="name" cssClass="form-control"   value="%{name}" style="width : 250%;" tabindex="1"/> 
                                </div>
                                <div class="col-sm-6" style="float : right; bottom: -25px;margin-right: -102px">  
                                    <div>
                                        <s:submit value="Search" cssClass="btn btn-primary" id="button" name="button" tabindex="2" /> 
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-3"> 
                                    <label>Code List </label>
                                    <s:select headerKey="-1" headerValue="--Select Type--" cssClass="form-control" list="{'','',''}" name="listName" id="listName" value="%{listName}"  onchange="getList();"  style="width : 250%;" tabindex="3"/> 
                                </div> 
                            </div> 
                    </div>
                
                                
                <br>
                <div class="row" id="site_content" style="float :right;top: 50%">


                    <div class="col-sm-3" style="left : 372px; bottom : 5px"> 
                        <input type="button" id="add" name="add" class="btn btn-primary" value="Add Row" tabindex="4"/>
                    </div> 
                    <div class="col-sm-3" style="left : 413px; bottom : 5px"> 
                        <input type="button" class="btn btn-primary" value="Delete Row" id="deleteRow" tabindex="5"/>
                    </div> 
                    <div class="col-sm-3" style="left : 471px; bottom : 5px"> 
                        <input type="button" class="btn btn-primary" value="Clear Grid" tabindex="6"/>
                    </div> 
                </div>
                </div>
                </div>
                </div>
</section>
        
        <br>
        <br>
        <section class="content" style="float : left">
        <div class="container">
            <div id="site_content" class="jumbotron block_div" style="padding-top: 9px;width : 106%;float : right">
                <div class="box box-primary">
                    
                    <div class="box-body">
                    <div class="row">
                        <div class="col-sm-3">
                            <label>Code List Selected</label>
                            <s:textfield name="selectedName"  id="selectedName" cssClass="form-control"   value="%{selectedName}" tabindex="7"/> 
                        </div>
                        <div>
                            <div class="col-sm-3" style="left:251px">
                                <label>Sender Identity</label>
                                <s:select headerKey="-1" headerValue="--Select Type--" cssClass="form-control" list="{'','',''}" name="listName1" id="senderId" value="%{listName}" tabindex="8" /> 
                            </div>
                            <div class="col-sm-3" style="left: 282px">
                                <label>Receiver Identity</label>
                                <s:select headerKey="-1" headerValue="--Select Type--" cssClass="form-control" list="{'','',''}" name="listName2" id="receiverId" value="%{listName}"  tabindex="9"/> 
                            </div>
                        </div>
                    </div>
                    <br>
                    <br>
                    <div class="row">
                        <div class="col-sm-3">
                            <label>Last Date Modified :</label>

                        </div><div>
                            <label style="margin-left: 494px">Number Of Code List Items :</label>

                        </div>
                    </div>  
                    
                   
                </s:form>
            <div id="gridDiv">  
                <%--  <s:if test="#session.codeList != null"> 
                       GRid start --%>
                <section class="content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box">
                                <div class="box-header">
                                    <h3 class="box-title">Table</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <%!String cssValue = "whiteStripe";
                                        int resultsetTotal;%>
                                    <div style="overflow-x:auto;">
                                        <table align="left" width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="background-color: white;">
                                                    <table id="results"  class="table table-bordered table-hover">
                                                        <thead><tr>
                                                                <th>SELECT</th>
                                                                <th>LIST_NAME</th>
                                                                <th>SENDER_ID</th>
                                                                <th>RECEIVER_ID</th>
                                                                <th>LIST_VERSION</th>
                                                                <th>SENDER_ITEM</th>
                                                                <th>RECEIVER_ITEM</th>
                                                                <th>TEXT1</th>
                                                                <th>TEXT2</th>
                                                                <th>TEXT3</th>
                                                                <th>TEXT4</th>
                                                                <th>DESCRIPTION</th>
                                                                <th>TEXT5</th>
                                                                <th>TEXT6</th>
                                                                <th>TEXT7</th> 
                                                                <th>TEXT8</th> 
                                                                <th>TEXT9</th> 
                                                            </tr> </thead>
                                                        <tbody>

                                                            <%if (session.getAttribute("codeList") != null) {
                                                                    java.util.List codeList = new java.util.ArrayList();
                                                                    //CodeListBean codeListBean=null;
                                                                    codeList = (java.util.List) session.getAttribute("codeList");
                                                                    System.out.println("list size is " + codeList.size());
                                                                    int count;
                                                                    for (int j = 0; j < codeList.size(); j++) {
                                                                      //  CodeListBean codeListBean = (CodeListBean) codeList.get(j);


                                                            %><tr>   <td><input type="checkbox"  id="check<%=j + 1%>" name="check<%=j + 1%>"/></td>
<%--                                                                <td><input value="<%=codeListBean.getListName()%>" id="listName<%=j + 1%>" name="listName<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getSender_id()%>" id="senderId<%=j + 1%>" name="senderId<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getReceiver_id()%>" id="recId<%=j + 1%>" name="recId<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getList_version()%>" id="listVersion<%=j + 1%>" name="listVersion<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getSender_item()%>" id="senderItem<%=j + 1%>" name="senderItem<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getReceiver_item()%>" id="recItem<%=j + 1%>" name="recItem<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText1()%>" id="text1<%=j + 1%>" name="text1<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText2()%>" id="text2<%=j + 1%>" name="text2<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText3()%>" id="text3<%=j + 1%>" name="text3<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText4()%>" id="text4<%=j + 1%>" name="text4<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getDescription()%>" id="desc<%=j + 1%>" name="desc<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText5()%>" id="text5<%=j + 1%>" name="text5<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText6()%>" id="text6<%=j + 1%>" name="text6<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText7()%>" id="text7<%=j + 1%>" name="text7<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText8()%>" id="text8<%=j + 1%>" name="text8<%=j + 1%>"/></td>
                                                                <td><input value="<%=codeListBean.getText9()%>" id="text9<%=j + 1%>" name="text9<%=j + 1%>"/></td>--%>
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
                                        <%--  <input type="hidden" name="sec_po_list" id="sec_po_list" value="<%=list.size()%>"/> --%>
                                    </div>
                                </div>
                                <%-- Grid End --%>
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="row">
                        <div class="col-sm-3"> 
                            <label>New Code List Name</label>
                            <s:textfield name="newname"  id="newname" cssClass="form-control"   value="%{newname}" tabindex="10"/> 
                        </div>  

                        <div> 
                            <input type="button" class="btn btn-primary pull-right" style="margin-right: 91px;margin-top: 20px;" value="Import To SI" tabindex="11" onclick="getRowValue()"/>
                        </div> 


                    </div>
                </section>
                <%--     </s:if>  --%>
            </div>
                    </div></div>
                            </section>

        </div>
    </div>
    </div>
    <!-- /Highlights -->
    <div>
        <s:include value="../includes/template/footer.jsp"/>
    </div>
<!--    <script>
        $('input[name="daterange"]').daterangepicker();
    </script>-->
    <script language="JavaScript" src='<s:url value="/includes/js/DateValidation.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/GridNavigation.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/GeneralAjax.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/downloadAjax.js"/>'></script>

 <%--   <script src='<s:url value="../includes/plugins/daterangepicker/daterangepicker.js"/>'></script> --%>
    <script src='<s:url value="../includes/bootstrap/js/app.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>

    <script>
        function validateCertType()
        {
            var certType = document.getElementById('certType').value;
            if (certType == "-1")
            {
                alert("please select certificate type");
                return false;
            }
            return true;
        }


        function resetvalues()
        {
            document.getElementById('docdatepickerfrom').value = "";
            document.getElementById('docdatepicker').value = "";
            document.getElementById('certType').value = "-1";
            document.getElementById('reportrange').value = "";
            $('#gridDiv').hide();



        }





    </script>
</body>
</html>
