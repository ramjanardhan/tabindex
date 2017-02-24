<%@page import="com.mss.ediscv.logisticsloadtendering.LogisticsLoadBean"%>
<%-- <%@ page contentType="text/html" pageEncoding="UTF-8"%> --%>

<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page buffer="50kb" autoFlush="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>


<%@ taglib uri="/WEB-INF/tlds/dbgrid.tld" prefix="grd"%>
<%@ page import="com.freeware.gridtag.*"%>
<%@page import="java.sql.Connection"%>
<%@  page import="com.mss.ediscv.util.AppConstants"%>
<%@ page import="com.mss.ediscv.util.ConnectionProvider"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import = "java.util.ResourceBundle" %>

<!DOCTYPE html>
<html class=" js canvas canvastext geolocation crosswindowmessaging no-websqldatabase indexeddb hashchange historymanagement draganddrop websockets rgba hsla multiplebgs backgroundsize borderimage borderradius boxshadow opacity cssanimations csscolumns cssgradients no-cssreflections csstransforms no-csstransforms3d csstransitions  video audio localstorage sessionstorage webworkers applicationcache svg smil svgclippaths   fontface">
    <head>
        <title>Miracle Supply Chain Visibility portal</title>

        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="cache-control" content="no-cache" />

        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.5 -->

        <link rel="stylesheet" href='<s:url value="/includes/plugins/daterangepicker/daterangepicker.css"/>'/>
        <link rel="stylesheet" href='<s:url value="/includes/plugins/datatables/dataTables.bootstrap.css"/>' type="text/css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <%--   <script language="JavaScript"
        src='<s:url value="/includes/js/generalValidations.js"/>'></script>  --%>
        <script>
            function doOnLoad()
            {
                $("#purging").addClass("active");
                $("#purgeProcess i").addClass("text-red");

                document.getElementById('loadingAcoountSearch').style.display = "none";
            }
        </script>



    </head>
    <%
        String check = null;
        if (request.getAttribute("check") != null) {
            check = request.getAttribute("check").toString();
        }

        //System.out.println("check-->"+check);
    %>
    <body onload="doOnLoad();
            check();" class="hold-transition skin-blue sidebar-mini">
        <script type="text/javascript" src='<s:url value="/includes/js/wz_tooltip.js"/>'></script>
        <div>
            <s:include value="../includes/template/header.jsp"/>
        </div>
        <div>
            <s:include value="../includes/template/sidemenu.jsp"/>
        </div>
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->


            <!-- Main content --> 

            <section class="content-header">
                <h1>
                    Purge Process
                    <small>Purging</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-remove"></i>Purging</a></li>
                    <li class="active">Purge Process</li>
                </ol>
            </section>
            <br>

            <section class="content">

                <div class="box box-primary">
                    <div class="box-header with-border">
                        <div class="box-tools pull-right">

                        </div>
                    </div>  
                    <div class="box-body">
                        <div id="text">

                            <div style="alignment-adjust:central;" >
                                <%String contextPath = request.getContextPath();
                                %>

                                <s:form action="../purge/purgeProcess.action" method="post" name="purgeProcessForm" id="purgeProcessForm" theme="simple">
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="row">
                                                    
                                                    <%
                                                     //REQ_RESULT_MSG
                                                    if (request.getAttribute(AppConstants.REQ_RESULT_MSG) != null) {
                                                            String responseString = request.getAttribute(AppConstants.REQ_RESULT_MSG).toString();
                                                            //request.getSession(false).removeAttribute("responseString");
                                                            out.println(responseString);
                                                        }
                                                    %>
                                                    <div class="col-sm-3">
                                                        <label>Day count<font color="red">*</font></label>
                                                            <s:textfield  cssClass="form-control"   name="dayCount" id="dayCount"  tabindex="1" onblur="return validatenumber(this);"/>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <label>Transaction&nbsp;Type</label>
                                                        <s:select headerKey="-1" headerValue="Select Type" cssClass="form-control" list="#@java.util.LinkedHashMap@{'204':'Loadtender','990':'LTResponse','214':'LtShipment','210':'LtInvoice','850':'PO','856':'Shipments','810':'Invoice','820':'Payments'}" name="transType" id="transType" tabindex="2"/> 
                                                    </div>

                                                </div>
                                                <br>
                                                <div id="loadingAcoountSearch" class="loadingImg">
                                                    <span id ="LoadingContent" > <img src="<s:url value="/includes/images/Loader2.gif"/>"   ></span>
                                                </div>

                                            </div>
                                        </div>
                                        <br>
                                        <span id="span1">
                                        </span>
                                        <div class="row">






                                            <div class="col-sm-2"><s:submit value="Purge"  onclick="return checkValues();" tabindex="3" cssClass="btn btn-primary col-sm-12"/></div>

                                            <div class="col-sm-2"><strong><input type="reset" value="Reset"  tabindex="4" class="btn btn-primary col-sm-12" onclick="return resetvalues();"/></strong></div>

                                            <s:hidden name="sampleValue" id="sampleValue" value="2"/>

                                        </s:form>

                                    </div>
                                </div>
                            </div>
                        </div></div></div>
            </section>
            <div id="gridDiv">    






                <s:if test="#session.loadList != null"> 
                    <%--- GRid start --%>
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
                                            <table align="left" width="100%"
                                                   border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td style="background-color: white;">
                                                        <!--<div style="overflow-x:auto;">-->   
                                                        <table id="results"  class="table table-bordered table-hover">
                                                            <%
                                                                java.util.List list = (java.util.List) session.getAttribute(AppConstants.SES_LOAD_LIST);

                                                                if (list.size() != 0) {
                                                                    LogisticsLoadBean logisticsLoadBean;
                                                            %>
                                                            <input type="hidden" name="sec_lt_list" id="sec_lt_list" value="<%=list.size()%>"/> 
                                                            <thead><tr>
                                                                    <th >FileFormat</th> 
                                                                    <th >InstanceID</th>
                                                                    <th >Shipment</th>
                                                                    <th >Partner</th>

                                                                    <th >DateTime</th>
                                                                        <%-- <th >ISA #</th>  --%>

                                                                    <%-- <th >DOC_ORIGIN</th> --%>
                                                                    <th >TransType</th>
                                                                    <th >Direction</th>

                                                                    <th >Status</th>
                                                                        <%-- <th >ACK_STATUS</th>  --%>
                                                                    <th >Reprocess</th>
                                                                        <%
                                                                            // out.println(session.getAttribute(AppConstants.SES_ROLE_ID));

                                                                            if (session.getAttribute(AppConstants.SES_ROLE_ID).equals("100") || session.getAttribute(AppConstants.SES_ROLE_ID).equals("104")) {
                                                                        %>
                                                                    <th>#</th>
                                                                        <%}%>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <tr>

                                                                    <%
                                                                        for (int i = 0; i < list.size(); i++) {
                                                                            logisticsLoadBean = (LogisticsLoadBean) list.get(i);

                                                                            if (i % 2 == 0) {
                                                                                cssValue = "whiteStripe";
                                                                            } else {
                                                                                cssValue = "grayEditSelection";
                                                                            }
                                                                    %>
                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getFile_type() != null) {
                                                                                out.println(logisticsLoadBean.getFile_type());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getFile_id() != null) {
                                                                                out.println(logisticsLoadBean.getFile_id());
                                                                            } else {
                                                                                out.println("-");
                                                                            }

                                                                        %>
                                                                        <input type="hidden" name="Instance<%=i%>" id="Instance<%=i%>" value="<%=logisticsLoadBean.getFile_id()%>"/>  
                                                                    </td>

                                                                    <td><a href="javascript:getLoadTenderingDetails('<%=logisticsLoadBean.getFile_id()%>','<%=logisticsLoadBean.getPoNumber()%>');">

                                                                            <%
                                                                                if (logisticsLoadBean.getShipmentId() != null) {
                                                                                    out.println(logisticsLoadBean.getShipmentId());
                                                                                } else {
                                                                                    out.println("-");
                                                                                }


                                                                            %>
                                                                            <input type="hidden" name="text<%=i%>" id="text<%=i%>" value="<%=logisticsLoadBean.getShipmentId()%>"/>  
                                                                        </a>   
                                                                    </td>
                                                                    <td>
                                                                        <%                                                                            if (logisticsLoadBean.getPname() != null) {

                                                                                out.println(logisticsLoadBean.getPname());
                                                                            } else {
                                                                                out.println("-");
                                                                            }


                                                                        %>

                                                                    </td>


                                                                    <td>
                                                                        <%                                                                            if (logisticsLoadBean.getDate_time_rec() != null) {
                                                                                out.println(logisticsLoadBean.getDate_time_rec().toString().substring(0, logisticsLoadBean.getDate_time_rec().toString().lastIndexOf(":")));
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>  
                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getTransaction_type() != null) {
                                                                                out.println(logisticsLoadBean.getTransaction_type());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getDirection() != null) {
                                                                                out.println(logisticsLoadBean.getDirection());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>  


                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getStatus() != null) {
                                                                                if (logisticsLoadBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                                    out.println("<font color='red'>" + logisticsLoadBean.getStatus() + "</font>");
                                                                                } else if (logisticsLoadBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                                    out.println("<font color='green'>" + logisticsLoadBean.getStatus() + "</font>");
                                                                                } else {
                                                                                    out.println("<font color='orange'>" + logisticsLoadBean.getStatus() + "</font>");
                                                                                }
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>

                                                                    <td>
                                                                        <%
                                                                            if (logisticsLoadBean.getReProcessStatus() != null) {
                                                                                out.println(logisticsLoadBean.getReProcessStatus());

                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>

                                                                    <%
                                                                        if (session.getAttribute(AppConstants.SES_ROLE_ID).equals("100") || session.getAttribute(AppConstants.SES_ROLE_ID).equals("104")) {
                                                                    %>
                                                                    <td> &nbsp; &nbsp; 
                                                                        <input type = "checkbox" name ="check_List<%=i%>" id = "check_List<%=i%>" value="<%= logisticsLoadBean.getFile_id()%>"/>&nbsp; &nbsp;  
                                                                    </td> 
                                                                    <%
                                                                        }
                                                                    %>

                                                                </tr>  
                                                                <%
                                                                    }
                                                                } else {
                                                                %>
                                                                <tr><td>
                                                                        <%
                                                                                // String contextPath = request.getContextPath();
                                                                                // out.println("<img  border='0' align='top'  src='"+contextPath+"/includes/images/alert.gif'/><b> No Records Found to Display!</b>");
                                                                                out.println("<img  border='0' align='top'  src='" + contextPath + "/includes/images/alert.gif'/><b>No records found for the given search criteria. Please try a different search criteria!</b>");
                                                                            }

                                                                        %>
                                                                    </td>
                                                                </tr>
                                                        </table>

                                                    </td>
                                                </tr>
                                                <%                                                    if (list.size() != 0) {
                                                %>
                                                <tr >
                                                    <!--                                                                        <td align="right" colspan="28" style="background-color: white;">
                                                                                                                                <div align="right" id="pageNavPosition"></div>-->
                                                    </td>
                                                </tr> 

                                                <% }%>
                                                </tbody>
                                            </table>

                                        </div>



                                        <%-- Process butttons  start --%>
                                        <%
                                            // out.println(session.getAttribute(AppConstants.SES_ROLE_ID));

                                            if ((session.getAttribute(AppConstants.SES_ROLE_ID).equals("100") || session.getAttribute(AppConstants.SES_ROLE_ID).equals("104")) && list.size() != 0) {
                                        %><br>
                                        <div class="row" style="margin-left: 65%">
                                            <strong><input type="button" value="ReTransmit" class="btn btn-effect-ripple btn-primary" onmouseover="Tip('Click here to ReTransmit.')" onmouseout="UnTip()" onclick="return getloadTenderProcess(this, document.getElementById('sec_lt_list').value);" id="pre"/></strong>
                                            <strong><input type="button" value="ReSubmit" class="btn btn-effect-ripple btn-primary" onmouseover="Tip('Click here to Resubmit.')" onmouseout="UnTip()" onclick="return getloadTenderProcess(this, document.getElementById('sec_lt_list').value);" id="post"/></strong>
                                            <strong><input type="button" value="LifeCycle" class="btn btn-effect-ripple btn-primary" onmouseover="Tip('Click here to life cycle.')" onmouseout="UnTip()" onclick="return getLifeCycle(document.getElementById('sec_lt_list').value, 'logistics');" id="post"/></strong>
                                            <strong><input type="button" value="Generate Excel" class="btn btn-effect-ripple btn-primary" onclick="return gridDownload('loadTendering', 'xls');" onmouseover="Tip('Click here to generate an excel Report.')" onmouseout="UnTip()" id="excel"/> </strong>  
                                        </div>

                                        <%}%>
                                        <%-- process buttons end--%>

                                    </div>
                                </div></div>
                        </div></section>
                    </s:if> 

            </div> 
            <script>
                $(function () {
                    // $("#example1").DataTable();
                    $('#results').DataTable({
                        "paging": true,
                        "lengthChange": true,
                        "searching": true,
                        "ordering": true,
                        "info": true,
                        "autoWidth": false
                    });
                });
            </script>
            <div id="hide-menu1" class="hide-menu message ">

                <div class="row col-sm-12">

                    <br>
                    <div class="col-sm-6"> <label class="labelw"> Instance Id #: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="instanceid" name="instanceid" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> Shipment #: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="shipment" name="shipment" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12"> <br>
                    <div class="col-sm-6"> <label class="labelw"> Total Weight: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="totWeight" name="totWeight" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> Volume: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="Volume" name="Volume" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12">
                    <div class="col-sm-6"> <label class="labelw"> Document Type </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="documenttype" name="documenttype" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">Transaction Type </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="transactiontype" name="transactiontype" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12">
                    <div class="col-sm-6"> <label class="labelw"> Pieces: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="pieces" name="pieces" readonly="true"/>
                    </div>
                </div>
                <br>
                <div id="senderinfo">
                    <div class="row col-sm-12">
                        <div class="col-sm-6"> <h4>Partner Info :</h4></div>
                        <div class="col-sm-6"></div>
                        <div class="col-sm-6"></div>

                    </div>
                    <br>
                    <div class="row col-sm-12">
                        <div class="col-sm-6"> <label class="labelw">  Id: </label>
                            <s:textfield cssClass="form-control"  required="required" placeholder="" id="senderid" name="senderid" readonly="true"/>
                        </div>
                        <div class="col-sm-6"> <label class="labelw"> Name: </label>
                            <s:textfield cssClass="form-control"  required="required" placeholder="" id="sendername" name="sendername" readonly="true"/>
                        </div>
                    </div>
                </div>
                <br>
                <div id="receiverinfo">
                    <div class="row col-sm-12">
                        <div class="col-sm-6"> <h4>Receiver Info:</h4></div>
                        <div class="col-sm-6"></div>
                        <div class="col-sm-6"></div>
                    </div>

                    <br>
                    <div class="row col-sm-12 clear">
                        <div class="col-sm-6"> <label class="labelw">  Id: </label>
                            <s:textfield cssClass="form-control"  required="required" placeholder="" id="receiverid" name="receiverid" readonly="true"/>
                        </div>
                        <div class="col-sm-6"> <label class="labelw"> Name: </label>
                            <s:textfield cssClass="form-control"  required="required" placeholder="" id="receivername" name="receivername" readonly="true"/>
                        </div>
                    </div>
                </div>
                <div class="row col-sm-12 clear">
                    <div class="col-sm-6"> <label class="labelw">  ISA #: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="isa" name="isa" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> GS #: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="gs" name="gs" readonly="true"/>
                    </div>
                </div>

                <br/>

                <div class="row col-sm-12" style="margin-top:10px;" >
                    <div class="col-sm-6"> <label class="labelw">  ST #: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="st" name="st" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">ISA DATE: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="isadate" name="isadate" readonly="true"/>
                    </div>

                    <div class="col-sm-6"> <label class="labelw">  ISA TIME:  </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="isatime" name="isatime" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> STATUS: </label>
                        <s:textfield cssClass="form-control"  required="required" placeholder="" id="togglestatus" name="status" readonly="true"/>
                    </div>
                </div>

                <div class="row col-sm-12" >
                    <div class="col-sm-6"> <label class="labelw">  Pre Translation:  </label></div>
                    <div class="col-sm-6"> <div id="pretranslation"> </div></div>
                </div>
                <div class="row col-sm-12">     
                    <div class="col-sm-6"> <label class="labelw"> Post Translation: </label></div>
                    <div class="col-sm-6">   <div id="posttranslation"></div></div>
                </div>
                <div class="row col-sm-12">
                    <div class="col-sm-6"> <label class="labelw"> Ack FileId: </label></div>
                    <div class="col-sm-6">    <div id="ackfileid"></div></div>
                </div>
                <br><br><br><br><br><br>
                <div class="row col-sm-12" >
                    <div class="col-sm-6"> <label class="labelw"> Error Message </label></div>
                    <div id="errormessage" style="color:red;"></div>
                </div>
                <div id="noresult"></div>
                <div class="col-sm-12">   <button type="button" class="btn btn-primary col-sm-11" style="margin-left:12px; " id="hide-menu" onclick="hide()" value="X">Close</button></div>
            </div>  </div>



    </div>
    <div>
        <s:include value="../includes/template/footer.jsp"/>
    </div>


    <script>
        $('input[name="daterange"]').daterangepicker();
    </script>
    <script language="JavaScript" src='<s:url value="/includes/js/DateValidation.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/GeneralAjax.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/downloadAjax.js"/>'></script>
    <script language="JavaScript" src='<s:url value="/includes/js/Correlation.js"/>'></script>
    <script type="text/javascript" src='<s:url value="../includes/js/lifeCycle.js"/>'></script>
    <script src='<s:url value="../includes/bootstrap/js/bootstrap.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/daterangepicker/daterangepicker.js"/>'></script>
    <script src='<s:url value="../includes/bootstrap/js/app.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>

    <script type="text/javascript">

        function checkValues() {
            var returnType = false;
            var days = document.getElementById('dayCount').value;
            var transactionType = document.getElementById('transType').value;
            if (transactionType == "-1")
                transactionType = "All";
            if (days != "") {
                var r = confirm("Confirm to delete " + days + " days before " + transactionType + " transaction records");
                if (r == true)
                {
                    returnType = true;
                }
                else
                {
                    returnType = false;
                }
                return returnType;
            } else {
                alert("Please enter days count !");
                return false;
            }

        }
        function resetvalues()
        {
            document.getElementById('dayCount').value = "";
            document.getElementById('transType').value = "-1";

            $('#detail_box').hide();
            $('#gridDiv').hide();

        }


    </script>
</body>

</html>
