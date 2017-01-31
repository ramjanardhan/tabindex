package com.mss.ediscv.general;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.struts2.interceptor.ServletRequestAware;
import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.ConnectionProvider;
import com.mss.ediscv.util.DataSourceDataProvider;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.PasswordUtil;
import com.mss.ediscv.util.Properties;
import com.mss.ediscv.util.ServiceLocator;
import com.mss.ediscv.util.ServiceLocatorException;
import com.opensymphony.xwork2.ActionSupport;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import org.apache.log4j.Logger;

public class LoginAction extends ActionSupport implements ServletRequestAware {

    private static Logger logger = Logger.getLogger(LoginAction.class.getName());
    /* resultType used to store type of the result */
    private String resultType = SUCCESS;
    /* httpServletRequest used to store HttpServletRequest instance */
    private HttpServletRequest httpServletRequest;
    /* loginId used to store loginId of the employee */
    private String loginId;
    /* password used to store password of the employee */
    private String password;
    private String changeDb;
    /*
     * (non-Javadoc)
     * @see com.opensymphony.xwork2.ActionSupport#execute()
     */

    @Override
    public String execute() throws Exception {
        UserInfoBean userInfoBean = null;
        byte[] imgData = null;
        try {
            GeneralService generalService = ServiceLocator.getGeneralService();
            HttpSession userSession = httpServletRequest.getSession(true);
            String dsnName = Properties.getProperty(AppConstants.PROP_PROD_DS_NAME);
            userInfoBean = generalService.getUserInfo(getLoginId().trim().toLowerCase(), dsnName);
            if (userInfoBean != null) {
                String decryptedPwd = PasswordUtil.decryptPwd(userInfoBean.getPassword().trim());
                if (decryptedPwd.equals(getPassword())) {
                    if ("A".equals(userInfoBean.getActiveFlag())) {
                        Map<Integer, Integer> userRolesMap = new HashMap<Integer, Integer>();
                        userRolesMap = generalService.getUserRoles(userInfoBean.getUserId(), dsnName);
                        String primaryRole = Properties.getProperty(AppConstants.PROP_USER_DEF_ROLE);
                        if (userRolesMap.get(1) != null) {
                            primaryRole = String.valueOf(userRolesMap.get(1));
                        }
                        String primaryFlowId = DataSourceDataProvider.getInstance().getPrimaryFlowID(userInfoBean.getUserId());
                        if (primaryFlowId != null) {
                            userSession.setAttribute(AppConstants.SES_ROLE_ID, primaryRole);
                            userSession.setAttribute(AppConstants.SES_USER_ID, userInfoBean.getUserId());
                            userSession.setAttribute(AppConstants.SES_LOGIN_ID, userInfoBean.getLoginId());
                            userSession.setAttribute(AppConstants.SES_USER_NAME, userInfoBean.getFirstName() + " " + userInfoBean.getLastName());
                            userSession.setAttribute(AppConstants.SES_LAST_LOGIN_TS, userInfoBean.getLastLoginTS().toString());
                            userSession.setAttribute(AppConstants.SES_FIRST_DB, "Production Data");
                            userSession.setAttribute(AppConstants.PROP_CURRENT_DS_NAME, Properties.getProperty(AppConstants.PROP_PROD_DS_NAME));
                            userSession.setAttribute(AppConstants.SES_EMAIL_ID, userInfoBean.getMailId());
                            Map usrFlowMap = DataSourceDataProvider.getInstance().getFlows(userInfoBean.getUserId());
                            //  System.out.println("UserFlowss----->" + usrFlowMap);
                            userSession.setAttribute(AppConstants.SES_USER_FLOW_MAP, usrFlowMap);
                            // System.out.println("Roleid--->" + primaryRole);
                            // System.out.println("RoleName--->" + DataSourceDataProvider.getInstance().getRoleNameByRoleId(primaryRole));
                            userSession.setAttribute(AppConstants.SES_USER_ROLE_NAME, DataSourceDataProvider.getInstance().getRoleNameByRoleId(primaryRole));
                            userSession.setAttribute(AppConstants.SES_STATES_MAP, DataSourceDataProvider.getInstance().getStates());
                            String Resulttype = "input";
                            setResultType(DataSourceDataProvider.getInstance().getFlowNameByFlowID(primaryFlowId));
                            userSession.setAttribute(AppConstants.SES_USER_DEFAULT_FLOWID, primaryFlowId);
                            userSession.setAttribute(AppConstants.MSCVPROLE, DataSourceDataProvider.getInstance().getRoleNameByRoleId(primaryRole));
                            if (userInfoBean.getUserImage() != null) {
                                imgData = userInfoBean.getUserImage();
                            }
                            userSession.setAttribute(AppConstants.SESSION_USER_IMAGE, imgData);
                        } else {
                            setResultType(INPUT);
                            httpServletRequest.setAttribute(AppConstants.REQ_ERROR_INFO, "<span class=\"resultFailure\"><b>Access Denied, Please contact Admin! </b></span>");
                        }
                    } else {
                        httpServletRequest.setAttribute(AppConstants.REQ_ERROR_INFO, "<span class=\"resultFailure\"><b>Sorry! Your account was InActive, Please contact Admin! </b></span>");
                        setResultType(INPUT);
                    }
                } else {
                    httpServletRequest.setAttribute(AppConstants.REQ_ERROR_INFO, "<b>Please Login with valid UserId and Password! </b>");
                    setResultType(INPUT);
                }
            } else {
                httpServletRequest.setAttribute(AppConstants.REQ_ERROR_INFO, "<span class=\"resultFailure\"><b>Please Login with valid UserId and Password! </b></span>");
                setResultType(INPUT);
            }
            System.out.println("result--->" + getResultType());
            if (getResultType().equals("input")) {
                httpServletRequest.getSession(false).removeAttribute(AppConstants.SES_LOGIN_ID);
            }
        } catch (Exception e) {
            setResultType(ERROR);
            httpServletRequest.getSession(false).setAttribute("exceptionMessage", "Unable to connect Database Please contact System Admin!");
        }
        return getResultType();
    }

