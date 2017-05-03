/**
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.doc;

import com.mss.ediscv.util.ConnectionProvider;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import org.apache.log4j.Logger;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocatorException;
import com.mss.ediscv.util.WildCardSql;
import java.sql.*;
import java.util.ArrayList;

public class DocRepositoryServiceImpl implements DocRepositoryService {

    Connection connection = null;
    Statement statement = null;
    PreparedStatement preparedStatement = null;
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
    private ArrayList<DocRepositoryBean> documentList;
    private DocRepositoryBean docRepositoryBean;
    private static Logger logger = Logger.getLogger(com.mss.ediscv.shipment.ShipmentServiceImpl.class.getName());

    //@Override
    public ArrayList<DocRepositoryBean> buildDocumentQuery(DocRepositoryAction docRepositoryAction) throws ServiceLocatorException {
        StringBuffer documentSearchQuery = new StringBuffer();
        String docdatepicker = docRepositoryAction.getDocdatepicker();
        String docdatepickerfrom = docRepositoryAction.getDocdatepickerfrom();
        String docSenderId = "";
        if ((docRepositoryAction.getDocSenderId()!=null) && (!docRepositoryAction.getDocSenderId().equals("-1")) ) {
            docSenderId = docRepositoryAction.getDocSenderId();
        }
        String docSenderName = "";
        if ((docRepositoryAction.getDocSenderName()!=null) && (!docRepositoryAction.getDocSenderName().equals("-1"))) {
            docSenderName = docRepositoryAction.getDocSenderName();
        }
        String docBusId = "";
        if ((docRepositoryAction.getDocBusId()!=null) && (!docRepositoryAction.getDocBusId().equals("-1"))) {
            docBusId = docRepositoryAction.getDocBusId();
        }
        String docRecName = "";
        if ((docRepositoryAction.getDocRecName()!=null) && (!docRepositoryAction.getDocRecName().equals("-1"))) {
            docRecName = docRepositoryAction.getDocRecName();
        }
       // String docIsa = docRepositoryAction.getDocIsa();
        String doctype = "";
        if ((docRepositoryAction.getDocType()!=null) && (!docRepositoryAction.getDocType().equals("-1"))) {
            doctype = docRepositoryAction.getDocType();
        }
        String corrattribute = docRepositoryAction.getCorrattribute();
        String corrvalue = docRepositoryAction.getCorrvalue();
        String corrattribute1 = docRepositoryAction.getCorrattribute1();
        String corrvalue1 = docRepositoryAction.getCorrvalue1();
        String corrattribute2 = docRepositoryAction.getCorrattribute2();
        String corrvalue2 = docRepositoryAction.getCorrvalue2();
        String status = docRepositoryAction.getStatus();
        String ackStatus = docRepositoryAction.getAckStatus();
        documentSearchQuery.append("SELECT DISTINCT(FILES.FILE_ID) as FILE_ID,FILES.ID as ID,FILES.ISA_NUMBER as ISA_NUMBER,"
                + "FILES.FILE_TYPE as FILE_TYPE,FILES.FILE_ORIGIN as FILE_ORIGIN,"
                + "FILES.TRANSACTION_TYPE as TRANSACTION_TYPE,FILES.DIRECTION as DIRECTION,"
                + "FILES.DATE_TIME_RECEIVED as DATE_TIME_RECEIVED,FILES.STATUS as STATUS,FILES.ACK_STATUS as ACK_STATUS,"
                + "TP2.NAME as RECEIVER_NAME,TP1.NAME as SENDER_NAME,FILES.SEC_KEY_VAL,FILES.REPROCESSSTATUS"
                + ",FILES.FILENAME,FILES.GS_CONTROL_NUMBER,FILES.PRI_KEY_VAL,ASN.BOL_NUMBER"//Added for metrie to get correlation column
                + " FROM FILES "
                + "LEFT OUTER JOIN TP TP1 ON (TP1.ID=FILES.SENDER_ID) LEFT OUTER JOIN TP TP2 "
                + "ON (TP2.ID=FILES.RECEIVER_ID)"
                + "LEFT OUTER JOIN ASN ON (ASN.FILE_ID = FILES.FILE_ID)");
        documentSearchQuery.append(" WHERE 1=1 AND FLOWFLAG like 'M' ");
        // FOr PO
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("PO Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.SEC_KEY_VAL", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("PO Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.SEC_KEY_VAL", corrvalue1.trim().toUpperCase()));
            }
        }

        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("PO Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.SEC_KEY_VAL", corrvalue2.trim().toUpperCase()));
            }
        }
        // For Invoice / Shipment / Cheque
        if ((corrattribute != null) &&( corrattribute.equalsIgnoreCase("Invoice Number") || corrattribute.equalsIgnoreCase("Shipment Number") || corrattribute.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.PRI_KEY_VAL", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Invoice Number") || corrattribute1.equalsIgnoreCase("Shipment Number") || corrattribute1.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.PRI_KEY_VAL", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Invoice Number") || corrattribute2.equalsIgnoreCase("Shipment Number") || corrattribute2.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.PRI_KEY_VAL", corrvalue2.trim().toUpperCase()));
            }
        }
        // isa 
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.ISA_Number", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.ISA_Number", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.ISA_Number", corrvalue2.trim().toUpperCase()));
            }
        }
        // bol
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ASN.BOL_NUMBER", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ASN.BOL_NUMBER", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ASN.BOL_NUMBER", corrvalue2.trim().toUpperCase()));
            }
        }
        // gs number
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("GS Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.GS_CONTROL_NUMBER", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("GS Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.GS_CONTROL_NUMBER", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute != null) && (corrattribute2.equalsIgnoreCase("GS Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.GS_CONTROL_NUMBER", corrvalue2.trim().toUpperCase()));
            }
        }
        // Adding the File Name
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILENAME", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILENAME", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILENAME", corrvalue2.trim().toUpperCase()));
            }
        }
        //Instance Id
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILE_ID", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILE_ID", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.FILE_ID", corrvalue2.trim().toUpperCase()));
            }
        }
        //Direction
         if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Direction"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.DIRECTION", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Direction"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.DIRECTION", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Direction"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.DIRECTION", corrvalue2.trim().toUpperCase()));
            }
        }
        
        
        
        if ((doctype != null) && (!"".equals(doctype.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.TRANSACTION_TYPE", doctype.trim()));
        }
        //Status
        if ((status != null) && (!"-1".equals(status.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.STATUS", status.trim()));
        }
        //ACK_STATUS
        if ((ackStatus != null) && (!"-1".equals(ackStatus.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("FILES.ACK_STATUS", ackStatus.trim()));
        }
        if ((docBusId != null) && (!"".equals(docBusId.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.ID", docBusId.trim().toUpperCase()));
        }
        if ((docSenderId != null) && (!"".equals(docSenderId.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.ID", docSenderId.trim().toUpperCase()));
        }
        if ((docSenderName != null) && (!"".equals(docSenderName.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.NAME", docSenderName.trim().toUpperCase()));
        }
        if ((docRecName != null) && (!"".equals(docRecName.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.NAME", docRecName.trim().toUpperCase()));
        }
        if ((docdatepicker != null) && (!"".equals(docdatepicker))) {
            tmp_Recieved_From = DateUtility.getInstance().DateViewToDBCompare(docdatepicker);
            documentSearchQuery.append(" AND FILES.DATE_TIME_RECEIVED <= '" + tmp_Recieved_From + "'");
        }
        if ((docdatepickerfrom != null) && (!"".equals(docdatepickerfrom))) {
            tmp_Recieved_From = DateUtility.getInstance().DateViewToDBCompare(docdatepickerfrom);
            documentSearchQuery.append(" AND FILES.DATE_TIME_RECEIVED >= '" + tmp_Recieved_From + "'");
        }
        documentSearchQuery.append(" order by DATE_TIME_RECEIVED DESC fetch first 50 rows only");
        String searchQuery = documentSearchQuery.toString();
        System.out.println("mscvp doc repository query-->"+searchQuery);
        try {
            connection = ConnectionProvider.getInstance().getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(searchQuery);
            documentList = new ArrayList<DocRepositoryBean>();
            while (resultSet.next()) {
                DocRepositoryBean docRepositoryBean = new DocRepositoryBean();
                docRepositoryBean.setId(resultSet.getInt("ID"));
                docRepositoryBean.setFile_id(resultSet.getString("FILE_ID"));
                docRepositoryBean.setFile_origin(resultSet.getString("FILE_ORIGIN"));
                docRepositoryBean.setFile_type(resultSet.getString("FILE_TYPE"));
                docRepositoryBean.setIsa_number(resultSet.getString("ISA_NUMBER"));
                docRepositoryBean.setTransaction_type(resultSet.getString("TRANSACTION_TYPE"));
                String direction = resultSet.getString("DIRECTION");
                docRepositoryBean.setDirection(direction);
                docRepositoryBean.setDate_time_rec(resultSet.getTimestamp("DATE_TIME_RECEIVED"));
                docRepositoryBean.setStatus(resultSet.getString("STATUS"));
                if (corrattribute != null && !"".equalsIgnoreCase(corrattribute)) {
                    docRepositoryBean.setCorrattribute(corrattribute);
                    if (corrattribute.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute.equalsIgnoreCase("Invoice Number") || corrattribute.equalsIgnoreCase("Shipment Number") || corrattribute.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("FILENAME"));
                    }
                }
                if (corrattribute1 != null && !"".equalsIgnoreCase(corrattribute1)) {
                    docRepositoryBean.setCorrattribute1(corrattribute1);
                    if (corrattribute1.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute1.equalsIgnoreCase("Invoice Number") || corrattribute1.equalsIgnoreCase("Shipment Number") || corrattribute1.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute1.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute1.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute1.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute1.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("FILENAME"));
                    }
                }
                if (corrattribute2 != null && !"".equalsIgnoreCase(corrattribute2)) {
                    docRepositoryBean.setCorrattribute2(corrattribute2);
                    if (corrattribute2.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute2.equalsIgnoreCase("Invoice Number") || corrattribute2.equalsIgnoreCase("Shipment Number") || corrattribute2.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute2.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute2.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute2.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute2.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("FILENAME"));
                    }
                }
                if ((direction!=null) && ("INBOUND".equalsIgnoreCase(direction))) {
                    docRepositoryBean.setPname(resultSet.getString("SENDER_NAME"));
                } else {
                    docRepositoryBean.setPname(resultSet.getString("RECEIVER_NAME"));
                }
                docRepositoryBean.setPoNumber(resultSet.getString("SEC_KEY_VAL"));
                docRepositoryBean.setReProcessStatus(resultSet.getString("REPROCESSSTATUS"));
                docRepositoryBean.setAckStatus(resultSet.getString("ACK_STATUS"));
                documentList.add(docRepositoryBean);
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
        return documentList;
    }
    
    public ArrayList<DocRepositoryBean> buildDocumentQueryArchive(DocRepositoryAction docRepositoryAction) throws ServiceLocatorException {
        StringBuffer documentSearchQuery = new StringBuffer();
        String docdatepicker = docRepositoryAction.getDocdatepicker();
        String docdatepickerfrom = docRepositoryAction.getDocdatepickerfrom();
        String docSenderId = "";
        if ((docRepositoryAction.getDocSenderId()!=null) && (!docRepositoryAction.getDocSenderId().equals("-1")) ) {
            docSenderId = docRepositoryAction.getDocSenderId();
        }
        String docSenderName = "";
        if ((docRepositoryAction.getDocSenderName()!=null) && (!docRepositoryAction.getDocSenderName().equals("-1"))) {
            docSenderName = docRepositoryAction.getDocSenderName();
        }
        String docBusId = "";
        if ((docRepositoryAction.getDocBusId()!=null) && (!docRepositoryAction.getDocBusId().equals("-1"))) {
            docBusId = docRepositoryAction.getDocBusId();
        }
        String docRecName = "";
        if ((docRepositoryAction.getDocRecName()!=null) && (!docRepositoryAction.getDocRecName().equals("-1"))) {
            docRecName = docRepositoryAction.getDocRecName();
        }
       // String docIsa = docRepositoryAction.getDocIsa();
        String doctype = "";
        if ((docRepositoryAction.getDocType()!=null) && (!docRepositoryAction.getDocType().equals("-1"))) {
            doctype = docRepositoryAction.getDocType();
        }
        String corrattribute = docRepositoryAction.getCorrattribute();
        String corrvalue = docRepositoryAction.getCorrvalue();
        String corrattribute1 = docRepositoryAction.getCorrattribute1();
        String corrvalue1 = docRepositoryAction.getCorrvalue1();
        String corrattribute2 = docRepositoryAction.getCorrattribute2();
        String corrvalue2 = docRepositoryAction.getCorrvalue2();
        String status = docRepositoryAction.getStatus();
        String ackStatus = docRepositoryAction.getAckStatus();
        documentSearchQuery.append("SELECT DISTINCT(ARCHIVE_FILES.FILE_ID) as FILE_ID,ARCHIVE_FILES.ID as ID,ARCHIVE_FILES.ISA_NUMBER as ISA_NUMBER,"
                + " ARCHIVE_FILES.FILE_TYPE as FILE_TYPE,ARCHIVE_FILES.FILE_ORIGIN as FILE_ORIGIN, ARCHIVE_FILES.TRANSACTION_TYPE as TRANSACTION_TYPE,"
                + " ARCHIVE_FILES.DIRECTION as DIRECTION, ARCHIVE_FILES.DATE_TIME_RECEIVED as DATE_TIME_RECEIVED,ARCHIVE_FILES.STATUS as STATUS,"
                + " ARCHIVE_FILES.ACK_STATUS as ACK_STATUS,TP2.NAME as RECEIVER_NAME,TP1.NAME as SENDER_NAME,ARCHIVE_FILES.SEC_KEY_VAL,"
                + " ARCHIVE_FILES.REPROCESSSTATUS,ARCHIVE_FILES.FILENAME,ARCHIVE_FILES.GS_CONTROL_NUMBER,ARCHIVE_FILES.PRI_KEY_VAL,ARCHIVE_ASN.BOL_NUMBER"
                + " FROM ARCHIVE_FILES LEFT OUTER JOIN TP TP1 ON (TP1.ID=ARCHIVE_FILES.SENDER_ID) "
                + " LEFT OUTER JOIN TP TP2 ON (TP2.ID=ARCHIVE_FILES.RECEIVER_ID)"
                + " LEFT OUTER JOIN ARCHIVE_ASN ON (ARCHIVE_ASN.FILE_ID = ARCHIVE_FILES.FILE_ID)");
        documentSearchQuery.append(" WHERE 1=1 AND FLOWFLAG like 'M' ");
        // FOr PO
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("PO Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.SEC_KEY_VAL", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("PO Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.SEC_KEY_VAL", corrvalue1.trim().toUpperCase()));
            }
        }

        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("PO Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.SEC_KEY_VAL", corrvalue2.trim().toUpperCase()));
            }
        }
        // For Invoice / Shipment / Cheque
        if ((corrattribute != null) &&( corrattribute.equalsIgnoreCase("Invoice Number") || corrattribute.equalsIgnoreCase("Shipment Number") || corrattribute.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.PRI_KEY_VAL", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Invoice Number") || corrattribute1.equalsIgnoreCase("Shipment Number") || corrattribute1.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.PRI_KEY_VAL", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Invoice Number") || corrattribute2.equalsIgnoreCase("Shipment Number") || corrattribute2.equalsIgnoreCase("Cheque Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.PRI_KEY_VAL", corrvalue2.trim().toUpperCase()));
            }
        }
        // isa 
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.ISA_Number", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.ISA_Number", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("ISA Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.ISA_Number", corrvalue2.trim().toUpperCase()));
            }
        }
        // bol
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_ASN.BOL_NUMBER", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_ASN.BOL_NUMBER", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("BOL Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_ASN.BOL_NUMBER", corrvalue2.trim().toUpperCase()));
            }
        }
        // gs number
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("GS Number"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.GS_CONTROL_NUMBER", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("GS Number"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.GS_CONTROL_NUMBER", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute != null) && (corrattribute2.equalsIgnoreCase("GS Number"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.GS_CONTROL_NUMBER", corrvalue2.trim().toUpperCase()));
            }
        }
        // Adding the File Name
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILENAME", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILENAME", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("FILE NAME"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILENAME", corrvalue2.trim().toUpperCase()));
            }
        }
        //Instance Id
        if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILE_ID", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILE_ID", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Instance Id"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.FILE_ID", corrvalue2.trim().toUpperCase()));
            }
        }
        //Direction
         if ((corrattribute != null) && (corrattribute.equalsIgnoreCase("Direction"))) {
            if (corrvalue != null && !"".equals(corrvalue.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.DIRECTION", corrvalue.trim().toUpperCase()));
            }
        }
        if ((corrattribute1 != null) && (corrattribute1.equalsIgnoreCase("Direction"))) {
            if (corrvalue1 != null && !"".equals(corrvalue1.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.DIRECTION", corrvalue1.trim().toUpperCase()));
            }
        }
        if ((corrattribute2 != null) && (corrattribute2.equalsIgnoreCase("Direction"))) {
            if (corrvalue2 != null && !"".equals(corrvalue2.trim())) {
                documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.DIRECTION", corrvalue2.trim().toUpperCase()));
            }
        }
        
        
        
        if ((doctype != null) && (!"".equals(doctype.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.TRANSACTION_TYPE", doctype.trim()));
        }
        //Status
        if ((status != null) && (!"-1".equals(status.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.STATUS", status.trim()));
        }
        //ACK_STATUS
        if ((ackStatus != null) && (!"-1".equals(ackStatus.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("ARCHIVE_FILES.ACK_STATUS", ackStatus.trim()));
        }
        if ((docBusId != null) && (!"".equals(docBusId.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.ID", docBusId.trim().toUpperCase()));
        }
        if ((docSenderId != null) && (!"".equals(docSenderId.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.ID", docSenderId.trim().toUpperCase()));
        }
        if ((docSenderName != null) && (!"".equals(docSenderName.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP1.NAME", docSenderName.trim().toUpperCase()));
        }
        if ((docRecName != null) && (!"".equals(docRecName.trim()))) {
            documentSearchQuery.append(WildCardSql.getWildCardSql1("TP2.NAME", docRecName.trim().toUpperCase()));
        }
        if ((docdatepicker != null) && (!"".equals(docdatepicker))) {
            tmp_Recieved_From = DateUtility.getInstance().DateViewToDBCompare(docdatepicker);
            documentSearchQuery.append(" AND ARCHIVE_FILES.DATE_TIME_RECEIVED <= '" + tmp_Recieved_From + "'");
        }
        if ((docdatepickerfrom != null) && (!"".equals(docdatepickerfrom))) {
            tmp_Recieved_From = DateUtility.getInstance().DateViewToDBCompare(docdatepickerfrom);
            documentSearchQuery.append(" AND ARCHIVE_FILES.DATE_TIME_RECEIVED >= '" + tmp_Recieved_From + "'");
        }
        documentSearchQuery.append(" order by DATE_TIME_RECEIVED DESC fetch first 50 rows only");
        String searchQuery = documentSearchQuery.toString();
        System.out.println("archive doc repository query-->"+searchQuery);
        try {
            connection = ConnectionProvider.getInstance().getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(searchQuery);
            documentList = new ArrayList<DocRepositoryBean>();
            while (resultSet.next()) {
                DocRepositoryBean docRepositoryBean = new DocRepositoryBean();
                docRepositoryBean.setId(resultSet.getInt("ID"));
                docRepositoryBean.setFile_id(resultSet.getString("FILE_ID"));
                docRepositoryBean.setFile_origin(resultSet.getString("FILE_ORIGIN"));
                docRepositoryBean.setFile_type(resultSet.getString("FILE_TYPE"));
                docRepositoryBean.setIsa_number(resultSet.getString("ISA_NUMBER"));
                docRepositoryBean.setTransaction_type(resultSet.getString("TRANSACTION_TYPE"));
                String direction = resultSet.getString("DIRECTION");
                docRepositoryBean.setDirection(direction);
                docRepositoryBean.setDate_time_rec(resultSet.getTimestamp("DATE_TIME_RECEIVED"));
                docRepositoryBean.setStatus(resultSet.getString("STATUS"));
                if (corrattribute != null && !"".equalsIgnoreCase(corrattribute)) {
                    docRepositoryBean.setCorrattribute(corrattribute);
                    if (corrattribute.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute.equalsIgnoreCase("Invoice Number") || corrattribute.equalsIgnoreCase("Shipment Number") || corrattribute.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue(resultSet.getString("FILENAME"));
                    }
                }
                if (corrattribute1 != null && !"".equalsIgnoreCase(corrattribute1)) {
                    docRepositoryBean.setCorrattribute1(corrattribute1);
                    if (corrattribute1.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute1.equalsIgnoreCase("Invoice Number") || corrattribute1.equalsIgnoreCase("Shipment Number") || corrattribute1.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute1.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute1.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute1.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute1.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue1(resultSet.getString("FILENAME"));
                    }
                }
                if (corrattribute2 != null && !"".equalsIgnoreCase(corrattribute2)) {
                    docRepositoryBean.setCorrattribute2(corrattribute2);
                    if (corrattribute2.equalsIgnoreCase("PO Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("SEC_KEY_VAL"));
                    }
                    if (corrattribute2.equalsIgnoreCase("Invoice Number") || corrattribute2.equalsIgnoreCase("Shipment Number") || corrattribute2.equalsIgnoreCase("Cheque Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("PRI_KEY_VAL"));
                    }
                    if (corrattribute2.equalsIgnoreCase("ISA Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("ISA_Number"));
                    }
                    if (corrattribute2.equalsIgnoreCase("BOL Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("BOL_NUMBER"));
                    }
                    if (corrattribute2.equalsIgnoreCase("GS Number")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("GS_CONTROL_NUMBER"));
                    }
                    if (corrattribute2.equalsIgnoreCase("FILE NAME")) {
                        docRepositoryBean.setCorrvalue2(resultSet.getString("FILENAME"));
                    }
                }
                if ((direction!=null) && ("INBOUND".equalsIgnoreCase(direction))) {
                    docRepositoryBean.setPname(resultSet.getString("SENDER_NAME"));
                } else {
                    docRepositoryBean.setPname(resultSet.getString("RECEIVER_NAME"));
                }
                docRepositoryBean.setPoNumber(resultSet.getString("SEC_KEY_VAL"));
                docRepositoryBean.setReProcessStatus(resultSet.getString("REPROCESSSTATUS"));
                docRepositoryBean.setAckStatus(resultSet.getString("ACK_STATUS"));
                documentList.add(docRepositoryBean);
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
        return documentList;
    }

    /**
     * @return the docRepositoryBean
     */
    public DocRepositoryBean getDocRepositoryBean() {
        return docRepositoryBean;
    }

    /**
     * @param docRepositoryBean the docRepositoryBean to set
     */
    public void setDocRepositoryBean(DocRepositoryBean docRepositoryBean) {
        this.docRepositoryBean = docRepositoryBean;
    }
    /**
     * @return the purchaseBean
     */
}
