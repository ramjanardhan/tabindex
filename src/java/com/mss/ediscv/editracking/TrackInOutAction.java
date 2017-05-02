/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.editracking;

import com.opensymphony.xwork2.ActionSupport;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.log4j.Logger;
import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.DataSourceDataProvider;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

/**
 * @author miracle
 */
public class TrackInOutAction extends ActionSupport implements ServletRequestAware {

    private static Logger logger = Logger.getLogger(TrackInOutAction.class.getName());
    private HttpServletRequest httpServletRequest;
    private String docdatepicker;
    private String docdatepickerfrom;
    private String resultType;
    private String formAction;
    private List docTypeList;
    private List networklanlist;
    private String docType;
    private String partnerMapId;
    private String docNetworkvan;
    private List<TrackInOutBean> documentList;
    private Map partnerMap;

    public String getTrackDetails() throws Exception {
        setResultType(LOGIN);
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            String defaultFlowId = httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_DEFAULT_FLOWID).toString();
            String defaultFlowName = DataSourceDataProvider.getInstance().getFlowNameByFlowID(defaultFlowId);
            if (!defaultFlowName.equals("Manufacturing")) {
                defaultFlowId = DataSourceDataProvider.getInstance().getFlowIdByFlowName("Manufacturing");
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_USER_DEFAULT_FLOWID, defaultFlowId);
            }
            List docList;
            docList = DataSourceDataProvider.getInstance().getDocumentTypeList("M");
            setDocTypeList(docList);
            setPartnerMap(DataSourceDataProvider.getInstance().getDashboardPartnerMap("2"));
            setNetworklanlist(DataSourceDataProvider.getInstance().getNetworkVanList());
            setDocdatepicker(DateUtility.getInstance().getCurrentMySqlDateTime1());
            if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_DOCREPORT_LIST) != null) {
                httpServletRequest.getSession(false).removeAttribute(AppConstants.SES_DOCREPORT_LIST);
            }
            resultType = SUCCESS;
            setResultType(SUCCESS);
        }
        return getResultType();
    }

    public String trackInOutSearch() {
        setResultType(LOGIN);
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            try {
                documentList = ServiceLocator.getTrackInOutService().getDocumentList(this);
                if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_DOCREPORT_LIST) != null) {
                    httpServletRequest.getSession(false).removeAttribute(AppConstants.SES_DOCREPORT_LIST);
                }
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_DOCREPORT_LIST, documentList);
                resultType = SUCCESS;
                setResultType(SUCCESS);
            } catch (Exception exception) {
                setResultType(ERROR);
            }
        }
        return getResultType();
    }

    public String trackSummarySearch() {
        setResultType(LOGIN);
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            try {
                setNetworklanlist(DataSourceDataProvider.getInstance().getNetworkVanList());
                documentList = ServiceLocator.getTrackInOutService().getSummaryDetails(this);
                if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_DOCREPORT_LIST) != null) {
                    httpServletRequest.getSession(false).removeAttribute(AppConstants.SES_DOCREPORT_LIST);
                }
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_DOCREPORT_LIST, documentList);
                resultType = SUCCESS;
                setResultType(SUCCESS);
            } catch (Exception exception) {
                setResultType(ERROR);
            }
        }
        return getResultType();
    }

    public String trackInquirySearch() {
        setResultType(LOGIN);
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            try {
                List docList;
                docList = DataSourceDataProvider.getInstance().getDocumentTypeList("M");
                setDocTypeList(docList);
                setPartnerMap(DataSourceDataProvider.getInstance().getDashboardPartnerMap("2"));
                documentList = ServiceLocator.getTrackInOutService().getInquiryDetails(this);
                if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_DOCREPORT_LIST) != null) {
                    httpServletRequest.getSession(false).removeAttribute(AppConstants.SES_DOCREPORT_LIST);
                }
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_DOCREPORT_LIST, documentList);
                resultType = SUCCESS;
                setResultType(SUCCESS);
            } catch (Exception exception) {
                setResultType(ERROR);
            }
        }
        return getResultType();
    }

    @Override
    public void setServletRequest(HttpServletRequest httpServletRequest) {
        this.httpServletRequest = httpServletRequest;
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
     * @return the partnerMap
     */
    public Map getPartnerMap() {
        return partnerMap;
    }

    /**
     * @param partnerMap the partnerMap to set
     */
    public void setPartnerMap(Map partnerMap) {
        this.partnerMap = partnerMap;
    }

    public String getDocdatepicker() {
        return docdatepicker;
    }

    public void setDocdatepicker(String docdatepicker) {
        this.docdatepicker = docdatepicker;
    }

    public String getDocdatepickerfrom() {
        return docdatepickerfrom;
    }

    public void setDocdatepickerfrom(String docdatepickerfrom) {
        this.docdatepickerfrom = docdatepickerfrom;
    }

    public List getDocTypeList() {
        return docTypeList;
    }

    public void setDocTypeList(List docTypeList) {
        this.docTypeList = docTypeList;
    }

    public List<TrackInOutBean> getDocumentList() {
        return documentList;
    }

    public void setDocumentList(List<TrackInOutBean> documentList) {
        this.documentList = documentList;
    }

    public String getDocType() {
        return docType;
    }

    public void setDocType(String docType) {
        this.docType = docType;
    }

    public String getPartnerMapId() {
        return partnerMapId;
    }

    public void setPartnerMapId(String partnerMapId) {
        this.partnerMapId = partnerMapId;
    }

    public String getDocNetworkvan() {
        return docNetworkvan;
    }

    public void setDocNetworkvan(String docNetworkvan) {
        this.docNetworkvan = docNetworkvan;
    }

    public List getNetworklanlist() {
        return networklanlist;
    }

    public void setNetworklanlist(List networklanlist) {
        this.networklanlist = networklanlist;
    }
}
