/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.griddownload;

import com.mss.ediscv.util.ConnectionProvider;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocatorException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author miracle
 */
public class GridDownloadServiceImpl implements GridDownloadService {

    public String getReportattachment(int scheduleId, String startDate) throws ServiceLocatorException {
        Connection connection = null;
        Statement statement = null;
        String reportpath = "Nodata";
        String queryString = "";
        ResultSet resultSet = null;
        startDate = DateUtility.getInstance().DateViewToDBCompare(startDate);
        startDate = startDate.substring(0, 10);
        queryString = "SELECT SCH_REPORTPATH from SCH_LOOKUPS where SCH_ID=" + scheduleId + " and date(SCH_RUNDATE) = DATE('" + startDate + "')";
        try {
            connection = ConnectionProvider.getInstance().getConnection();
            statement = connection.createStatement();
            resultSet = statement.executeQuery(queryString);
            if (resultSet.next()) {
                reportpath = resultSet.getString("SCH_REPORTPATH");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } catch (ServiceLocatorException sle) {
            sle.printStackTrace();
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
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return reportpath;
    }
}
