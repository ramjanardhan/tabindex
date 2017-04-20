
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.utilities;

import com.lowagie.text.pdf.ArabicLigaturizer;
import com.mss.ediscv.util.ConnectionProvider;
import com.mss.ediscv.util.ServiceLocatorException;
import java.sql.Array;
import java.sql.Connection;
import java.util.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import oracle.sql.ARRAY;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author miracle
 */
public class CertMonitorServiceImpl implements CertMonitorService {

    public List getCertMonitorData(String certType, String dateFrom, String dateTo) throws ServiceLocatorException {

        String cType = certType;
        Connection con = null;
        List<LinkedHashMap> al = new LinkedList<LinkedHashMap>();
        System.out.println("dateFrom is " + dateFrom);
        String date = null;
        String dateto = null;
        if ((dateFrom != null) && !"".equalsIgnoreCase(dateFrom)) {
            date = dateFrom.replace("/", "-").substring(0, 10);
            dateto = dateTo.replace("/", "-").substring(0, 10);

        }
        System.out.println("datefrom is " + date);
        System.out.println("dateto is " + dateto);
        try {

            Class.forName("oracle.jdbc.OracleDriver");
            con = DriverManager.getConnection("jdbc:oracle:thin:@192.168.1.179:1521:orcl", "si_user", "SI_admin1");
            Statement st = con.createStatement();
            ResultSet rs = null;
            if ("TRUSTED".equalsIgnoreCase(cType)) {
                if ((dateFrom != null) && !"".equalsIgnoreCase(dateFrom)) {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM TRUSTED_CERT_INFO WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy') ORDER BY DAYS ");
                    //  System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM TRUSTED_CERT_INFO WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy') ORDER BY DAYS ");
                } else {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM TRUSTED_CERT_INFO ORDER BY DAYS ");
                    //  System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM TRUSTED_CERT_INFO ORDER BY DAYS ");

                }
            } else if ("CA".equalsIgnoreCase(cType)) {
                if ((dateFrom != null) && !"".equalsIgnoreCase(dateFrom)) {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM CA_CERT_INFO WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy')  ORDER BY DAYS");
                    // System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM CA_CERT_INFO WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy')  ORDER BY DAYS");;
                } else {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM CA_CERT_INFO   ORDER BY DAYS");
                    // System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL , (to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy')) AS DAYS FROM CA_CERT_INFO   ORDER BY DAYS");
                }
            } else if ("SYSTEM".equalsIgnoreCase(cType)) {
                if ((dateFrom != null) && !"".equalsIgnoreCase(dateFrom)) {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL ,(to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy'))  AS DAYS FROM CERTS_AND_PRI_KEY WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy')   ORDER BY DAYS");
                    // System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL ,(to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy'))  AS DAYS FROM CERTS_AND_PRI_KEY WHERE NOT_BEFORE > to_date('" + date + "','dd-mm-yyyy') AND NOT_AFTER < to_date('" + dateto + "','dd-mm-yyyy')   ORDER BY DAYS");;
                } else {
                    rs = st.executeQuery("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL ,(to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy'))  AS DAYS FROM CERTS_AND_PRI_KEY   ORDER BY DAYS");
                    // System.out.println("SELECT NAME AS CERTIFICATE_NAME,NOT_BEFORE as VALID_FROM , NOT_AFTER as VALID_TILL ,(to_date (NOT_AFTER,'dd-MM-yyyy') - to_date(SYSDATE,'dd-MM-yyyy'))  AS DAYS FROM CERTS_AND_PRI_KEY   ORDER BY DAYS");
                }
            }

            ResultSetMetaData md = rs.getMetaData();
            int columncount = md.getColumnCount();
            LinkedHashMap map;

            while (rs.next()) {
                map = new LinkedHashMap();
                System.out.println("map = " + map);
                for (int i = 1; i <= columncount; i++) {

                    map.put(md.getColumnName(i), rs.getObject(i));
                }
                al.add(map);
                System.out.println("al**" + al);
            }

        } catch (SQLException s) {

            s.printStackTrace();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }

        return al;

    }

