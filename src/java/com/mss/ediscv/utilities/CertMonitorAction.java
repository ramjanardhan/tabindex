
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.utilities;

import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.ServiceLocator;
import com.mss.ediscv.util.ServiceLocatorException;
import com.opensymphony.xwork2.ActionSupport;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.core.ApplicationContext;
import org.apache.struts2.interceptor.ParameterAware;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;

/**
 *
 * @author miracle
 */
public class CertMonitorAction extends ActionSupport implements ServletRequestAware, ServletResponseAware {

    private String certType;
    HttpServletRequest hsrequest;
    HttpServletResponse hsresponse;
    private String docdatepickerfrom;
    private String docdatepicker;
    private String reportrange;

    public void setServletRequest(HttpServletRequest hsrequest) {
        this.hsrequest = hsrequest;
    }

    public HttpServletRequest getServletRequest() {
        return hsrequest;
    }

    public void setServletResponse(HttpServletResponse hsresponse) {

        this.hsresponse = hsresponse;
    }

    public HttpServletResponse getServletResponse() {

        return hsresponse;
    }

    public String getCertType() {
        return certType;
    }

    public void setCertType(String certType) {
        this.certType = certType;
    }

    public String getDocdatepickerfrom() {
        return docdatepickerfrom;
    }

    public void setDocdatepickerfrom(String docdatepickerfrom) {
        this.docdatepickerfrom = docdatepickerfrom;
    }

    public String getDocdatepicker() {
        return docdatepicker;
    }

    public void setDocdatepicker(String docdatepicker) {
        this.docdatepicker = docdatepicker;
    }

    public String getReportrange() {
        return reportrange;
    }

    public void setReportrange(String reportrange) {
        this.reportrange = reportrange;
    }

    public String getCertMonitor() throws Exception {
        String resultType = LOGIN;
        
        String cert = "SYSTEM";
        List list = ServiceLocator.getCertMonitorService().getCertMonitorData(getCertType(), getDocdatepickerfrom(), getDocdatepicker());
        hsrequest.getSession(false).setAttribute(AppConstants.CERTMONITOR_LIST, list);
        resultType = SUCCESS;
        return resultType;

    }
}
