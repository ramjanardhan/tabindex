<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page buffer="50kb" autoFlush="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<%@page import="com.mss.ediscv.inv.InvoiceBean"%>
<%@ taglib uri="/WEB-INF/tlds/dbgrid.tld" prefix="grd"%>
<%@ page import="com.freeware.gridtag.*"%>
<%@page import="java.sql.Connection"%>
<%@  page import="com.mss.ediscv.util.AppConstants"%>
<%@ page import="com.mss.ediscv.util.ConnectionProvider"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import = "java.util.ResourceBundle" %>
<%--<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>--%>
<%@page buffer="50kb" autoFlush="true" %>


<!DOCTYPE html>
<html>
    <style>
        #inv_buttons{
            display: inline-block;
            float: right;
        }

    </style>
    <script>
        function doOnLoad() {
            $("#invoices").addClass("active");
            $("#financials").addClass("active");
            $("#manufacturing").addClass("active");
            $("#invoices i").addClass("text-red");
            document.getElementById('loadingAcoountSearch').style.display = "none";
        }
        function hide() {
            $('#hide-menu1').removeClass('show-menu');
        }
//        $('body,html').click(function (e) {
//            $('#hide-menu1').removeClass('show-menu');
//        });
    </script>

    <meta charset="utf-8">

    <title>Miracle Supply Chain Visibility Portal</title>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="cache-control" content="no-cache" />
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Bootstrap 3.3.5 -->
    <link rel="stylesheet" href='<s:url value="/includes/bootstrap/css/userdefined.css"/>'>
    <link rel="stylesheet" href='<s:url value="/includes/bootstrap/css/bootstrap.min.css"/>'>
    <link rel="stylesheet" href='<s:url value="/includes/plugins/datatables/dataTables.bootstrap.css"/>' type="text/css">
    <link rel="stylesheet" href='<s:url value="/includes/plugins/daterangepicker/daterangepicker.css"/>' type="text/css">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/DateValidation.js"/>'></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/generalValidations.js"/>'></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/GeneralAjax.js"/>'></script>
    <script language="JavaScript"  src='<s:url value="/includes/js/downloadAjax.js"/>'></script>



</head>
<%
    String check = null;
    if (request.getAttribute("check") != null) {
        check = request.getAttribute("check").toString();
    }

    //System.out.println("check-->"+check);
%>

