package com.mss.ediscv.util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.sql.DataSource;

public class ConnectionProvider {

    private static ConnectionProvider _instance;
    private DataSource dataSource;
    private Connection connection;

    private ConnectionProvider() {
    }

    public static ConnectionProvider getInstance() {
        if (_instance == null) {
            _instance = new ConnectionProvider();
        }
        return _instance;
    }

    public Connection getConnection() throws ServiceLocatorException {
        try {
            String dsnName = ConfigProperties.getProperty("DB.DSNNAME");
            // System.out.println("datasource name"+dsnName);
            //System.out.println("in get connection using datasource----");

            dataSource = DataServiceLocator.getInstance().getDataSource(dsnName);
            // System.out.println("after get the datasource----"+dataSource);
            connection = dataSource.getConnection();
            // System.out.println("after get the connection!!!"+connection);
        } catch (ServiceLocatorException se) {

            throw new ServiceLocatorException("Exception in Connection Provider");
        } catch (SQLException sqlEx) {
            // System.err.println("Exception-->"+sqlEx.getMessage());
            throw new ServiceLocatorException(sqlEx);
        }
        return connection;
    }
}
