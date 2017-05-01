/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.inv;

import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.DataSourceDataProvider;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocator;
import com.opensymphony.xwork2.ActionSupport;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletRequestAware;

/**
 * @author miracle
 */
public class InvoiceAction extends ActionSupport implements ServletRequestAware {

    private HttpServletRequest httpServletRequest;
    private String sqlQuery;
    private String invSearchQuery;
    private String submitFrm;
    private String resultType;
    private String currentDsnName;
    private String invdatepicker;
    private String invdatepickerfrom;
    private String invSenderId;
    private String invSenderName;
    private String invBusId;
    private String invRecName;
    private String invPoNum;
    private String invNum;
    private String sampleValue;
    private List<InvoiceBean> invoiceList;
    private String check;
    private String ackStatus;
    private String status;
    private String corrattribute;
    private String corrattribute1;
    private String corrattribute2;
    private String corrvalue;
    private String corrvalue1;
    private String corrvalue2;
    private List correlationList;
    private List docTypeList;
    private String docType;
    private List senderIdList;
    private List receiverIdList;
    private List senderNameList;
    private List receiverNameList;
    private String reportrange;

    public String getReportrange() {
        return reportrange;
    }

    public void setReportrange(String reportrange) {
        this.reportrange = reportrange;
    }
    private static Logger logger = Logger.getLogger(InvoiceAction.class.getName());

