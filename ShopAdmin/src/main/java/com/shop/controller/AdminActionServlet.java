package com.shop.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AdminActionServlet")
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String adminRole = (String) session.getAttribute("userRole");
        
        // Security check: Only allow Admin access
        if (adminRole == null || !adminRole.equals("admin")) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");

            if ("remove_user".equals(action)) {
                String targetPhone = request.getParameter("target_phone");
                
                // Delete the user from the database using their unique phone number
                String sql = "DELETE FROM users WHERE phone = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, targetPhone);
                pstmt.executeUpdate();
                pstmt.close();

                response.sendRedirect("admin-users.jsp?msg=deleted");
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-users.jsp?msg=error");
        }
    }
}