<body class="hold-transition skin-blue sidebar-mini" onload="doOnLoad();
            check();" onclick="hide()">
    <script type="text/javascript" src='<s:url value="/includes/js/wz_tooltip.js"/>'></script>
    <script type="text/javascript">
                function check()
                {

                    var value1 = document.getElementById("corrattribute1").value;

                    if (value1 != "-1")
                        document.getElementById("corr").style.display = "block";
                    else
                        document.getElementById("corr").style.display = "none";
                    var value2 = document.getElementById("corrattribute2").value;
                    if (value2 != "-1")
                        document.getElementById("corr1").style.display = "block";
                    else
                        document.getElementById("corr1").style.display = "none";

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
            <h1>
                Invoice
                <small>Manufacturing</small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-wrench"></i>Manufacturing</a></li>
                <li class="active">Invoice</li>
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
                        <div  style="alignment-adjust:central;" >
                            <%String contextPath = request.getContextPath();
                            %>



                            <s:form action="../inv/invoiceSearch.action" method="post" name="invoiceForm" id="invoiceForm" theme="simple">
                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="row">
                                                <div class="col-sm-3"> <label for="reportrange">Date range</label>
                                                    <s:textfield  id="reportrange" name="reportrange" cssClass="form-control" class="form-control pull-left"  value="%{reportrange}" onchange="MyDate();"/>  
                                                </div>

                                                <script type="text/javascript">
                                                    function MyDate()
                                                    {
                                                        //alert("myDate");
                                                        var date = document.invoiceForm.reportrange.value;

                                                        var arr = date.split("-");

                                                        var x = arr[1].trim();
                                                        document.getElementById("invdatepickerfrom").value = arr[0];
                                                        document.getElementById("invdatepicker").value = x;

                                                        var datefrom = document.getElementById("invdatepickerfrom").value;
                                                        var dateto = document.getElementById("invdatepicker").value;
                                                        //alert(datefrom);                                                       
                                                        // alert(dateto);                                                       
                                                    }
                                                </script>
                                                <s:hidden id="invdatepickerfrom" name="invdatepickerfrom" />
                                                <s:hidden id="invdatepicker" name="invdatepicker"/>
                                                <div  class="col-sm-3">
                                                    <label for="docType">Document Type</label> 
                                                    <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="docTypeList" name="docType" id="docType" value="%{docType}" tabindex="13"/>
                                                </div>

                                                <div  class="col-sm-3">
                                                    <label for="docSenderId">Sender Id</label>  
                                                    <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="senderIdList" name="invSenderId" id="invSenderId" value="%{invSenderId}" tabindex="3" />
                                                </div>

                                                <div  class="col-sm-3">
                                                    <label for="docSenderName">Sender Name</label>  
                                                    <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="senderNameList" name="invSenderName" id="invSenderName" value="%{invSenderName}" tabindex="4" />
                                                </div>


                                            </div>
                                            <br>
                                            <div class="row">
                                                <div class="col-sm-3">
                                                    <label for="docBusId">Receiver Id</label>
                                                    <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="receiverIdList" name="invBusId" id="invBusId" value="%{invBusId}" tabindex="5" />
                                                </div>
                                                <div class="col-sm-3">
                                                    <label for="docRecName">Receiver Name</label>
                                                    <s:select headerKey="-1" cssClass="form-control" headerValue="Select Type" list="receiverNameList" name="invRecName" id="invRecName" value="%{invRecName}" tabindex="6" />
                                                </div>
                                                <div class="col-sm-3">
                                                    <label for="ackStatus">Ack Status</label>
                                                    <s:select headerKey="-1" headerValue="Select Type" cssClass="form-control" list="{'Overdue','Accepted','Rejected'}" name="ackStatus" id="ackStatus" value="%{ackStatus}" tabindex="15" /> 
                                                </div>
                                                <div class="col-sm-3">
                                                    <label for="status">Status</label>
                                                    <s:select headerKey="-1" headerValue="Select Type" cssClass="form-control" list="{'Success','Error','Warning'}" name="status" id="status" value="%{status}" tabindex="14" /> 
                                                </div>
                                            </div>
                                            <br>
                                            <div class="row">
                                                <div class="col-sm-3">
                                                    <label for="corrattribute">Correlation</label>
                                                    <s:select headerKey="-1" headerValue="Select Attribute" cssClass="form-control" list="correlationList" name="corrattribute" id="corrattribute" value="%{corrattribute}" tabindex="7" />
                                                </div>
                                                <div class="col-sm-3">
                                                    <label for="corrvalue">Value</label>
                                                    <s:textfield cssClass="form-control" name="corrvalue" id="corrvalue" value="%{corrvalue}" tabindex="8"/>
                                                </div>
                                                <div id="loadingAcoountSearch" class="loadingImg">
                                                    <span id ="LoadingContent" > <img src="<s:url value="/includes/images/Loader2.gif"/>"   ></span>
                                                </div>

                                            </div>

                                        </div>
                                    </div>
                                    <div>
                                        <br>
                                        <div class="row">
                                            <div class="col-sm-2"><s:submit value="Search"  onclick="return checkCorrelation();" cssClass="btn btn-primary col-sm-12" tabindex="16"/></div>

                                            <div class="col-sm-2"><strong><input type="button" value="Reset"  tabindex="17" class="btn btn-primary col-sm-12" onclick="return resetvalues();"/></strong></div>
                                            </td>
                                            <s:hidden name="sampleValue" id="sampleValue" value="2"/>
                                        </s:form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    </section>

                    <div id="gridDiv">
                        <s:if test="#session.invoiceList != null"> 
                            <%--- GRid start --%><section class="content">
                                <div class="row">
                                    <div class="col-xs-12">
                                        <div class="box">
                                            <div class="box-header">
                                                <h3 class="box-title">Table</h3>
                                            </div>
                                            <div class="box-body">
                                                <%!String cssValue = "whiteStripe";
                                                    int resultsetTotal;%>
                                                <div style="overflow-x:auto;">                 

                                                    <table align="left" width="100%"
                                                           border="0" cellpadding="0" cellspacing="0">
                                                        <tr>
                                                            <td style="background-color: white;">

                                                                <table id="results" class="table table-bordered table-hover">
                                                                    <%
                                                                        java.util.List list = (java.util.List) session.getAttribute(AppConstants.SES_INV_LIST);

                                                                        if (list.size() != 0) {
                                                                            InvoiceBean invoiceBean;
                                                                    %>
                                                                    <input type="hidden" name="sec_invoice_list" id="sec_invoice_list" value="<%=list.size()%>"/>
                                                                    <thead>  <tr>
                                                                            <th>InstanceId</th> 
                                                                            <th >Invoice #</th>
                                                                            <th >Partner</th>
                                                                            <th >PO #</th>
                                                                            <th >Item Qty</th>
                                                                            <th>Invoice Amount</th>
                                                                            <th>DateTime</th>
                                                                            <th>Status</th>
                                                                            <th>Ack Status</th>
                                                                        </tr></thead>
                                                                    <tr>

                                                                        <%
                                                                            for (int i = 0; i < list.size(); i++) {
                                                                                invoiceBean = (InvoiceBean) list.get(i);

                                                                                if (i % 2 == 0) {
                                                                                    cssValue = "whiteStripe";
                                                                                } else {
                                                                                    cssValue = "grayEditSelection";
                                                                                }
                                                                        %>
                                                                        <td>
                                                                            <%
                                                                                out.println(invoiceBean.getFileId());
                                                                            %>
                                                                            <input type="hidden" name="Instance<%=i%>" id="Instance<%=i%>" value="<%=invoiceBean.getFileId()%>"/>
                                                                        </td>
                                                                        <td>  <a href="javascript:getInvDetails('<%=invoiceBean.getInvNumber()%>','<%=invoiceBean.getPoNumber()%>','<%=invoiceBean.getFileId()%>');"  >
                                                                                <%
                                                                                    out.println(invoiceBean.getInvNumber());
                                                                                %>
                                                                                <input type="hidden" name="text<%=i%>" id="text<%=i%>" value="<%=invoiceBean.getInvNumber()%>"/>
                                                                            </a>
                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                out.println(invoiceBean.getPname());
                                                                            %>
                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                out.println(invoiceBean.getPoNumber());
                                                                            %>
                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                out.println(invoiceBean.getItemQty());
                                                                            %>

                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                if (invoiceBean.getInvAmount() != null) {
                                                                                    out.println("$" + invoiceBean.getInvAmount());
                                                                                } else {
                                                                                    out.println(invoiceBean.getInvAmount());
                                                                                }
                                                                            %>
                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                out.println(invoiceBean.getDate_time_rec().toString().substring(0, invoiceBean.getDate_time_rec().toString().lastIndexOf(":")));
                                                                            %>

                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                // out.println(invoiceBean.getStatus());
                                                                                if (invoiceBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                                    out.println("<font color='red'>" + invoiceBean.getStatus().toUpperCase() + "</font>");
                                                                                } else if (invoiceBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                                    out.println("<font color='green'>" + invoiceBean.getStatus().toUpperCase() + "</font>");
                                                                                } else {
                                                                                    out.println("<font color='orange'>" + invoiceBean.getStatus().toUpperCase() + "</font>");
                                                                                }
                                                                            %>
                                                                        </td>
                                                                        <td>
                                                                            <%
                                                                                if (invoiceBean.getAckStatus().equalsIgnoreCase("REJECT")) {
                                                                                    out.println("<font color='red'>" + invoiceBean.getAckStatus().toUpperCase() + "</font>");
                                                                                } else if (invoiceBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                                    out.println("<font color='green'>" + invoiceBean.getAckStatus().toUpperCase() + "</font>");
                                                                                } else {
                                                                                    out.println("<font color='orange'>" + invoiceBean.getAckStatus().toUpperCase() + "</font>");
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
                                                                                    out.println("<img  border='0' align='top'  src='" + contextPath + "/includes/images/alert.gif'/><b>No records found for the given search criteria. Please try a different search criteria!</b>");
                                                                                }

                                                                            %>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <%                                                            if (list.size() != 0) {
                                                        %>
                                                        <tr >
                                                            <!--                                                            <td align="right" colspan="28" style="background-color: white;">-->
                                                            <!--                                                                <div align="right" id="pageNavPosition"></div>-->
                                                            <!--                                                            </td>-->
                                                        </tr>   
                                                        <% }%></tbody>
                                                    </table>
                                                </div>
                                                <%-- Grid End --%>
                                                <%-- Process butttons  start --%>
                                                <%
                                                    if (list.size() != 0) {
                                                %><br>
                                                <div class="row">
                                                    <div id="inv_buttons">
                                                        <div class="col-sm-2"><input type="button" value="Generate Excel" class="btn btn-effect-ripple btn-primary" onclick="return gridDownload('invoice', 'xls');" onmouseover="Tip('Click here to generate an excel Report.')" onmouseout="UnTip()" id="excel"/></div>
                                                    </div> 
                                                </div>
                                                <%}%>
                                                <%-- process buttons end--%> 
                                            </div> </div>    </div>    </div>   
                            </section>
                        </s:if> 
                    </div>

                    <div id="hide-menu1" class="hide-menu message ">

                        <div class="row col-sm-12">

                            <br>
                            <div class="col-sm-6"> <label class="labelw"> Instance Id </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mifileID" name="mifileID" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> Invoice # </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miinvNum" name="miinvNum" readonly="true"/>
                            </div>
                        </div>
                        <div class="row col-sm-12"> <br>
                            <div class="col-sm-6"> <label class="labelw"> PO # </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mipoNum" name="mipoNum" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> Invoice Amount </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miinvAmt" name="miinvAmt" readonly="true"/>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> Invoice Date </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miinvDate" name="miinvDate" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> Item Qty </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miitemQty" name="miitemQty" readonly="true"/>
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
                                <div class="col-sm-6"> <label class="labelw"> Id </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="misenderId" name="misenderId" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> Name </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="misenderName" name="misenderName" readonly="true"/>
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
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="mireceiverId" name="mireceiverId" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> Name </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="mireceiverName" name="mireceiverName" readonly="true"/>
                                </div>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> ISA # </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miisaNum" name="miisaNum" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> GS # </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="migsControlNo" name="migsControlNo" readonly="true"/>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> ST # </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mistControlNo" name="mistControlNo" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> Status </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mistatus" name="mistatus" readonly="true"/>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> ISA Date </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miisaDate" name="miisaDate" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> ISA TIme </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="miisaTime" name="miisaTime" readonly="true"/>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> Transaction Type </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mitransType" name="mitransType" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> Doc Type </label>
                                <s:textfield cssClass="form-control"  required="required" placeholder="" id="mifileType" name="mifileType" readonly="true"/>
                            </div>
                        </div>
                        <div id="sapDiv" style="display: none">
                            <div class="row col-sm-12">
                                <div class="col-sm-6"> <label class="labelw"> SAP User </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="misapUser" name="misapUser" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> iDoc # </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="miidocNo" name="miidocNo" readonly="true"/>
                                </div>
                            </div>
                            <div class="row col-sm-12">
                                <div class="col-sm-6"> <label class="labelw"> PO # </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="mipoNo" name="mipoNo" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> PO Date </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="mipoDate" name="mipoDate" readonly="true"/>
                                </div>
                            </div>
                            <div class="row col-sm-12">
                                <div class="col-sm-6"> <label labelw> iDoc Status Code </label>
                                    <s:textfield cssClass="form-control"  required="required" placeholder="" id="miidocStatusCode" name="miidocStatusCode" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label labelw> iDoc Status Desc </label>
                                    <input type="Text"  class="form-control"  required="required" placeholder="" id="miidocStatusDesc" name="miidocStatusDesc" readonly="true"/>
                                </div>
                            </div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> Pre-Translation </label></div>
                            <div class="col-sm-6" id="mipreTransFilepath" style="color: blue"></div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> Post-Translation </label></div>
                            <div class="col-sm-6" id="mipostTransFilepath" style="color: blue"></div>
                        </div>
                        <div class="row col-sm-12">
                            <div class="col-sm-6"> <label class="labelw"> 997&nbsp;Ack&nbsp;File </label></div>
                            <div class="col-sm-6" id="miackFileId" style="color: blue"></div>
                        </div>
                        <br><br>
                        <div class="row col-sm-12" id="errorDiv" style="display: none">
                            <div class="col-sm-6"> <label class="labelw"> Error&nbsp;Message </label></div>
                            <div class="col-sm-6" id="mierrormessage" style="color: red"></div>
                        </div>
                        <div id="noresult"></div>
                        <div class="row col-sm-12"> <button type="button" class="btn btn-primary col-sm-11" style="margin-left:12px; " id="hide-menu" onclick="hide()" value="X">Close</button></div>
                    </div>

                    <script>
                        $(function () {
                            //$("#example1").DataTable();
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


                </div>


                <div>
                    <s:include value="../includes/template/footer.jsp"/>
                </div>

                <script>
                    $('input[name="daterange"]').daterangepicker();
                </script>

                <script src='<s:url value="/includes/bootstrap/js/bootstrap.min.js"/>'></script>
                <script src='<s:url value="/includes/plugins/daterangepicker/daterangepicker.js"/>'></script>
                <script src='<s:url value="/includes/bootstrap/js/app.min.js"/>'></script>
                <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
                <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>
                <script type="text/javascript">


                    function checkCorrelation()
                    {


                        var corrattr = document.getElementById('corrattribute').value;
                        var corrval = document.getElementById('corrvalue').value;
                        if ((corrattr != "-1") && (corrval == "")) {
                            alert("please enter Correlation Value!!!");
                            return false;
                        }
                        if ((corrattr == "-1") && (corrval != "")) {
                            alert("please select Correlation!");
                            return false;
                        }
                    }
                    function resetvalues()
                    {
                        document.getElementById('reportrange').value = '';
                        document.getElementById('invdatepickerfrom').value = '';

                        document.getElementById('invdatepicker').value = '';

                        document.getElementById('invSenderId').value = "-1";

                        document.getElementById('invSenderName').value = "-1";

                        document.getElementById('invBusId').value = "-1";

                        document.getElementById('invRecName').value = "-1";
                        document.getElementById('corrattribute').value = "-1";
                        document.getElementById('corrvalue').value = "";
                        //document.getElementById('corrattribute1').value="-1"; 
                        //document.getElementById('corrvalue1').value="";
                        //document.getElementById('corrattribute2').value="-1"; 
                        //document.getElementById('corrvalue2').value="";
                        //  document.getElementById('invNum').value='';

                        //document.getElementById('invPoNum').value='';
                        document.getElementById('sampleValue').value = "1";
                        document.getElementById('ackStatus').value = "-1";
                        document.getElementById('status').value = "-1";
                        document.getElementById('docType').value = "-1";
                        $('#gridDiv').hide();

                    }
                </script>
                </body>
                </html>