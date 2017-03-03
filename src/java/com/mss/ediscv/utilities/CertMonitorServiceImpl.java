
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.utilities;

import com.lowagie.text.pdf.ArabicLigaturizer;
import com.mss.ediscv.util.ServiceLocatorException;
import java.sql.Array;
import java.sql.Connection;
import java.util.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import oracle.sql.ARRAY;

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
}