package com.shop.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CustomerRegisterServlet")
public class CustomerRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // Foolproof check: Look for "full_name" first, if null, look for "name"
        String fullName = request.getParameter("full_name");
        if (fullName == null || fullName.trim().isEmpty()) {
            fullName = request.getParameter("name");
        }
        
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String address = request.getParameter("address");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
            
            String sql = "INSERT INTO users (full_name, phone, password, role, address) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, fullName); // Now guaranteed to not be null
            pstmt.setString(2, phone);
            pstmt.setString(3, password);
            pstmt.setString(4, role);
            pstmt.setString(5, address);
            
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            
            response.sendRedirect("index.jsp?registered=true");
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<html><body class='p-5'>");
            out.println("<h3 class='text-danger'>Database Error: " + e.getMessage() + "</h3>");
            out.println("<a href='register.jsp'>Go Back</a>");
            out.println("</body></html>");
        }
    }
}
