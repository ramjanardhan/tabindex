/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mss.ediscv.Interceptor;

import com.mss.ediscv.util.PasswordUtil;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.Interceptor;
import javax.servlet.http.Cookie;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author miracle-pc
 */
public class MyInterceptor implements Interceptor {

    @Override
    public void destroy() {
        //throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public void init() {
        // throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public String intercept(ActionInvocation ai) throws Exception {
        PasswordUtil passwordUtil = new PasswordUtil();
        ActionContext context = ai.getInvocationContext();
        HttpServletRequest request;
        HttpServletResponse response;
        request = (HttpServletRequest) context.get("com.opensymphony.xwork2.dispatcher.HttpServletRequest");
        response = (HttpServletResponse) context.get("com.opensymphony.xwork2.dispatcher.HttpServletResponse");
        String str = request.getParameter("checkboxvalue");
        System.out.println("------------------------>checkbox value is "+str);
        if (str.equals("1")) {
            String uname = request.getParameter("loginId");
            String password = passwordUtil.encryptPwd(request.getParameter("password"));
            Cookie c = new Cookie(uname, password);
            c.setMaxAge(60 * 60 * 24);
            response.addCookie(c);
            if (c != null) {
                System.out.println("<h2> Found Cookies Name and Value</h2>");

            } else {
                System.out.println("<h2>No cookies founds</h2>");
            }
        }
        return ai.invoke();
    }
}
