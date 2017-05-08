/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.purge;

import com.mss.ediscv.util.ServiceLocatorException;
import java.util.List;

/**
 * @author miracle
 */
public interface PurgeService {

    /**
     *
     * @param purgeAction
     * @param username
     * @return
     * @throws ServiceLocatorException
     */
    public String purgeProcess(PurgeAction purgeAction, String username) throws ServiceLocatorException;
    public String archiveProcess(PurgeAction purgeAction, String username) throws ServiceLocatorException;
    public List getPurHistoryData(String username, String from , String to, String tansType) throws ServiceLocatorException;
    public List getArcHistoryData(String username, String from , String to, String tansType) throws ServiceLocatorException;
}
