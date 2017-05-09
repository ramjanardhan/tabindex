<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page buffer="50kb" autoFlush="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@page import="com.mss.ediscv.payments.PaymentBean"%>
<%@ taglib uri="/WEB-INF/tlds/dbgrid.tld" prefix="grd"%>
<%@ page import="com.freeware.gridtag.*"%>
<%@page import="java.sql.Connection"%>
<%@  page import="com.mss.ediscv.util.AppConstants"%>
<%@ page import="com.mss.ediscv.util.ConnectionProvider"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import = "java.util.ResourceBundle" %>
<%@page buffer="50kb" autoFlush="true" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <meta http-equiv="pragma" content="no-cache" />
        <meta http-equiv="cache-control" content="no-cache" />
        <title>Miracle Supply Chain Visibility Portal</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <!-- Bootstrap 3.3.5 -->
        <link rel="stylesheet" href='<s:url value="/includes/bootstrap/css/userdefined.css"/>'>
        <link rel="stylesheet" href='<s:url value="/includes/bootstrap/css/bootstrap.min.css"/>' type="text/css">
        <link rel="stylesheet" href='<s:url value="/includes/plugins/datatables/dataTables.bootstrap.css"/>' type="text/css">
        <link rel="stylesheet" href='<s:url value="/includes/plugins/daterangepicker/daterangepicker.css"/>' type="text/css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <style>
            #pay_buttons{
                display: inline-block;
                float: right;
            }
        </style>
        <script>
         $(function() {
                // $("#example1").DataTable();
                $('#results').DataTable({
                    "paging": true,
                    "lengthChange": true,
                    "searching": true,
                    "ordering": true,
                    "info": true,
                    "autoWidth": false,
                    order: [[0, 'desc']]
                });
            });
            function doOnLoad() {
                $("#payments").addClass("active");
                $("#financials").addClass("active");
                $("#manufacturing").addClass("active");
                $("#payments i").addClass("text-red");
                document.getElementById('loadingAcoountSearch').style.display = "none";
            }
        </script>
    </head>
    <%
        String check = null;
        if (request.getAttribute("check") != null) {
            check = request.getAttribute("check").toString();
        }
    %>

    <body class="hold-transition skin-blue sidebar-mini" onload="doOnLoad();
            check();">
        <script type="text/javascript" src='<s:url value="/includes/js/wz_tooltip.js"/>'></script>
        <script type="text/javascript">
        function check() {
            var value1 = document.getElementById("corrattribute1").value;
            if (value1 != "-1")
                document.getElementById("corr").style.display = "block";
            else
                document.getElementById("corr").style.display = "none";
        }
        </script>
        <div>
            <s:include value="../includes/template/header.jsp"/>
        </div>
        <div>
            <s:include value="../includes/template/sidemenu.jsp"/>
        </div>
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <!-- Main content --> 
            <section class="content-header">
                <h1>Payments
<!--                    <small>Manufacturing</small>-->
                </h1>
