<%@page import="com.mss.ediscv.lfc.PaymentLifecycleBean"%>
<%@page import="com.mss.ediscv.lfc.InvoiceLifecycleBean"%>
<%@page import="com.mss.ediscv.lfc.AsnLifecycleBean"%>
<%@page import="com.mss.ediscv.lfc.PoLifecycleBean"%>
<%@page import="com.mss.ediscv.partner.PartnerBean"%>
<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page buffer="50kb" autoFlush="true" %>
<%@ taglib prefix="s" uri="/struts-tags" %>

<%@page import="com.mss.ediscv.doc.DocRepositoryBean"%>
<%@ taglib uri="/WEB-INF/tlds/dbgrid.tld" prefix="grd"%>
<%@ page import="com.freeware.gridtag.*"%>
<%@page import="java.sql.Connection"%>
<%@  page import="com.mss.ediscv.util.AppConstants"%>
<%@ page import="com.mss.ediscv.util.ConnectionProvider"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import = "java.util.ResourceBundle" %>
<%--<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>--%>
<%@page buffer="50kb" autoFlush="true" %>

<html>
    <head>
        <title>Miracle Supply Chain Visibility portal</title>
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <link rel="stylesheet" href='<s:url value="/includes/plugins/datatables/dataTables.bootstrap.css"/>' type="text/css">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
        <script language="JavaScript" src='<s:url value="/includes/js/jquery-1.9.1.js"></s:url>'></script>
            <script language="JavaScript" src='<s:url value="/includes/js/jquery-ui.js"/>'></script>
        <script language="JavaScript" src='<s:url value="/includes/js/LfcAjax.js"/>'></script>
        <script type="text/javascript">
            $(function () {
                $('#attach_box').click(function () {
                    $('#sec_box').show();
                    return false;
                });
            });
            $(function () {
                $('#detail_link').click(function () {
                    $('#detail_box').show();
                    return false;
                });
            });

            // New function to show the left grid

            function demo() {
                $(function () {

                    $('#detail_box').show();
                    return false;
                });

            }
            function getDetails(ponum, fileid, type) {

                // alert("hiiiiii---->"+val+"------"+type);
                getlfcPODetails(ponum, fileid, type);
            }
            function goBack()
            {
                window.history.go(-1)
            }

            function hide()
            {

                $('#hide-menu1').removeClass('show-menu');
            }
