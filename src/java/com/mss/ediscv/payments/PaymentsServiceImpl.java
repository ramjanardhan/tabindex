/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.payments;

import com.mss.ediscv.util.ConnectionProvider;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import org.apache.log4j.Logger;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocatorException;
import com.mss.ediscv.util.WildCardSql;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * @author miracle
 */
public class PaymentsServiceImpl implements PaymentsService {

    Connection connection = null;
    PreparedStatement preparedStatement = null;
    Statement statement = null;
    ResultSet resultSet = null;
    CallableStatement callableStatement = null;
    String tmp_Recieved_From = "";
    String tmp_Recieved_ToTime = "";
    String strFormat = "yyyy-MM-dd";
    DateFormat myDateFormat = new SimpleDateFormat(strFormat);
    Calendar cal = new GregorianCalendar();
    java.util.Date now = cal.getTime();
    long time = now.getTime();
    java.sql.Date date = new java.sql.Date(time);
    int callableStatementUpdateCount;
    private ArrayList<PaymentBean> paymentList;
    private PaymentBean paymentBean;
    private static Logger logger = Logger.getLogger(PaymentsServiceImpl.class.getName());

    public ArrayList<PaymentBean> buildpaymentSQuery(PaymentsAction paymentsAction) throws ServiceLocatorException {
        StringBuffer paymentSearchQuery = new StringBuffer();
        String paDateTo = paymentsAction.getPaDateTo();
        String paDateFrom = paymentsAction.getPaDateFrom();
        String paSenderId = "";
        if (paymentsAction.getPaSenderId()!=null && !paymentsAction.getPaSenderId().equals("-1")) {
            paSenderId = paymentsAction.getPaSenderId();
        }
        String paSenderName = "";
        if (paymentsAction.getPaSenderName()!=null && !paymentsAction.getPaSenderName().equals("-1")) {
            paSenderName = paymentsAction.getPaSenderName();
        }
        String paRecId = "";
        if (paymentsAction.getPaRecId()!=null && !paymentsAction.getPaRecId().equals("-1")) {
            paRecId = paymentsAction.getPaRecId();
        }
        String paRecName = "";
        if (paymentsAction.getPaRecName()!=null && !paymentsAction.getPaRecName().equals("-1")) {
            paRecName = paymentsAction.getPaRecName();
        }
        String status = paymentsAction.getStatus();
        String ackStatus = paymentsAction.getAckStatus();
        String corrattribute = paymentsAction.getCorrattribute();
        String corrvalue = paymentsAction.getCorrvalue();
        String corrattribute1 = paymentsAction.getCorrattribute1();
        String corrvalue1 = paymentsAction.getCorrvalue1();
        String doctype = "";
        if (paymentsAction.getDocType()!=null && !paymentsAction.getDocType().equals("-1")) {
            doctype = paymentsAction.getDocType();
        }
        paymentSearchQuery.append("SELECT DISTINCT(PAYMENT.FILE_ID) as FILE_ID,FILES.TRANSACTION_TYPE,TP1.ID as Sender_ID, TP1.NAME as Sender_Name, "
                + "PAYMENT.DATE as Date, PAYMENT.Check_Amount as Check_Amount,FILES.DATE_TIME_RECEIVED as DATE_TIME_RECEIVED, "
                + "PAYMENT.Check_Number as Check_Number,PAYMENT.INVOICE_NUMBER as INVOICE_NUMBER,PAYMENT.PO_NUMBER as PO_NUMBER,"
                + "TP2.NAME as ReceiverName,FILES.ACK_STATUS as ACK_STATUS,FILES.STATUS as STATUS,FILES.REPROCESSSTATUS FROM PAYMENT ");
        paymentSearchQuery.append("LEFT OUTER JOIN FILES ON (PAYMENT.FILE_ID=FILES.FILE_ID) ");
        paymentSearchQuery.append("LEFT OUTER JOIN TP TP1 ON (TP1.ID=FILES.SENDER_ID) ");
        paymentSearchQuery.append("LEFT OUTER JOIN TP TP2 ON (TP2.ID=FILES.RECEIVER_ID) ");
        paymentSearchQuery.append("WHERE 1=1 AND FLOWFLAG like 'M' ");
        if (paDateFrom != null && !"".equals(paDateFrom)) {
            //StringTokenizer st = new StringTokenizer(paDateFrom, " ");
            //String paDateFrom1 = st.nextToken();
            tmp_Recieved_From = DateUtility.getInstance().DateViewToDBCompare(paDateFrom);
            paymentSearchQuery.append(" AND FILES.DATE_TIME_RECEIVED >= '" + tmp_Recieved_From + "'");
        }
        if (paDateTo != null && !"".equals(paDateTo)) {
          //  StringTokenizer st = new StringTokenizer(paDateTo, " ");
         //   String paDateTo1 = st.nextToken();
            tmp_Recieved_ToTime = DateUtility.getInstance().DateViewToDBCompare(paDateTo);
            paymentSearchQuery.append(" AND FILES.DATE_TIME_RECEIVED <= '" + tmp_Recieved_ToTime + "'");
        }
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.PRI_KEY_VAL", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Cheque Amount"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("PAYMENT.Check_Amount", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.PRI_KEY_VAL", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Cheque Amount"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("PAYMENT.Check_Amount", corrvalue1.trim().toUpperCase()));
            }
        }
           if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILE_ID", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILE_ID", corrvalue1.trim().toUpperCase()));
            }
        }
         //Direction
         if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Direction"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.DIRECTION", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Direction"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.DIRECTION", corrvalue1.trim().toUpperCase()));
            }
        }
        //Doc Type
        if (doctype != null && !"".equals(doctype.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.TRANSACTION_TYPE", doctype.trim()));
        }
        //Status
        if (status != null && !"-1".equals(status.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.STATUS", status.trim()));
        }
        //ACK_STATUS
        if (ackStatus != null && !"-1".equals(ackStatus.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.ACK_STATUS", ackStatus.trim()));
        }
        if (paSenderId != null && !"".equals(paSenderId.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.ID", paSenderId.trim().toUpperCase()));
        }
        if (paSenderName != null && !"".equals(paSenderName.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.NAME", paSenderName.trim().toUpperCase()));
        }
        // Reciver Id and Reciver Name conditions 
        if (paRecId != null && !"".equals(paRecId.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.ID", paRecId.trim().toUpperCase()));
        }
        if (paRecName != null && !"".equals(paRecName.trim())) {
            paymentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.NAME", paRecName.trim().toUpperCase()));
        }
        paymentSearchQuery.append("order by DATE_TIME_RECEIVED DESC fetch first 50 rows only");
        String searchQuery = paymentSearchQuery.toString();
        try {
            connection = ConnectionProvider.getInstance().getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(searchQuery);
            paymentList = new ArrayList<PaymentBean>();
            while (resultSet.next()) {
                PaymentBean paymentBean = new PaymentBean();
                paymentBean.setSenderId(resultSet.getString("Sender_ID"));
                paymentBean.setSenderName(resultSet.getString("Sender_Name"));
                paymentBean.setDate(resultSet.getString("Date"));
                paymentBean.setCheckAmount(resultSet.getString("Check_Amount"));
                paymentBean.setCheckNumber(resultSet.getString("Check_Number"));
                paymentBean.setFileId(resultSet.getString("FILE_ID"));
                paymentBean.setReceiverName(resultSet.getString("ReceiverName"));
                paymentBean.setInvNumber(resultSet.getString("INVOICE_NUMBER"));
                paymentBean.setPonumber(resultSet.getString("PO_NUMBER"));
                paymentBean.setAckStatus(resultSet.getString("ACK_STATUS"));
                paymentBean.setStatus(resultSet.getString("STATUS"));
                paymentBean.setTransType(resultSet.getString("TRANSACTION_TYPE"));
                paymentBean.setDate_time_rec(resultSet.getTimestamp("DATE_TIME_RECEIVED"));
                paymentBean.setReProcessStatus(resultSet.getString("REPROCESSSTATUS"));
                paymentList.add(paymentBean);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                    resultSet = null;
                }
                if (statement != null) {
                    statement.close();
                    statement = null;
                }
                if (connection != null) {
                    connection.close();
                    connection = null;
                }
            } catch (SQLException se) {
                throw new ServiceLocatorException(se);
            }
        }
        return paymentList;
    }
}