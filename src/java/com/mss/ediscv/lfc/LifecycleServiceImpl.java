/**
 * 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.lfc;

import com.mss.ediscv.util.AppConstants;
import com.mss.ediscv.util.LifecycleUtility;
import com.mss.ediscv.util.ServiceLocatorException;
import java.sql.*;
import java.util.ArrayList;
import org.apache.log4j.Logger;
import javax.servlet.http.HttpServletRequest;

public class LifecycleServiceImpl implements LifecycleService {

    Connection connection = null;
    Statement statement = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;
    CallableStatement callableStatement = null;
    private LifecycleBeans lifecycleBeans;
    private ArrayList<PoLifecycleBean> poLifecycleBeanList;
    private ArrayList<AsnLifecycleBean> asnLifecycleBeanList;
    private ArrayList<InvoiceLifecycleBean> invoiceLifecycleBeanList;
    private ArrayList<PaymentLifecycleBean> PaymentLifecycleBeanList;
    private static Logger logger = Logger.getLogger(com.mss.ediscv.shipment.ShipmentServiceImpl.class.getName());

    //@Override
    public void buildLifeCycleBeans(LifecycleAction lifecycleAction, HttpServletRequest httpServletRequest) throws ServiceLocatorException {
        lifecycleBeans = new LifecycleBeans();
        String Ponum = lifecycleAction.getPoNumber();
        LifecycleUtility lifecycleUtility = new LifecycleUtility();
        poLifecycleBeanList = lifecycleUtility.addPoLifeCycleBean(Ponum);
        httpServletRequest.getSession(false).setAttribute(AppConstants.LFC_SES_PO_LIST, poLifecycleBeanList);
        /** ASN process**/
        asnLifecycleBeanList = lifecycleUtility.addAsnLifecycleBean(Ponum);
        httpServletRequest.getSession(false).setAttribute(AppConstants.LFC_SES_ASN_LIST, asnLifecycleBeanList);
        /** INVOICE **/
        invoiceLifecycleBeanList = lifecycleUtility.addInvoiceLifecycleBean(Ponum);
        httpServletRequest.getSession(false).setAttribute(AppConstants.LFC_SES_INVOICE_LIST, invoiceLifecycleBeanList);
        /** PAYMENT **/
        PaymentLifecycleBeanList = lifecycleUtility.addPaymentLifecycleBean(Ponum);
        httpServletRequest.getSession(false).setAttribute(AppConstants.LFC_SES_PAYMENT_LIST, PaymentLifecycleBeanList);
    }
}
