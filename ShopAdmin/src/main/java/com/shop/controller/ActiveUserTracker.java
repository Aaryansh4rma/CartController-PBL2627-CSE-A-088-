package com.shop.controller;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.HashSet;
import java.util.Set;

@WebListener
public class ActiveUserTracker implements HttpSessionListener {
    private static final Set<String> activeUsers = new HashSet<>();

    public static Set<String> getActiveUsers() {
        return activeUsers;
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Session created upon initial visit/connection
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        String user = (String) se.getSession().getAttribute("userPhone");
        if (user != null) {
            activeUsers.remove(user);
        }
    }
}