<!--                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-wrench"></i>Manufacturing</a></li>
                    <li class="active">Payments</li>
                </ol>-->
            </section>
            <br>
            <section class="content">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <div class="box-tools pull-right"></div>
                    </div>  
                    <div class="box-body">
                        <div id="text">
                            <div  style="alignment-adjust:central;" >
                                <% String contextPath = request.getContextPath(); %>
                                <s:form action="../payment/paymentSearch.action" method="post" name="paymentForm" id="paymentForm" theme="simple">
                                    <s:hidden id="paDateFrom" name="paDateFrom" />
                                    <s:hidden id="paDateTo" name="paDateTo"/>
                                    <div class="form-group">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="row">
                                                    <div class="col-sm-3"><label>Database&nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;</label>
                                                        <s:radio cssClass="myRadio" id="database" name="database" value="%{database}" list="#@java.util.LinkedHashMap@{'MSCVP':'LIVE','ARCHIVE':'ARCHIVE'}"/>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col-sm-3"> <label for="reportrange">Date Range</label>
                                                        <s:textfield name="reportrange"  id="reportrange" cssClass="form-control pull-left"   value="%{reportrange}" onchange="MyDate();" tabindex="1"/> 
                                                    </div>

                                                    <script type="text/javascript">
                                                        function MyDate() {
                                                            var date = document.paymentForm.reportrange.value;
                                                            var arr = date.split("-");
                                                            var x = arr[1].trim();
                                                            document.getElementById("paDateFrom").value = arr[0];
                                                            document.getElementById("paDateTo").value = x;
                                                        }
                                                    </script>

                                                    <div  class="col-sm-3">
                                                        <label for="docType">Document Type</label> 
                                                        <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="{'820'}" name="docType" id="docType" value="%{docType}" tabindex="2"/>
                                                    </div>

                                                    <div  class="col-sm-3">
                                                        <label for="docSenderId">Sender Id</label>  
                                                        <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="senderIdList" name="paSenderId" id="paSenderId" value="%{paSenderId}" tabindex="3" />
                                                    </div>

                                                    <div  class="col-sm-3">
                                                        <label for="docSenderName">Sender Name</label>  
                                                        <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="senderNameList" name="paSenderName" id="paSenderName" value="%{paSenderName}" tabindex="4" />
                                                    </div>
                                                </div>
                                                <br>
                                                <div class="row">
                                                    <div class="col-sm-3">
                                                        <label for="docBusId">Receiver Id</label>
                                                        <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="receiverIdList" name="paRecId" id="paRecId" value="%{paRecId}" tabindex="5" />
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <label for="docRecName">Receiver Name</label>
                                                        <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="receiverNameList" name="paRecName" id="paRecName" value="%{paRecName}" tabindex="6" />
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <label for="ackStatus">Ack Status</label>
                                                        <s:select headerKey="-1" headerValue="Select Type" cssClass="form-control" list="{'Overdue','Accepted','Rejected'}" name="ackStatus" id="ackStatus" value="%{ackStatus}" tabindex="7" /> 
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <label for="status">Status</label>
                                                        <s:select headerKey="-1" headerValue="Select Type" cssClass="form-control" list="{'Success','Error','Warning'}" name="status" id="status" value="%{status}" tabindex="8" /> 
                                                    </div>
                                                </div>
                                                <br>
                                                <div class="row">
                                                    <div class="col-sm-3">
                                                        <label for="corrattribute">Correlation</label>
                                                        <s:select headerKey="-1" headerValue="Select Attribute" cssClass="form-control" list="correlationList" name="corrattribute" id="corrattribute" value="%{corrattribute}" tabindex="9" />
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <label for="corrvalue">Value</label>
                                                        <s:textfield cssClass="form-control" name="corrvalue" id="corrvalue" value="%{corrvalue}" tabindex="10"/>
                                                    </div>
                                                    <div class="col-sm-3"><br>
                                                        <button  type="button" id="addButton" name="addButton" value="Add Div" class="btn btn-success"   style="margin-top:6px ;" tabindex="11"><i class="fa fa-plus"></i></button>
                                                        &nbsp; <label>Add Filter</label>
                                                    </div>
                                                    <div id="loadingAcoountSearch" class="loadingImg">
                                                        <span id ="LoadingContent" > <img src="<s:url value="/includes/images/Loader2.gif"/>"   ></span>
                                                    </div>
                                                </div>  
                                                <script>
                                                    var count = 0;
                                                </script>
                                                <div id="corr" style="display: none">
                                                    <br>   <div class="row">
                                                        <div class="col-sm-3">
                                                            <label for="corrattribute1">Correlation</label>
                                                            <s:select headerKey="-1" headerValue="Select Attribute" cssClass="form-control" list="correlationList" name="corrattribute1" id="corrattribute1" value="%{corrattribute1}" tabindex="12"/>
                                                        </div>
                                                        <div class="col-sm-3">
                                                            <label for="corrvalue1">Value</label>
                                                            <s:textfield cssClass="form-control" name="corrvalue1" id="corrvalue1" value="%{corrvalue1}" tabindex="13"/>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div> </div>
                                        <div>
                                            <br>
                                            <div class="row">
                                                <s:hidden name="sampleValue" id="sampleValue" value="2"/>
                                                <div class="col-sm-2"><s:submit value="Search"  onclick="return checkCorrelation();" cssClass="btn btn-primary col-sm-12" tabindex="14"/></div>
                                                <div class="col-sm-2"><strong><input type="button" value="Reset"   class="btn btn-primary col-sm-12" onclick="return resetValuesPayments();" tabindex="15"/></strong></div>
                                                    </s:form>
                                        </div>
                                    </div>
                                </div>
                            </div></div>
                    </div>
            </section>
            <!-- ./wrapper -->
            <div id="gridDiv">
                <s:if test="#session.paymentSearchList != null">
                    <%!String cssValue = "whiteStripe";
                        int resultsetTotal;%>

                    <section class="content">
                        <div class="row">
                            <div class="col-xs-12">
                                <div class="box">
                                    <div class="box-header">
                                        <h3 class="box-title">Table</h3>
                                    </div>
                                    <div class="box-body">

                                        <div style="overflow-x:auto;">                 

                                            <table align="left" width="100%"
                                                   border="0" cellpadding="0" cellspacing="0" >
                                                <tr>
                                                    <td style="background-color: white;">

                                                        <table  id="results" class="table table-bordered table-hover">
                                                            <%
                                                                java.util.List list = (java.util.List) session.getAttribute(AppConstants.SES_PAYMENT_LIST);

                                                                if (list.size() != 0) {

                                                                    PaymentBean paymentBean;
                                                            %>
                                                            <input type="hidden" name="sec_payment_list" id="sec_payment_list" value="<%=list.size()%>"/>
                                                            <thead> <tr>
                                                                    <th >DateTime</th>
                                                                    <th>Partner</th>
                                                                    <th >InstanceId</th>
                                                                    <th>PO #</th>
                                                                    <th>Inv #</th>
                                                                    <th>Cheque #</th>
                                                                    <th>Cheque&nbsp;Amount</th>
                                                                    <th>Status</th>
                                                                    <th>Ack&nbStatus</th>
                                                                </tr></thead>
                                                            <tbody>
                                                                <tr>
                                                                    <%
                                                                        for (int i = 0; i < list.size(); i++) {
                                                                            paymentBean = (PaymentBean) list.get(i);
                                                                            if (i % 2 == 0) {
                                                                                cssValue = "whiteStripe";
                                                                            } else {
                                                                                cssValue = "grayEditSelection";
                                                                            }
                                                                    %>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getDate_time_rec().toString().substring(0, paymentBean.getDate_time_rec().toString().lastIndexOf(":")) != null
                                                                                    && !"".equals(paymentBean.getDate_time_rec().toString().substring(0, paymentBean.getDate_time_rec().toString().lastIndexOf(":")))) {
                                                                                out.println(paymentBean.getDate_time_rec().toString().substring(0, paymentBean.getDate_time_rec().toString().lastIndexOf(":")));
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getReceiverName() != null && !"".equals(paymentBean.getReceiverName())) {
                                                                                out.println(paymentBean.getReceiverName());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>
                                                                    </td>
                                                                    <td><a href="javascript:getPaymentDetails(<%=paymentBean.getFileId()%>);" >
                                                                            <%
                                                                                if (paymentBean.getFileId() != null && !"".equals(paymentBean.getFileId())) {
                                                                                    out.println(paymentBean.getFileId());
                                                                                } else {
                                                                                    out.println("-");
                                                                                }
                                                                            %>
                                                                            <input type="hidden" name="Instance<%=i%>" id="Instance<%=i%>" value="<%=paymentBean.getFileId()%>"/>
                                                                        </a>
                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getPonumber() != null && !"".equals(paymentBean.getPonumber())) {
                                                                                out.println(paymentBean.getPonumber());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>
                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getInvNumber() != null && !"".equals(paymentBean.getInvNumber())) {
                                                                                out.println(paymentBean.getInvNumber());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>

                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getCheckNumber() != null && !"".equals(paymentBean.getCheckNumber())) {
                                                                                out.println(paymentBean.getCheckNumber());
                                                                            } else {
                                                                                out.println("-");
                                                                            }

                                                                        %>
                                                                        <input type="hidden" name="text<%=i%>" id="text<%=i%>" value="<%=paymentBean.getCheckNumber()%>"/>

                                                                    </td> 


                                                                    <td>
                                                                        <%

                                                                            if (paymentBean.getCheckAmount() != null && !"".equals(paymentBean.getCheckAmount())) {
                                                                                out.println("$" + paymentBean.getCheckAmount());
                                                                            } else {
                                                                                out.println("-");
                                                                            }
                                                                        %>
                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            if (paymentBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                                out.println("<font color='red'>" + paymentBean.getStatus().toUpperCase() + "</font>");
                                                                            } else if (paymentBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                                out.println("<font color='green'>" + paymentBean.getStatus().toUpperCase() + "</font>");
                                                                            } else {
                                                                                out.println("<font color='orange'>" + paymentBean.getStatus().toUpperCase() + "</font>");
                                                                            }
                                                                        %>
                                                                    </td>
                                                                    <td>
                                                                        <%
                                                                            //out.println(invoiceBean.getAckStatus());
                                                                            if (paymentBean.getAckStatus().equalsIgnoreCase("REJECT")) {
                                                                                out.println("<font color='red'>" + paymentBean.getAckStatus().toUpperCase() + "</font>");
                                                                            } else if (paymentBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                                out.println("<font color='green'>" + paymentBean.getAckStatus().toUpperCase() + "</font>");
                                                                            } else {
                                                                                out.println("<font color='orange'>" + paymentBean.getAckStatus().toUpperCase() + "</font>");
                                                                            }
                                                                        %>

                                                                    </td>
                                                                </tr>
                                                                <%
                                                                    }
                                                                } else {
                                                                %>
                                                                <tr><td>
                                                                        <%
                                                                                //out.println("<img  border='0' align='top'  src='"+contextPath+"/includes/images/alert.gif'/><b> No Records Found to Display!</b>");
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

                                                <tr>
                                                    <!--<td align="right" colspan="28" style="background-color: white;">-->
                                                    <!--<div align="right" id="pageNavPosition"></div>-->
                                                    </td>
                                                </tr>

                                                <%}%> </tbody>
                                            </table>
                                        </div>

                                        <%
                                            if (list.size() != 0) {
                                        %>
                                        <br>
                                        <div class="row">
                                            <div id="pay_buttons">
                                                <div class="col-sm-2" ><input type="button" value="Generate Excel" class="btn btn-effect-ripple btn-primary" onclick="return gridDownload('payment', 'xls');" onmouseover="Tip('Click here to generate an excel Report.')" onmouseout="UnTip()" id="excel"/></div>
                                            </div> 
                                        </div>

                                        <%}%>

                                    </div>

                                </div> </div>                          
                        </div>

                    </section>

                </s:if> 
            </div>

            <div id="hide-menu1" class="hide-menu message ">

                <div class="row col-sm-12">
                    <br>
                    <div class="col-sm-6"> <label class="labelw"> Instance Id </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="instanceid" name="Full Name" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> Cheque # </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="Check_Number" name="Check_Number" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12">
                    <div class="col-sm-6"> <label class="labelw"> PO # </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="po" name="po" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> Invoice # </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="invoice" name="invoice" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12">
                    <div class="col-sm-6"> <label class="labelw"> Document Type </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="documenttype" name="documenttype" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">Transaction Type </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="transactiontype" name="transactiontype" readonly="true"/>
                    </div>
                </div>
                <br>
                <div id="senderinfo">
                    <div class="row col-sm-12">
                        <div class="col-sm-6"> <h4>Sender Info :</h4></div>
                        <div class="col-sm-6"></div>
                        <div class="col-sm-6"></div>

                    </div>
                    <br>
                    <div class="row col-sm-12">
                        <div class="col-sm-6"> <label class="labelw">  Id </label>
                            <input type="Text"  class="form-control"  required="required" placeholder="" id="senderid" name="senderid" readonly="true"/>
                        </div>
                        <div class="col-sm-6"> <label class="labelw"> Name </label>
                            <input type="Text"  class="form-control"  required="required" placeholder="" id="sendername" name="sendername" readonly="true"/>
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
                        <div class="col-sm-6"> <label class="labelw">  Id </label>
                            <input type="Text"  class="form-control"  required="required" placeholder="" id="receiverid" name="receiverid" readonly="true" />
                        </div>
                        <div class="col-sm-6"> <label class="labelw"> Name </label>
                            <input type="Text"  class="form-control"  required="required" placeholder="" id="receivername" name="receivername" readonly="true"/>
                        </div>
                    </div>
                </div>
                <div class="row col-sm-12 clear">
                    <br>
                    <div class="col-sm-6"> <label class="labelw">  ISA #</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="isa" name="isa" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> GS #</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="gs" name="gs" readonly="true"/>
                    </div>
                </div>    

                <div class="row col-sm-12" >
                    <div class="col-sm-6"> <label class="labelw">  ST #</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="st" name="st" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">ISA DATE </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="isadate" name="isadate" readonly="true"/>
                    </div>

                    <div class="col-sm-6"> <label class="labelw">  ISA TIME  </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="isatime" name="isatime" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw"> STATUS </label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="togglestatus" name="togglestatus" readonly="true"/>
                    </div>
                </div>

                <%--<div class="row col-sm-12 clear">
                    <div class="col-sm-6"> <label class="labelw"> SAP_USER:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="SAP_USER" name="SAP_USER" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">  IDOC_NUMBER:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="IDOC_NUMBER" name="IDOC_NUMBER" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">  PO_NUMBER:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="PO_NUMBER" name="PO_NUMBER" readonly="true"/>
                    </div>
                    <div class="col-sm-6"> <label class="labelw">  PO_DATE #:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="PO_DATE" name="PO_DATE" readonly="true"/>
                    </div>
                </div>
                <div class="row col-sm-12 clear">
                    <div class="col-sm-6"> <label class="labelw">  STATUS :</label>
                    </div>
                </div>
                    <div class="row col-sm-12 clear">
                        <div class="col-sm-6"> <label class="labelw">  IDOC_CODE:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="IDOC_STATUS_CODE" name="IDOC_STATUS_CODE" readonly="true"/>
                    </div>
                        <div class="col-sm-6"> <label class="labelw">  IDOC_DESC:</label>
                        <input type="Text"  class="form-control"  required="required" placeholder="" id="IDOC_STATUS_DESCRIPTION" name="IDOC_STATUS_DESCRIPTION" readonly="true"/>
                    </div>
                </div> --%>
                <div class="row col-sm-12" style="margin-top:10px;">
                    <div class="col-sm-6"> <label class="labelw">  Pre Translation  </label></div>
                    <div class="col-sm-6">    <div id="pretranfilepath"></div></div>
                </div>
                <div class="row col-sm-12" >
                    <div class="col-sm-6"> <label class="labelw"> Post Translation </label></div>
                    <div class="col-sm-6"><div id="posttranfilepath"></div></div>
                </div>
                <div class="row col-sm-12" >
                    <div class="col-sm-6"> <label class="labelw"> 997 ACK File </label></div>
                    <div class="col-sm-6"><div id="ackfileid"></div></div>
                </div>
                <%--<div id="errormessage"></div>--%>
                <div class="row col-sm-12" id="errorDiv" style="display: none">
                    <div class="col-sm-6"> <label class="labelw"> Error&nbsp;Message </label></div>
                    <div class="col-sm-6" id="errormessage" style="color: red"></div>
                </div>
                <div id="noresult"></div>
                <div class="row col-sm-12" style="margin-top:10px;"><button type="button" class="btn btn-primary col-sm-11" style="margin-left:12px; " id="hide-menu" onclick="hide()" value="X">Close</button></div>
            </div>
        </div>
    
            <div>
        <s:include value="../includes/template/footer.jsp"/>
    </div>
    <script>
        $('input[name="daterange"]').daterangepicker();
    </script>
    <script type="text/javascript" src='<s:url value="../includes/js/DateValidation.js"/>'></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/GeneralAjax.js"/>'></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/downloadAjax.js"/>'></script>
    <!-- Bootstrap 3.3.5 -->
    <script src='<s:url value="../includes/bootstrap/js/bootstrap.min.js"/>'></script>
    <!-- Morris.js charts -->
    <script src='<s:url value="../includes/plugins/daterangepicker/daterangepicker.js"/>'></script>
    <!-- datepicker -->
    <script src='<s:url value="../includes/bootstrap/js/app.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>
    <script type="text/javascript">
        function checkCorrelation() {
            var db = document.forms["paymentForm"]["database"].value;
            if (db == '') {
                alert("please select Database!!!");
                return false;
            }
            var corrattr = document.getElementById('corrattribute').value;
            var corrval = document.getElementById('corrvalue').value;
            var corrattr1 = document.getElementById('corrattribute1').value;
            var corrval1 = document.getElementById('corrvalue1').value;
            if ((corrattr != "-1") && (corrval == "")) {
                alert("please enter Correlation Value!!!");
                return false;
            }
            if ((corrattr == "-1") && (corrval != "")) {
                alert("please select Correlation!");
                return false;
            }
            if ((corrattr1 != "-1") && (corrval1 == "")) {
                alert("please enter Correlation Value!!!");
                return false;
            }
            if ((corrattr1 == "-1") && (corrval1 != "")) {
                alert("please select Correlation!");
                return false;
            }
        }

        function resetValuesPayments() {
            $('.myRadio').attr('checked',false);
            document.getElementById('paDateFrom').value = "";
            document.getElementById('paDateTo').value = "";
            document.getElementById('paSenderId').value = "-1";
            document.getElementById('paSenderName').value = "-1";
            document.getElementById('paRecId').value = "-1";
            document.getElementById('paRecName').value = "-1";
            document.getElementById('sampleValue').value = "1";
            document.getElementById('ackStatus').value = "-1";
            document.getElementById('status').value = "-1";
            document.getElementById('docType').value = "-1";
            document.getElementById('corrattribute').value = "-1";
            document.getElementById('corrvalue').value = "";
            document.getElementById('reportrange').value = "";
            $('#gridDiv').hide();
            document.getElementById('corrattribute1').value = "-1";
            document.getElementById('corrvalue1').value = "";
        }

        function hide()
        {
            $('#hide-menu1').removeClass('show-menu');
        }
//        $('body,html').click(function(e){
//            $('#hide-menu1').removeClass('show-menu');
//        });

        $("#addButton").click(function() {
            count++;
            if (count == 1)
                document.getElementById("corr").style.display = "block";
            else
                alert('Limit exceded.... cannot add more fields !!');
        })
    </script>

</body>
</html>
