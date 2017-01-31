/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.routing;

import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.DataSourceDataProvider;
import com.mss.ediscv.util.ServiceLocator;
import com.opensymphony.xwork2.ActionSupport;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.log4j.Logger;

/**
 *
 * @author miracle
 */
public class RoutingAction extends ActionSupport implements ServletRequestAware {

    private static Logger logger = Logger.getLogger(RoutingAction.class.getName());
    private HttpServletRequest httpServletRequest;
    private String resultType;
    private String formAction;
    private int routingId;
    private String name;
    private String acceptorLookupAlias;
    private String direction;
    private String internalRouteEmail;
    private String systemType;
    private String status;
    private String destMailBox;
    private String envelope;
    private String configFlowFlag;
    private String configFlowFlag1;

    public String addRouting() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            setFormAction("doAddRouting");
            resultType = SUCCESS;
        }
        return resultType;
    }

    public String doAddRouting() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            setFormAction("doAddRouting");
            String resultMessage = ServiceLocator.getRoutingService().addRouting(this);
            getHttpServletRequest().setAttribute(AppConstants.REQ_RESULT_MSG, resultMessage);
            resultType = SUCCESS;
        }
        return resultType;
    }

    public String getRoutingList() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            String defaultFlowId = httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_DEFAULT_FLOWID).toString();
            if (getConfigFlowFlag().equals("logistics")) {
                defaultFlowId = DataSourceDataProvider.getInstance().getFlowIdByFlowName("Logistics");
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_USER_DEFAULT_FLOWID, defaultFlowId);
            } else if (getConfigFlowFlag().equals("manufacturing")) {
                defaultFlowId = DataSourceDataProvider.getInstance().getFlowIdByFlowName("Manufacturing");
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_USER_DEFAULT_FLOWID, defaultFlowId);
            }
            if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_ROUTING_LIST) != null) {
                getHttpServletRequest().getSession(false).removeAttribute(AppConstants.SES_ROUTING_LIST);
            }
            resultType = SUCCESS;
        }
        return resultType;
    }

    public String routingSearch() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            ArrayList<RoutingBean> routingList = ServiceLocator.getRoutingService().buildRoutingQuery(this);
            getHttpServletRequest().getSession(false).setAttribute(AppConstants.SES_ROUTING_LIST, routingList);
            resultType = SUCCESS;
        }
        return resultType;
    }

    public String routingEdit() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            setFormAction("doEditRouting");
            ServiceLocator.getRoutingService().getRouting(this);
            resultType = SUCCESS;
        }
        return resultType;
    }

    public String doEditRouting() throws Exception {
        setResultType(LOGIN);
        if (getHttpServletRequest().getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            setFormAction("doEditRouting");
            String resultMessage = ServiceLocator.getRoutingService().editRouting(this);
            getHttpServletRequest().setAttribute(AppConstants.REQ_RESULT_MSG, resultMessage);
            resultType = SUCCESS;
        }
        return resultType;
    }

    @Override
    public void setServletRequest(HttpServletRequest httpServletRequest) {
        this.httpServletRequest = httpServletRequest;
    }

    public HttpServletRequest getHttpServletRequest() {
        return httpServletRequest;
    }

    /**
     * @return the resultType
     */
    public String getResultType() {
        return resultType;
    }

    /**
     * @param resultType the resultType to set
     */
    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    /**
     * @return the formAction
     */
    public String getFormAction() {
        return formAction;
    }

    /**
     * @param formAction the formAction to set
     */
    public void setFormAction(String formAction) {
        this.formAction = formAction;
    }

    /**
     * @return the routingId
     */
    public int getRoutingId() {
        return routingId;
    }

    /**
     * @param routingId the routingId to set
     */
    public void setRoutingId(int routingId) {
        this.routingId = routingId;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the acceptorLookupAlias
     */
    public String getAcceptorLookupAlias() {
        return acceptorLookupAlias;
    }

    /**
     * @param acceptorLookupAlias the acceptorLookupAlias to set
     */
    public void setAcceptorLookupAlias(String acceptorLookupAlias) {
        this.acceptorLookupAlias = acceptorLookupAlias;
    }

    /**
     * @return the direction
     */
    public String getDirection() {
        return direction;
    }

    /**
     * @param direction the direction to set
     */
    public void setDirection(String direction) {
        this.direction = direction;
    }

    /**
     * @return the internalRouteEmail
     */
    public String getInternalRouteEmail() {
        return internalRouteEmail;
    }

    /**
     * @param internalRouteEmail the internalRouteEmail to set
     */
    public void setInternalRouteEmail(String internalRouteEmail) {
        this.internalRouteEmail = internalRouteEmail;
    }

    /**
     * @return the systemType
     */
    public String getSystemType() {
        return systemType;
    }

    /**
     * @param systemType the systemType to set
     */
    public void setSystemType(String systemType) {
        this.systemType = systemType;
    }

    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }

    /**
     * @return the destMailBox
     */
    public String getDestMailBox() {
        return destMailBox;
    }

    /**
     * @param destMailBox the destMailBox to set
     */
    public void setDestMailBox(String destMailBox) {
        this.destMailBox = destMailBox;
    }

    /**
     * @return the envelope
     */
    public String getEnvelope() {
        return envelope;
    }

    /**
     * @param envelope the envelope to set
     */
    public void setEnvelope(String envelope) {
        this.envelope = envelope;
    }

    public String getConfigFlowFlag() {
        return configFlowFlag;
    }

    public void setConfigFlowFlag(String configFlowFlag) {
        this.configFlowFlag = configFlowFlag;
    }

    public String getConfigFlowFlag1() {
        return configFlowFlag1;
    }

    public void setConfigFlowFlag1(String configFlowFlag1) {
        this.configFlowFlag1 = configFlowFlag1;
    }
}