//            $('body,html').click(function(e){
//                $('#hide-menu1').removeClass('show-menu');
//            });

            function doOnLoad() {

                $("#purchaseorder").addClass("active");
                $("#oredermanagement").addClass("active");

                $("#manufacturing").addClass("active");

                $("#purchaseorder i").addClass("text-red");
                document.getElementById('loadingAcoountSearch').style.display = "none";
            }

        </script>


    </head>
    <body class="hold-transition skin-blue sidebar-mini"  onload="doOnLoad()" onclick="hide()">
        <div>
            <s:include value="../includes/template/header.jsp"/>
        </div>
        <div>
            <s:include value="../includes/template/sidemenu.jsp"/>
        </div>
        <%String contextPath = request.getContextPath();
        %>
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <!-- Main content --> 
            <section class="content-header">
                <h1>
                    LifeCycle
                    <small>Manufacturing</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-wrench"></i>Manufacturing</a></li>
                    <li class="active">LifeCycle</li>
                </ol>
            </section>
            <br>
            <div id="gridDiv">     
                <%!String cssValue = "whiteStripe";
                    int resultsetTotal;%>
                <section class="content">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="box">
                                <div class="box-header">
                                    <h3 class="box-title">Table</h3>
                                </div><!-- /.box-header -->
                                <div class="box-body">
                                    <div style="overflow-x:auto;">   
                                        <div align="right"><input type="button" value="Go back" class="btn btn-effect-ripple btn-primary" onclick="goBack()"></input></div>
                                        <br>
                                        <table align="left" width="100%" border="0" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td style="background-color: white;">

                                                    <table id="results"  class="table table-bordered table-hover">
                                                        <%
                                                            //LifecycleBeans lifecycleBeans = (LifecycleBeans) 
                                                            // PoLifecycleBean poLifeCycleBean = (PoLifecycleBean) session.getAttribute(AppConstants.SES_LifecycleBeansList);
                                                       /* AsnLifecycleBean asnLifecycleBean = (AsnLifecycleBean) lifecycleBeans.getAsnLifecycleBean();
                                                             InvoiceLifecycleBean invoiceLifecycleBean = (InvoiceLifecycleBean) lifecycleBeans.getInvoiceLifecycleBean();
                                                             PaymentLifecycleBean paymentLifecycleBean = (PaymentLifecycleBean) lifecycleBeans.getPaymentLifecycleBean();*/
                                                            java.util.List list = (java.util.List) session.getAttribute(AppConstants.LFC_SES_PO_LIST);
                                                            //   out.println("NAG-----PO LIST size--->"+list.size()+"\n");

                                                            if (list.size() != 0) {
                                                                PoLifecycleBean poLifeCycleBean;
                                                        %>

                                                        <thead>  <tr>
                                                                <th>#</th>
                                                                <th>PO #</th>
                                                                <th>InstanceId</th>
                                                                <th>Type</th>
                                                                <th>Direction</th>
                                                                <th>DateTime</th>  
                                                                    <%--<td >SENDER_ID</td>
                                                                    <td >RECEIVER_ID</td>   --%>
                                                                <th>Status</th>
                                                                <th>Ack Status</th> 
                                                                <th>Reprocess</th> 
                                                            </tr></thead>
                                                        <tbody>
                                                            <%
                                                                for (int i = 0; i < list.size(); i++) {
                                                                    poLifeCycleBean = (PoLifecycleBean) list.get(i);

                                                                    if (i % 2 == 0) {
                                                                        cssValue = "whiteStripe";
                                                                    } else {
                                                                        cssValue = "grayEditSelection";
                                                                    }
                                                            %>

                                                            <%-- Po Start--%>
                                                            <tr>
                                                                <td>
                                                                    <%
                                                                        out.println(poLifeCycleBean.getTranType());
                                                                    %>
                                                                </td>

                                                                <td><a href="javascript:getDetails('<%=poLifeCycleBean.getPoNumber()%>','<%=poLifeCycleBean.getFileId()%>','PO');">
                                                                        <%
                                                                            out.println(poLifeCycleBean.getPoNumber());
                                                                        %></a>

                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(poLifeCycleBean.getFileId());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(poLifeCycleBean.getFileType());
                                                                    %>
                                                                </td>



                                                                <td>
                                                                    <%
                                                                        System.out.print("poLifeCycleBean.getDirection().toUpperCase() -->"+poLifeCycleBean.getDirection().toUpperCase());
                                                                        System.out.print("poLifeCycleBean.getDirection() -->"+poLifeCycleBean.getDirection());
                                                                        out.println(poLifeCycleBean.getDirection().toUpperCase());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(poLifeCycleBean.getDatetimeRec().toString().substring(0, poLifeCycleBean.getDatetimeRec().toString().lastIndexOf(":")));
                                                                    %>
                                                                </td>  
                                                                <%--<td>
                                                                  <%
                                                                    out.println(poLifeCycleBean.getSenderId());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                  <%
                                                                    out.println(poLifeCycleBean.getRecId());
                                                                    %>
                                                                </td>  --%>

                                                                <td>
                                                                    <%
                                                                        if (poLifeCycleBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                            out.println("<font color='red'>" + poLifeCycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else if (poLifeCycleBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                            out.println("<font color='green'>" + poLifeCycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + poLifeCycleBean.getStatus().toUpperCase() + "</font>");
                                                                        }

                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%                                                                        //out.println(poLifeCycleBean.getAckStatus());
                                                                        if (poLifeCycleBean.getAckStatus().equalsIgnoreCase("REJECTED")) {
                                                                            out.println("<font color='red'>" + poLifeCycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else if (poLifeCycleBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                            out.println("<font color='green'>" + poLifeCycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + poLifeCycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        }

                                                                    %>
                                                                </td> 
                                                                <td>
                                                                    <%                                                                        // out.println(poLifeCycleBean.getReProcessStatus());
                                                                        if (poLifeCycleBean.getReProcessStatus() != null) {
                                                                            out.println(poLifeCycleBean.getReProcessStatus().toUpperCase());

                                                                        } else {
                                                                            out.println("-");
                                                                        }
                                                                    %>
                                                                </td>

                                                            </tr>
                                                            <%} //PO FOR loop END
                                                            %>

                                                            <%-- Po End--%>
                                                            <%-- ASN start --%>
                                                            <%
                                                                java.util.List asnlist = (java.util.List) session.getAttribute(AppConstants.LFC_SES_ASN_LIST);
                                                                // out.println("NAG-----ASN LIST size--->"+list.size()+"\n");
                                                                if (asnlist.size() != 0) {
                                                                    AsnLifecycleBean asnLifecycleBean;
                                                            %>

                                                            <%
                                                                for (int j = 0; j < asnlist.size(); j++) {
                                                                    asnLifecycleBean = (AsnLifecycleBean) asnlist.get(j);

                                                                    if (j % 2 == 0) {
                                                                        cssValue = "whiteStripe";
                                                                    } else {
                                                                        cssValue = "grayEditSelection";
                                                                    }
                                                            %>

                                                            <%-- Asn Start--%>
                                                            <tr>
                                                                <td>
                                                                    <%
                                                                        out.println(asnLifecycleBean.getTranType());
                                                                    %>
                                                                </td>

                                                                <td><a href="javascript:getDetails('<%=asnLifecycleBean.getPoNumber()%>','<%=asnLifecycleBean.getFileId()%>','ASN');">
                                                                        <%
                                                                            out.println(asnLifecycleBean.getPoNumber());
                                                                        %>
                                                                    </a>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(asnLifecycleBean.getFileId());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(asnLifecycleBean.getFileType());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(asnLifecycleBean.getDirection().toUpperCase());
                                                                    %>
                                                                </td>

                                                                <td>
                                                                    <%
                                                                        out.println(asnLifecycleBean.getDatetimeRec().toString().substring(0, asnLifecycleBean.getDatetimeRec().toString().lastIndexOf(":")));
                                                                    %>
                                                                </td> 
                                                                <td>
                                                                    <%
                                                                        if (asnLifecycleBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                            out.println("<font color='red'>" + asnLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else if (asnLifecycleBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                            out.println("<font color='green'>" + asnLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + asnLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        // out.println(asnLifecycleBean.getAckStatus());
                                                                        if (asnLifecycleBean.getAckStatus().equalsIgnoreCase("REJECT")) {
                                                                            out.println("<font color='red'>" + asnLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else if (asnLifecycleBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                            out.println("<font color='green'>" + asnLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + asnLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td>  

                                                                <td>
                                                                    <%
                                                                        // out.println(asnLifecycleBean.getReProcessStatus());
                                                                        if (asnLifecycleBean.getReProcessStatus() != null) {
                                                                            out.println(asnLifecycleBean.getReProcessStatus().toUpperCase());

                                                                        } else {
                                                                            out.println("-");
                                                                        }
                                                                    %>
                                                                </td>
                                                            </tr>
                                                            <%
                                                                    }// ASN for loop end

                                                                }// ASN if end
                                                            %>
                                                            <%-- INVOICE START --%>
                                                            <%
                                                                java.util.List invoicelist = (java.util.List) session.getAttribute(AppConstants.LFC_SES_INVOICE_LIST);
                                                                //  out.println("NAG-----INVOICE LIST size--->"+invoicelist.size()+"\n");
                                                                if (invoicelist.size() != 0) {
                                                                    InvoiceLifecycleBean invoiceLifecycleBean;
                                                            %>
                                                            <%
                                                                for (int k = 0; k < invoicelist.size(); k++) {
                                                                    invoiceLifecycleBean = (InvoiceLifecycleBean) invoicelist.get(k);

                                                                    if (k % 2 == 0) {
                                                                        cssValue = "whiteStripe";
                                                                    } else {
                                                                        cssValue = "grayEditSelection";
                                                                    }
                                                            %>

                                                            <tr>
                                                                <td>
                                                                    <%
                                                                        out.println(invoiceLifecycleBean.getTranType());
                                                                    %>
                                                                </td>


                                                                <td><a href="javascript:getDetails('<%=invoiceLifecycleBean.getPoNumber()%>','<%=invoiceLifecycleBean.getFileId()%>','INV');">
                                                                        <%
                                                                            out.println(invoiceLifecycleBean.getPoNumber());
                                                                        %></a>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(invoiceLifecycleBean.getFileId());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(invoiceLifecycleBean.getFileType());
                                                                    %>
                                                                </td>



                                                                <td>
                                                                    <%
                                                                        out.println(invoiceLifecycleBean.getDirection().toUpperCase());
                                                                    %>
                                                                </td>

                                                                <td>
                                                                    <%
                                                                        out.println(invoiceLifecycleBean.getDatetimeRec().toString().substring(0, invoiceLifecycleBean.getDatetimeRec().toString().lastIndexOf(":")));
                                                                    %>
                                                                </td> 
                                                                <%--  <td>
                                                                    <%
                                                                      out.println(invoiceLifecycleBean.getSenderId());
                                                                      %>
                                                                  </td>
                                                                  <td>
                                                                    <%
                                                                      out.println(invoiceLifecycleBean.getRecId());
                                                                      %>
                                                                  </td> --%>

                                                                <td>
                                                                    <%
                                                                        if (invoiceLifecycleBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                            out.println("<font color='red'>" + invoiceLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else if (invoiceLifecycleBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                            out.println("<font color='green'>" + invoiceLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + invoiceLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        // out.println(invoiceLifecycleBean.getAckStatus());
                                                                        if (invoiceLifecycleBean.getAckStatus().equalsIgnoreCase("REJECT")) {
                                                                            out.println("<font color='red'>" + invoiceLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else if (invoiceLifecycleBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                            out.println("<font color='green'>" + invoiceLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + invoiceLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td> 

                                                                <td>
                                                                    <%
                                                                        // out.println(invoiceLifecycleBean.getReProcessStatus());
                                                                        if (invoiceLifecycleBean.getReProcessStatus() != null) {
                                                                            out.println(invoiceLifecycleBean.getReProcessStatus().toUpperCase());

                                                                        } else {
                                                                            out.println("-");
                                                                        }
                                                                    %>
                                                                </td>
                                                            </tr>
                                                            <%-- INVOICE END --%>

                                                            <%
                                                                    }// INVOICE FOR
                                                                } //INVOICE IF
                                                            %>

                                                            <%-- payment start --%>
                                                            <%
                                                                java.util.List paymentlist = (java.util.List) session.getAttribute(AppConstants.LFC_SES_PAYMENT_LIST);
                                                                //out.println("NAG-----INVOICE LIST size--->"+paymentlist.size()+"\n");
                                                                if (paymentlist.size() != 0) {
                                                                    PaymentLifecycleBean paymentLifecycleBean;
                                                            %>
                                                            <%
                                                                for (int l = 0; l < paymentlist.size(); l++) {
                                                                    paymentLifecycleBean = (PaymentLifecycleBean) paymentlist.get(l);

                                                                    if (l % 2 == 0) {
                                                                        cssValue = "whiteStripe";
                                                                    } else {
                                                                        cssValue = "grayEditSelection";
                                                                    }
                                                            %>

                                                            <%-- Payment Start--%>
                                                            <tr>
                                                                <td>
                                                                    <%
                                                                        out.println(paymentLifecycleBean.getTranType());
                                                                    %>
                                                                </td>

                                                                <td><a href="javascript:getDetails('<%=paymentLifecycleBean.getPoNumber()%>','<%=paymentLifecycleBean.getFileId()%>','PAYMENT');">
                                                                        <%
                                                                            out.println(paymentLifecycleBean.getPoNumber());
                                                                        %></a>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(paymentLifecycleBean.getFileId());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(paymentLifecycleBean.getFileType());
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        out.println(paymentLifecycleBean.getDirection().toUpperCase());
                                                                    %>
                                                                </td>

                                                                <td>
                                                                    <%
                                                                        out.println(paymentLifecycleBean.getDatetimeRec().toString().substring(0, paymentLifecycleBean.getDatetimeRec().toString().lastIndexOf(":")));
                                                                    %>
                                                                </td>
                                                                <%-- <td>
                                                                   <%
                                                                     out.println(paymentLifecycleBean.getSenderId());
                                                                     %>
                                                                 </td>
                                                                 <td>
                                                                   <%
                                                                     out.println(paymentLifecycleBean.getRecId());
                                                                     %>
                                                                 </td>  --%>

                                                                <td>
                                                                    <%
                                                                        if (paymentLifecycleBean.getStatus().equalsIgnoreCase("ERROR")) {
                                                                            out.println("<font color='red'>" + paymentLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else if (paymentLifecycleBean.getStatus().equalsIgnoreCase("SUCCESS")) {
                                                                            out.println("<font color='green'>" + paymentLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + paymentLifecycleBean.getStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td>
                                                                <td>
                                                                    <%
                                                                        //out.println("hiiiii");
                                                                        //out.println(paymentLifecycleBean.getAckStatus());
                                                                        if (paymentLifecycleBean.getAckStatus().equalsIgnoreCase("REJECT")) {
                                                                            out.println("<font color='red'>" + paymentLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else if (paymentLifecycleBean.getAckStatus().equalsIgnoreCase("ACCEPTED")) {
                                                                            out.println("<font color='green'>" + paymentLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        } else {
                                                                            out.println("<font color='orange'>" + paymentLifecycleBean.getAckStatus().toUpperCase() + "</font>");
                                                                        }
                                                                    %>
                                                                </td>  

                                                                <td>
                                                                    <%
                                                                        if (paymentLifecycleBean.getReProcessStatus() != null) {
                                                                            out.println(paymentLifecycleBean.getReProcessStatus().toUpperCase());

                                                                        } else {
                                                                            out.println("-");
                                                                        }
                                                                    %>
                                                                </td>

                                                            </tr>
                                                            <%-- Payment End--%>

                                                            <%-- Payment END --%>
                                                            <%
                                                                    }//PAYMENT END FOR loop
                                                                }//PAYMENT ENF IF
                                                            } // PO if
                                                            else {
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
                                            <%                                                if (list.size() != 0) {
                                            %>
                                            <tr >

                                                <td align="right" colspan="28" style="background-color: white;">
                                                    <!--<div align="right" id="pageNavPosition"></div>-->
                                                </td>
                                            </tr>  <% }%>       </tbody>          
                                        </table>  


                                    </div>
                                    <%-- Process butttons  start --%>

                                    <%-- process buttons end--%>
                                    <%-- Grid End --%>

                                </div>
                            </div></div>
                    </div></section>

                <div id="hide-menu1" class="hide-menu message ">

                    <div class="row col-sm-12">


                        <div class="col-sm-6"> <label class="labelw">Instance Id </label>
                            <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcInstanceId" name="LfcInstanceId" readonly="true"/>
                        </div>


                        <div class="col-sm-6"> <label class="labelw">PO # :</label>
                            <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPONum" name="LfcPONum" readonly="true"/>
                        </div> <div class="row col-sm-12"> <br>
                            <div class="col-sm-6"> <label class="labelw">PO Date :</label>
                                <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPODates" name="LfcPODates" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw">PO Status :</label>
                                <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcStatus1" name="LfcStatus1" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw">SO # :</label>
                                <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcSo" name="LfcSo" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw">PO Qty :</label>
                                <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOQty" name="POShipDate" readonly="true"/>
                            </div>
                            <div class="col-sm-6"> <label class="labelw">Transaction Type :</label>
                                <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcTransactionType" name="LfcTransactionType" readonly="true"/>
                            </div>
                            <br>
                            <div id="senderinfo">
                                <div class="row col-sm-12">
                                    <div class="col-sm-6"> <h5>Partner Info :</h5></div>
                                    <div class="col-sm-6"></div>
                                    <div class="col-sm-6"></div>

                                </div>
                                <br>
                                <div class="row col-sm-12">
                                    <div class="col-sm-6"> <label class="labelw">  Id </label>
                                        <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LycPOPartnerId" name="LycPOPartnerId" readonly="true"/>
                                    </div>
                                    <div class="col-sm-6"> <label class="labelw"> Name </label>
                                        <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LycPOPartnerName" name="LycPOPartnerName" readonly="true"/>
                                    </div>
                                </div>
                            </div>
                            <br>
                            <div id="receiverinfo">
                                <div class="row col-sm-12">
                                    <div class="col-sm-6"> <h5>Sender Info:</h5></div>
                                    <div class="col-sm-6"></div>
                                    <div class="col-sm-6"></div>
                                </div>

                                <br>
                                <div class="row col-sm-12 clear">
                                    <div class="col-sm-6"> <label class="labelw">  Id </label>
                                        <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOReceiverId" name="LfcPOReceiverId" readonly="true"/>
                                    </div>
                                    <div class="col-sm-6"> <label class="labelw"> Name </label>
                                        <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOReceiverName" name="LfcPOReceiverName" readonly="true"/>
                                    </div>
                                </div>
                            </div>  <div class="row col-sm-12 clear">
                                <div class="col-sm-6"> <label class="labelw"> ISA # :</label>
                                    <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOIsa" name="LfcPOIsa" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> ISA Date : </label>
                                    <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOISADate" name="LfcPOISADate" readonly="true"/>
                                </div>
                            </div>

                            <br/>

                            <div class="row col-sm-12" >

                                <div class="col-sm-6"> <label class="labelw">  ISA TIME : </label>
                                    <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOIsATime" name="LfcPOIsATime" readonly="true"/>
                                </div>
                                <div class="col-sm-6"> <label class="labelw"> STATUS :</label>
                                    <s:textfield  cssClass="form-control"  required="required" placeholder="" id="LfcPOStatus" name="LfcPOStatus" readonly="true"/>
                                </div>
                            </div>

                            <div class="row col-sm-12" >
                                <div class="col-sm-6"> <label class="labelw">  PreTranslation  </label></div>
                                <div class="col-sm-6"><div id="LfcPOPreTransition"></div></div>
                            </div>
                            <div class="col-sm-6"> <label class="labelw"> PostTranslation </label></div>
                            <div class="col-sm-6"><div id="LfcPOPostTransition"></div></div>
                        </div>
                        <div class="col-sm-6"> <label class="labelw">997ACKFile </label></div>                      

                        <div class="col-sm-6"><div id="LfcPOAckFileId"></div></div>
                    </div>

                    <br><br><br><br><br><br>

                    <div class="row col-sm-12" id="errorDiv" style="display: none">
                        <div class="col-sm-6"> <label class="labelw"> Error&nbsp;Message </label></div>
                        <div class="col-sm-6" id="InvErrormessage" style="color: red"></div>
                    </div>

                    <div id="noresult"></div>
                    <div class="row col-sm-12">
                        <button type="button" class="btn btn-primary col-sm-11" style="margin-left:12px; " id="hide-menu" onclick="hide()" value="X">Close</button>
                    </div>
                </div>
            </div>
            <script type="text/javascript">
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
            <%--  <div id="footer">
               <h2><font color="white">&#169 2013 Miracle Software Systems, Inc. All rights reserved</font></h2>
                      </div>--%>
        </div>
    </div>
    <script src='<s:url value="../includes/plugins/datatables/jquery.dataTables.min.js"/>'></script>
    <script src='<s:url value="../includes/plugins/datatables/dataTables.bootstrap.min.js"/>'></script>

    <div>
        <s:include value="../includes/template/footer.jsp"/>
    </div>
</body>
</html>