    public void logUserAccess() throws Exception {
        try {
            if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_LOGIN_ID) != null) {
                String UserId = getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_LOGIN_ID).toString();
                String forwarded = httpServletRequest.getHeader("X-FORWARDED-FOR");
                String via = httpServletRequest.getHeader("VIA");
                String remote = httpServletRequest.getRemoteAddr();
                String agent = httpServletRequest.getHeader("User-Agent");
                String location = httpServletRequest.getLocalAddr();
                Timestamp accessedtime = DateUtility.getInstance().getCurrentDB2Timestamp();
                Connection connection = null;
                Statement stmt = null;
                boolean isInserted = false;
                String query = null;
                try {
                    connection = ConnectionProvider.getInstance().getConnection();
                    query = "insert into LOGUSERACCESS(LoginId,X_FORWARDED_FOR1,VIA, REMOTE_ADDR,User_Agent,DateAccessed)" + " values('" + UserId + "','" + forwarded + "','" + via + "','" + remote + "','" + agent + "','" + accessedtime + "')";
                    stmt = connection.createStatement();
                    int x = stmt.executeUpdate(query);
                    stmt.close();
                    if (x > 0) {
                        isInserted = true;
                    }
                } catch (SQLException sql) {
                    sql.printStackTrace();
                    throw new ServiceLocatorException(sql);
                } finally {
                    try {
                        if (stmt != null) {
                            stmt.close();
                            stmt = null;
                        }
                        if (connection != null) {
                            connection.close();
                            connection = null;
                        }
                    } catch (SQLException sqle) {
                        throw new ServiceLocatorException(sqle);
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            getHttpServletRequest().getSession(false).setAttribute("errorMessage", ex.toString());
            resultType = ERROR;
        }
    }

    /**
     * method is used to invalidate session
     */
    public String switchDB() throws Exception {
        HttpSession userSession = httpServletRequest.getSession(false);
        String db = userSession.getAttribute(AppConstants.SES_FIRST_DB).toString();
        if (db.startsWith("Ar")) {
            userSession.setAttribute(AppConstants.PROP_CURRENT_DS_NAME, Properties.getProperty(AppConstants.PROP_PROD_DS_NAME));
            userSession.setAttribute(AppConstants.SES_FIRST_DB, "Production Data");
        } else {
            userSession.setAttribute(AppConstants.PROP_CURRENT_DS_NAME, Properties.getProperty(AppConstants.PROP_ARCH_DS_NAME));
            userSession.setAttribute(AppConstants.SES_FIRST_DB, "Archive Data");
        }
        return "success";
    }

    public String doLogout() throws Exception {
        try {
            if (httpServletRequest.getSession(false) != null) {
                httpServletRequest.getSession(false).invalidate();
            }
            setResultType(SUCCESS);
        } catch (Exception ex) {
            httpServletRequest.getSession(false).setAttribute(AppConstants.REQ_ERROR_INFO, ex.toString());
            setResultType(ERROR);
        }
        return getResultType();
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.apache.struts2.interceptor.ServletRequestAware#setServletRequest(
     * javax.servlet.http.HttpServletRequest)
     */
    //@Override
    public void setServletRequest(HttpServletRequest reqObj) {
        this.setHttpServletRequest(reqObj);
    }

    /**
     * @param resultType
     *            the resultType to set
     */
    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    /**
     * @return the resultType
     */
    public String getResultType() {
        return resultType;
    }

    /**
     * @param httpServletRequest
     *            the httpServletRequest to set
     */
    public void setHttpServletRequest(HttpServletRequest httpServletRequest) {
        this.httpServletRequest = httpServletRequest;
    }

    /**
     * @return the httpServletRequest
     */
    public HttpServletRequest getHttpServletRequest() {
        return httpServletRequest;
    }

    /**
     * @param loginId
     *            the loginId to set
     */
    public void setLoginId(String loginId) {
        this.loginId = loginId;
    }

    /**
     * @return the loginId
     */
    public String getLoginId() {
        return loginId;
    }

    /**
     * @param password
     *            the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param changeDb
     *            the changeDb to set
     */
    public void setChangeDb(String changeDb) {
        this.changeDb = changeDb;
    }

    /**
     * @return the changeDb
     */
    public String getChangeDb() {
        return changeDb;
    }
}
