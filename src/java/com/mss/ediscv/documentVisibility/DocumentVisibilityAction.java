/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.documentVisibility;

import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.DataSourceDataProvider;
import com.mss.ediscv.util.DateUtility;
import com.mss.ediscv.util.ServiceLocator;
import com.opensymphony.xwork2.ActionSupport;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.log4j.Logger;

/**
 * @author miracle
 */
public class DocumentVisibilityAction extends ActionSupport implements ServletRequestAware {

    private HttpServletRequest httpServletRequest;
    private String resultType;
    private String sqlQuery;
    private String docSearchQuery;
    private List<DocumentVisibilityBean> documentList;
    private List pageList;
    private int startValue;
    private int endValue;
    private String docdatepicker;
    private String docdatepickerfrom;
    private String docSenderId;
    private String status;
    private String docReceiverId;
    private String ackStatus;
    private static Logger logger = Logger.getLogger(DocumentVisibilityAction.class.getName());

    public String execute() throws Exception {
        setResultType(LOGIN);
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            httpServletRequest.getSession(false).removeAttribute("searchResult");
            httpServletRequest.getSession(false).removeAttribute("searchString");
            httpServletRequest.getSession(false).removeAttribute("gridSize");
            httpServletRequest.getSession(false).removeAttribute("noOfPages");
            String defaultFlowId = httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_DEFAULT_FLOWID).toString();
            String defaultFlowName = DataSourceDataProvider.getInstance().getFlowNameByFlowID(defaultFlowId);
            setDocdatepicker(DateUtility.getInstance().getCurrentMySqlDateTime1());
            if (!defaultFlowName.equals("DocumentVisibility")) {
                defaultFlowId = DataSourceDataProvider.getInstance().getFlowIdByFlowName("DocumentVisibility");
                httpServletRequest.getSession(false).setAttribute(AppConstants.SES_USER_DEFAULT_FLOWID, defaultFlowId);
            }
            setResultType(SUCCESS);
        }
        return getResultType();
    }

    /*
     * For Resume grid applying
     */
    public String doDocRepositorySearch() {
        String searchString;
        int gridSize;
        int strStartGrid = 0;
        int strEndGrid = 0;
        setResultType(LOGIN);
        String queryString = "";
        if (httpServletRequest.getSession(false).getAttribute(AppConstants.SES_USER_NAME) != null) {
            try {
                execute();
                HttpSession session = httpServletRequest.getSession(true);
                session.removeAttribute("searchResult");
                session.removeAttribute("searchString");
                session.removeAttribute("gridSize");
                session.removeAttribute("noOfPages");
                List searchResult = null;
                searchResult = ServiceLocator.getDocumentVisibilityService().buildDocumentQuery(this, httpServletRequest);
                session.setAttribute("searchResult", searchResult);
                if (searchResult.size() > 0) {
                    gridSize = searchResult.size();
                    session.setAttribute("gridSize", gridSize);
                    List currentPageList = new ArrayList();
                    if (searchResult.size() < 30) {
                        strStartGrid = 0;
                        httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                        strEndGrid = searchResult.size();
                        httpServletRequest.setAttribute("strEndGrid", strEndGrid);
                    } else {
                        strStartGrid = 0;
                        httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                        strEndGrid = 30;
                        httpServletRequest.setAttribute("strEndGrid", strEndGrid);
                    }
                    int noOfPages = 0;
                    if (searchResult.size() % 30 == 0) {
                        noOfPages = searchResult.size() / 30;
                    } else {
                        noOfPages = (searchResult.size() / 30) + 1;
                    }
                    session.setAttribute("noOfPages", noOfPages);
                    for (int i = 1; i <= noOfPages; i++) {
                        currentPageList.add(i);
                    }
                    setPageList(currentPageList);
                    resultType = SUCCESS;
                } else {
                    strStartGrid = 0;
                    httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                    strEndGrid = 0;
                    httpServletRequest.setAttribute("strEndGrid", strEndGrid);
                    resultType = SUCCESS;
                }
            } catch (Exception ex) {
                httpServletRequest.getSession(false).setAttribute("errorMessage", ex.toString());
                resultType = ERROR;
            }
        }
        return resultType;
    }

    public String doNextDocRepository() {
        int strStartGrid = 0;
        int strEndGrid = 0;
        int pageSize = 0;
        int gridSplit = 0;
        try {
            int gettxtStartGrid = Integer.parseInt(httpServletRequest.getParameter("startValue"));
            int gettxtEndGrid = Integer.parseInt(httpServletRequest.getParameter("endValue"));
            String buttonValue = httpServletRequest.getParameter("button");
            HttpSession session = httpServletRequest.getSession(true);
            String gridSize = session.getAttribute("gridSize").toString();
            int gridLength = Integer.parseInt(gridSize);
            List searchResult = (List) session.getAttribute("searchResult");
            if (buttonValue.equalsIgnoreCase("Next")) {
                if (gridLength != gettxtEndGrid) {
                    gridSplit = gettxtEndGrid;
                    gridSplit = gridLength - gridSplit;
                    if (gridSplit >= 30) {
                        strStartGrid = gettxtStartGrid + 30;
                        strEndGrid = gettxtEndGrid + 30;
                    } else {
                        strStartGrid = gettxtStartGrid + 30;
                        strEndGrid = gettxtEndGrid + gridSplit;
                    }
                } else {
                    strStartGrid = 0;
                    strEndGrid = 0;
                }
                httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                httpServletRequest.setAttribute("strEndGrid", strEndGrid);
            }
            if (buttonValue.equalsIgnoreCase("Previous")) {
                gridSplit = gettxtStartGrid;
                gridSplit = gridLength - gridSplit;
                if (gridSplit > 0) {
                    strStartGrid = gettxtStartGrid - 30;
                    strEndGrid = strStartGrid + 30;
                }
                httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                httpServletRequest.setAttribute("strEndGrid", strEndGrid);
            }
            if (buttonValue.equalsIgnoreCase("First")) {
                strStartGrid = 0;
                strEndGrid = strStartGrid + 30;
                httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                httpServletRequest.setAttribute("strEndGrid", strEndGrid);
            }
            if (buttonValue.equalsIgnoreCase("Last")) {
                int pageNum = gridLength / 30;
                strStartGrid = (pageNum * 30);
                strEndGrid = gridLength;
                httpServletRequest.setAttribute("strStartGrid", strStartGrid);
                httpServletRequest.setAttribute("strEndGrid", strEndGrid);
            }
            if (buttonValue.equalsIgnoreCase("Select")) {
                httpServletRequest.setAttribute("strStartGrid", getStartValue());
                if (searchResult.size() > getEndValue()) {
                    httpServletRequest.setAttribute("strEndGrid", getEndValue());
                } else {
                    httpServletRequest.setAttribute("strEndGrid", searchResult.size());
                }
            }
            List currentPageList = new ArrayList();
            int noOfPages = 0;
            if (searchResult.size() % 30 == 0) {
                noOfPages = searchResult.size() / 30;
            } else {
                noOfPages = (searchResult.size() / 30) + 1;
            }
            session.setAttribute("noOfPages", noOfPages);
            for (int i = 1; i <= noOfPages; i++) {
                currentPageList.add(i);
            }
            setPageList(currentPageList);
        } catch (Exception ex) {
            httpServletRequest.getSession(false).setAttribute("errorMessage", ex.toString());
            resultType = ERROR;
        }
        return "success";
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
     * @return the documentList
     */
    public List<DocumentVisibilityBean> getDocumentList() {
        return documentList;
    }

    /**
     * @param documentList the documentList to set
     */
    public void setDocumentList(List<DocumentVisibilityBean> documentList) {
        this.documentList = documentList;
    }

    /**
     * @return the pageList
     */
    public List getPageList() {
        return pageList;
    }

    /**
     * @param pageList the pageList to set
     */
    public void setPageList(List pageList) {
        this.pageList = pageList;
    }

    /**
     * @return the startValue
     */
    public int getStartValue() {
        return startValue;
    }

    /**
     * @param startValue the startValue to set
     */
    public void setStartValue(int startValue) {
        this.startValue = startValue;
    }

    /**
     * @return the endValue
     */
    public int getEndValue() {
        return endValue;
    }

    /**
     * @param endValue the endValue to set
     */
    public void setEndValue(int endValue) {
        this.endValue = endValue;
    }

    /**
     * @return the docdatepicker
     */
    public String getDocdatepicker() {
        return docdatepicker;
    }

    /**
     * @param docdatepicker the docdatepicker to set
     */
    public void setDocdatepicker(String docdatepicker) {
        this.docdatepicker = docdatepicker;
    }

    /**
     * @return the docdatepickerfrom
     */
    public String getDocdatepickerfrom() {
        return docdatepickerfrom;
    }

    /**
     * @param docdatepickerfrom the docdatepickerfrom to set
     */
    public void setDocdatepickerfrom(String docdatepickerfrom) {
        this.docdatepickerfrom = docdatepickerfrom;
    }

    /**
     * @return the docSenderId
     */
    public String getDocSenderId() {
        return docSenderId;
    }

    /**
     * @param docSenderId the docSenderId to set
     */
    public void setDocSenderId(String docSenderId) {
        this.docSenderId = docSenderId;
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
     * @return the docReceiverId
     */
    public String getDocReceiverId() {
        return docReceiverId;
    }

    /**
     * @param docReceiverId the docReceiverId to set
     */
    public void setDocReceiverId(String docReceiverId) {
        this.docReceiverId = docReceiverId;
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
}