    public String prepare() throws Exception {
        resultType = LOGIN;
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            HttpSession httpSession = httpServletRequest.getSession(false);
            try {
                httpSession.removeAttribute(AppConstants.SES_PAYMENT_LIST);
                httpSession.removeAttribute(AppConstants.SES_SHIPMENT_LIST);
                httpSession.removeAttribute(AppConstants.SES_DOC_LIST);
                httpSession.removeAttribute(AppConstants.SES_PO_LIST);
                if (getSubmitFrm() != null && (!getSubmitFrm().equals("frmDBGrid"))) {
                    if (httpSession.getAttribute(AppConstants.SES_INV_QUERY) != null) {
                        httpSession.removeAttribute(AppConstants.SES_INV_QUERY);
                    }
                } else if (getSubmitFrm() == null && httpSession.getAttribute(AppConstants.SES_INV_QUERY) != null) {
                    httpSession.removeAttribute(AppConstants.SES_INV_QUERY);
                }
                List senderList;
                List receiverList;
                List senderNameList;
                List receiverNameList;
                setCorrelationList(DataSourceDataProvider.getInstance().getCorrelationNames(3, 1));
                //setDocTypeList(DataSourceDataProvider.getInstance().getDocumentTypeList());
                senderList = DataSourceDataProvider.getInstance().getSenderIdlist("M");
                receiverList = DataSourceDataProvider.getInstance().getReciverIdlist("M");
                senderNameList = DataSourceDataProvider.getInstance().getSenderNamelist("M");
                receiverNameList = DataSourceDataProvider.getInstance().getReciverNamelist("M");
                setSenderIdList(senderList);
                setReceiverIdList(receiverList);
                setSenderNameList(senderNameList);
                setReceiverNameList(receiverNameList);
                //setInvdatepicker(DateUtility.getInstance().getCurrentMySqlDateTime1());
                resultType = SUCCESS;
            } catch (Exception ex) {
                httpServletRequest.getSession(false).setAttribute(AppConstants.REQ_EXCEPTION_MSG, ex.getMessage());
                resultType = "error";
            }
        }
        return resultType;
    }

    public String getInvoiceSearchQuery() throws Exception {
        resultType = LOGIN;
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            try {
                prepare();
                if (getCheck() == null) {
                    setCheck("1");
                } else if (getCheck().equals("")) {
                    setCheck("1");
                }
                invoiceList = ServiceLocator.getInvoiceService().buildinvoiceQuery(this);
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_INV_LIST, invoiceList);
                resultType = SUCCESS;
            } catch (Exception ex) {
                httpServletRequest.getSession(false).setAttribute(AppConstants.REQ_EXCEPTION_MSG, ex.getMessage());
                resultType = "error";
            }
        }
        return resultType;
    }

    // @Override
    public void setServletRequest(HttpServletRequest reqObj) {
        this.setHttpServletRequest(reqObj);
    }

    /**
     * @param reqObj
     */
    public void setHttpServletRequest(HttpServletRequest httpServletRequest) {
        this.httpServletRequest = httpServletRequest;
    }

    public void setSqlQuery(String sqlQuery) {
        this.sqlQuery = sqlQuery;
    }

    public String getSqlQuery() {
        return sqlQuery;
    }

    public void setInvSearchQuery(String invSearchQuery) {
        this.invSearchQuery = invSearchQuery;
    }

    public String getInvSearchQuery() {
        return invSearchQuery;
    }

    public void setSubmitFrm(String submitFrm) {
        this.submitFrm = submitFrm;
    }

    public String getSubmitFrm() {
        return submitFrm;
    }

    public void setResultType(String resultType) {
        this.resultType = resultType;
    }

    public String getResultType() {
        return resultType;
    }

    public void setCurrentDsnName(String currentDsnName) {
        this.currentDsnName = currentDsnName;
    }

    public String getCurrentDsnName() {
        return currentDsnName;
    }

    /**
     * @return the poNum
     */
    /**
     * @return the invNum
     */
    public String getInvNum() {
        return invNum;
    }

    /**
     * @param invNum the invNum to set
     */
    public void setInvNum(String invNum) {
        this.invNum = invNum;
    }

    /**
     * @return the invdatepicker
     */
    public String getInvdatepicker() {
        return invdatepicker;
    }

    /**
     * @param invdatepicker the invdatepicker to set
     */
    public void setInvdatepicker(String invdatepicker) {
        this.invdatepicker = invdatepicker;
    }

    /**
     * @return the invdatepickerfrom
     */
    public String getInvdatepickerfrom() {
        return invdatepickerfrom;
    }

    /**
     * @param invdatepickerfrom the invdatepickerfrom to set
     */
    public void setInvdatepickerfrom(String invdatepickerfrom) {
        this.invdatepickerfrom = invdatepickerfrom;
    }

    /**
     * @return the invSenderId
     */
    public String getInvSenderId() {
        return invSenderId;
    }

    /**
     * @param invSenderId the invSenderId to set
     */
    public void setInvSenderId(String invSenderId) {
        this.invSenderId = invSenderId;
    }

    /**
     * @return the invSenderName
     */
    public String getInvSenderName() {
        return invSenderName;
    }

    /**
     * @param invSenderName the invSenderName to set
     */
    public void setInvSenderName(String invSenderName) {
        this.invSenderName = invSenderName;
    }

    /**
     * @return the invBusId
     */
    public String getInvBusId() {
        return invBusId;
    }

    /**
     * @param invBusId the invBusId to set
     */
    public void setInvBusId(String invBusId) {
        this.invBusId = invBusId;
    }

    /**
     * @return the invRecName
     */
    public String getInvRecName() {
        return invRecName;
    }

    /**
     * @param invRecName the invRecName to set
     */
    public void setInvRecName(String invRecName) {
        this.invRecName = invRecName;
    }

    /**
     * @return the invPoNum
     */
    public String getInvPoNum() {
        return invPoNum;
    }

    /**
     * @param invPoNum the invPoNum to set
     */
    public void setInvPoNum(String invPoNum) {
        this.invPoNum = invPoNum;
    }

    /**
     * @return the sampleValue
     */
    public String getSampleValue() {
        return sampleValue;
    }

    /**
     * @param sampleValue the sampleValue to set
     */
    public void setSampleValue(String sampleValue) {
        this.sampleValue = sampleValue;
    }

    /**
     * @return the check
     */
    public String getCheck() {
        return check;
    }

    /**
     * @param check the check to set
     */
    public void setCheck(String check) {
        this.check = check;
    }

    /**
     * @return the ackStatus
     */
    public String getAckStatus() {
        return ackStatus;
    }

    /**
     * @param ackStatus the ackStatus to set
     */
    public void setAckStatus(String ackStatus) {
        this.ackStatus = ackStatus;
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
     * @return the corrattribute
     */
    public String getCorrattribute() {
        return corrattribute;
    }

    /**
     * @param corrattribute the corrattribute to set
     */
    public void setCorrattribute(String corrattribute) {
        this.corrattribute = corrattribute;
    }

    /**
     * @return the corrvalue
     */
    public String getCorrvalue() {
        return corrvalue;
    }

    /**
     * @param corrvalue the corrvalue to set
     */
    public void setCorrvalue(String corrvalue) {
        this.corrvalue = corrvalue;
    }

    /**
     * @return the correlationList
     */
    public List getCorrelationList() {
        return correlationList;
    }

    /**
     * @param correlationList the correlationList to set
     */
    public void setCorrelationList(List correlationList) {
        this.correlationList = correlationList;
    }

    /**
     * @return the docType
     */
    public String getDocType() {
        return docType;
    }

    /**
     * @param docType the docType to set
     */
    public void setDocType(String docType) {
        this.docType = docType;
    }

    /**
     * @return the docTypeList
     */
    public List getDocTypeList() {
        return docTypeList;
    }

    /**
     * @param docTypeList the docTypeList to set
     */
    public void setDocTypeList(List docTypeList) {
        this.docTypeList = docTypeList;
    }

    public List getReceiverIdList() {
        return receiverIdList;
    }

    public void setReceiverIdList(List receiverIdList) {
        this.receiverIdList = receiverIdList;
    }

    public List getReceiverNameList() {
        return receiverNameList;
    }

    public void setReceiverNameList(List receiverNameList) {
        this.receiverNameList = receiverNameList;
    }

    public List getSenderIdList() {
        return senderIdList;
    }

    public void setSenderIdList(List senderIdList) {
        this.senderIdList = senderIdList;
    }

    public List getSenderNameList() {
        return senderNameList;
    }

    public void setSenderNameList(List senderNameList) {
        this.senderNameList = senderNameList;
    }

    public String getCorrattribute1() {
        return corrattribute1;
    }

    public void setCorrattribute1(String corrattribute1) {
        this.corrattribute1 = corrattribute1;
    }

    public String getCorrattribute2() {
        return corrattribute2;
    }

    public void setCorrattribute2(String corrattribute2) {
        this.corrattribute2 = corrattribute2;
    }

    public String getCorrvalue1() {
        return corrvalue1;
    }

    public void setCorrvalue1(String corrvalue1) {
        this.corrvalue1 = corrvalue1;
    }

    public String getCorrvalue2() {
        return corrvalue2;
    }

    public void setCorrvalue2(String corrvalue2) {
        this.corrvalue2 = corrvalue2;
    }
    /**
     * @return the invAmt
     */
}