    @Override
    public List doCodeListItems(String selectedName) throws ServiceLocatorException {
        System.out.println("in getListName");
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String queryString = null;
        connection = ConnectionProvider.getInstance().getOracleConnection();
        List codeList = new ArrayList();
        CodeListBean codeListBean = null;
        String listName = null;
        System.out.println("before try");
        try {
            queryString = "SELECT  * FROM CODELIST_XREF_ITEM WHERE  LIST_NAME='" + selectedName + "'";
            preparedStatement = connection.prepareStatement(queryString);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                codeListBean = new CodeListBean();
                codeListBean.setListName(resultSet.getString("LIST_NAME"));
                codeListBean.setSender_id(resultSet.getString("SENDER_ID"));
                codeListBean.setReceiver_id(resultSet.getString("RECEIVER_ID"));
                codeListBean.setList_version(resultSet.getString("LIST_VERSION"));
                codeListBean.setSender_item(resultSet.getString("SENDER_ITEM"));
                codeListBean.setReceiver_item(resultSet.getString("RECEIVER_ITEM"));
                codeListBean.setText1(resultSet.getString("TEXT1"));
                codeListBean.setText2(resultSet.getString("TEXT2"));
                codeListBean.setText3(resultSet.getString("TEXT3"));
                codeListBean.setText4(resultSet.getString("TEXT4"));
                codeListBean.setDescription(resultSet.getString("DESCRIPTION"));
                codeListBean.setText5(resultSet.getString("TEXT5"));
                codeListBean.setText6(resultSet.getString("TEXT6"));
                codeListBean.setText7(resultSet.getString("TEXT7"));
                codeListBean.setText8(resultSet.getString("TEXT8"));
                codeListBean.setText9(resultSet.getString("TEXT9"));
                codeList.add(codeListBean);

            }
        } catch (SQLException sql) {
            throw new ServiceLocatorException(sql);
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                    resultSet = null;
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                    preparedStatement = null;
                }
                if (connection != null) {
                    connection.close();
                    connection = null;
                }
            } catch (SQLException ex) {
                throw new ServiceLocatorException(ex);
            }
        }
        return codeList;
    }

    @Override
    public List getCodeListNames(String selectedName) throws ServiceLocatorException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        String queryString = null;
        connection = ConnectionProvider.getInstance().getOracleConnection();
        List listNameMap = new ArrayList();
        String listName = null;
        try {
            //queryString = "SELECT  DISTINCT(LIST_NAME) FROM CODELIST_XREF_ITEM WHERE UPPER(LIST_NAME) LIKE '" + selectedName.toUpperCase() + "%'";
            queryString = "SELECT  DISTINCT(LIST_NAME) FROM CODELIST_XREF_ITEM WHERE UPPER(LIST_NAME) LIKE '%" + selectedName.toUpperCase() + "%'";
            System.out.println("queryString----"+queryString);
            preparedStatement = connection.prepareStatement(queryString);
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                listNameMap.add(resultSet.getString("LIST_NAME"));
            }
        } catch (SQLException sql) {
            throw new ServiceLocatorException(sql);
        } finally {
            try {
                if (resultSet != null) {
                    resultSet.close();
                    resultSet = null;
                }
                if (preparedStatement != null) {
                    preparedStatement.close();
                    preparedStatement = null;
                }
                if (connection != null) {
                    connection.close();
                    connection = null;
                }
            } catch (SQLException ex) {
                throw new ServiceLocatorException(ex);
            }
        }
        return listNameMap;
    }

    @Override
    public String addCodeList(String jsonData, String userName) throws ServiceLocatorException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        String queryString = null;
        connection = ConnectionProvider.getInstance().getOracleConnection();
        JSONArray array = null;
        JSONObject jsonObj = null;
        int updatedRows = 0;
        int updatedRows1 = 0;
        int updatedRows2 = 0;
        try {
            array = new JSONArray(jsonData);

        } catch (JSONException ex) {
            Logger.getLogger(CertMonitorServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
        }

        try {
            queryString = "INSERT INTO SI_USER.CODELIST_XREF_ITEM "
                    + "(LIST_NAME, SENDER_ID, RECEIVER_ID, LIST_VERSION, SENDER_ITEM, RECEIVER_ITEM, TEXT1, TEXT2, TEXT3, TEXT4, DESCRIPTION, TEXT5, TEXT6, TEXT7, TEXT8, TEXT9)"
                    + " VALUES (?, ?, ?,? , ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            String queryString1 = "INSERT INTO SI_USER.CODELIST_XREF_VERS"
                    + "	(LIST_NAME, SENDER_ID, RECEIVER_ID, DEFAULT_VERSION, LIST_VERSION)"
                    + "VALUES (?, ?, ?, ?, ?)";
            String queryString2 = "INSERT INTO SI_USER.CODE_LIST_XREF"
                    + "	(LIST_NAME, SENDER_ID, RECEIVER_ID, LIST_VERSION, STATUS, COMMENTS,  USERNAME, CREATE_DATE)"
                    + "VALUES (?, ?, ?, ?,? ,?,?, ?)";
            for (int i = 0; i < array.length(); i++) {
                jsonObj = array.getJSONObject(i);
                preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, jsonObj.getString("listName1"));
                preparedStatement.setString(2, jsonObj.getString("senderIdInst"));
                preparedStatement.setString(3, jsonObj.getString("recId"));
                preparedStatement.setInt(4, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement.setString(5, jsonObj.getString("senderItem"));
                preparedStatement.setString(6, jsonObj.getString("recItem"));
                preparedStatement.setString(7, jsonObj.getString("text1"));
                preparedStatement.setString(8, jsonObj.getString("text2"));
                preparedStatement.setString(9, jsonObj.getString("text3"));
                preparedStatement.setString(10, jsonObj.getString("text4"));
                preparedStatement.setString(11, jsonObj.getString("desc"));
                preparedStatement.setString(12, jsonObj.getString("text5"));
                preparedStatement.setString(13, jsonObj.getString("text6"));
                preparedStatement.setString(14, jsonObj.getString("text7"));
                preparedStatement.setString(15, jsonObj.getString("text8"));
                preparedStatement.setString(16, jsonObj.getString("text9"));
                preparedStatement1 = connection.prepareStatement(queryString1);
                preparedStatement1.setString(1, jsonObj.getString("listName1"));
                preparedStatement1.setString(2, jsonObj.getString("senderIdInst"));
                preparedStatement1.setString(3, jsonObj.getString("recId"));
                preparedStatement1.setInt(4, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement1.setInt(5, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement2 = connection.prepareStatement(queryString2);
                preparedStatement2.setString(1, jsonObj.getString("listName1"));
                preparedStatement2.setString(2, jsonObj.getString("senderIdInst"));
                preparedStatement2.setString(3, jsonObj.getString("recId"));
                preparedStatement2.setInt(4, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement2.setInt(5, 1);
                preparedStatement2.setString(6, "");
                preparedStatement2.setString(7, userName);
                //java.sql.Date d=new java.sql.Date(i);
                //SimpleDateFormat sd=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                //SimpleDateFormat sd=new SimpleDateFormat("YYYY-MM-dd HH24:mm:SS.0");
                preparedStatement2.setDate(8, new java.sql.Date(System.currentTimeMillis()));
                updatedRows = preparedStatement.executeUpdate();
                updatedRows1 = preparedStatement1.executeUpdate();
                updatedRows2 = preparedStatement2.executeUpdate();

            }
        } catch (SQLException sql) {
            throw new ServiceLocatorException(sql);
        } catch (JSONException e) {
            e.printStackTrace();
        } finally {
            try {

                if (preparedStatement != null) {
                    preparedStatement.close();
                    preparedStatement = null;
                }
                if (connection != null) {
                    connection.close();
                    connection = null;
                }
            } catch (SQLException ex) {
                throw new ServiceLocatorException(ex);
            }
        }
        if (updatedRows > 0 && updatedRows1 > 0 && updatedRows2 > 0) {
            return "<font color='green'>Inserted successfully</font>";
        } else {
            return "<font color='red'>Please Try Again</font>";
        }
    }

    @Override
    public String deleteCodeList(String jsonData) throws ServiceLocatorException {
        Connection connection = null;
        PreparedStatement preparedStatement = null;
        PreparedStatement preparedStatement1 = null;
        PreparedStatement preparedStatement2 = null;
        String queryString = null;
        String queryString1 = null;
        String queryString2 = null;
        connection = ConnectionProvider.getInstance().getOracleConnection();
        JSONArray array = null;
        JSONObject jsonObj = null;
        int updatedRows = 0;
        int updatedRows1 = 0;
        int updatedRows2 = 0;
        try {
            array = new JSONArray(jsonData);

        } catch (JSONException ex) {
            Logger.getLogger(CertMonitorServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
        }

        try {
            queryString = "DELETE FROM SI_USER.CODELIST_XREF_ITEM WHERE LIST_NAME=? AND LIST_VERSION=? AND SENDER_ITEM=?";
            queryString1 = "DELETE FROM SI_USER.CODELIST_XREF_VERS WHERE LIST_NAME=? AND LIST_VERSION=? AND SENDER_ID=?";
            queryString2 = "DELETE FROM SI_USER.CODE_LIST_XREF WHERE LIST_NAME=? AND LIST_VERSION=? AND SENDER_ID=?";
            for (int i = 0; i < array.length(); i++) {
                jsonObj = array.getJSONObject(i);
                preparedStatement = connection.prepareStatement(queryString);
                preparedStatement.setString(1, jsonObj.getString("listName1"));
                preparedStatement.setInt(2, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement.setString(3, jsonObj.getString("senderItem"));
                preparedStatement1 = connection.prepareStatement(queryString1);
                preparedStatement1.setString(1, jsonObj.getString("listName1"));
                preparedStatement1.setInt(2, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement1.setString(3, jsonObj.getString("senderItem"));
                preparedStatement2 = connection.prepareStatement(queryString2);
                preparedStatement2.setString(1, jsonObj.getString("listName1"));
                preparedStatement2.setInt(2, Integer.parseInt(jsonObj.getString("listVerson")));
                preparedStatement2.setString(3, jsonObj.getString("senderItem"));
                updatedRows = preparedStatement.executeUpdate();
                updatedRows1 = preparedStatement1.executeUpdate();
                updatedRows2 = preparedStatement2.executeUpdate();
            }
        } catch (SQLException sql) {
            throw new ServiceLocatorException(sql);
        } catch (JSONException e) {
            e.printStackTrace();
        } finally {
            try {

                if (preparedStatement != null) {
                    preparedStatement.close();
                    preparedStatement = null;
                }
                if (connection != null) {
                    connection.close();
                    connection = null;
                }
            } catch (SQLException ex) {
                throw new ServiceLocatorException(ex);
            }
        }
        if (updatedRows > 0 && updatedRows1 > 0 &&  updatedRows2 > 0) {
            return "<font color='green'>Deleted successfully</font>";
        } else {
            return "<font color='red'>Please Try Again</font>";
        }
    }

}
