package com.shop.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED" ;
    private static final String DB_USER = "avnadmin";
    private static final String DB_PASSWORD = "AVNS_xR7SkvA7I7J0psqdtnC"; 

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String requestedRole = request.getParameter("role"); // The portal they are trying to log into

        boolean isValid = false;
        String fullName = "";
        String userAddress = "";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            
            // Query checking ONLY phone and password
            String sql = "SELECT full_name, address, role FROM users WHERE phone = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, phone);
            pstmt.setString(2, password);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String dbRole = rs.getString("role"); // The role they originally registered with
                
                // Security Check: Prevent normal buyers/sellers from logging into the Admin portal
                if (requestedRole.equals("admin") && !dbRole.equals("admin")) {
                    isValid = false;
                } else {
                    isValid = true;
                    fullName = rs.getString("full_name");
                    userAddress = rs.getString("address");
                }
            }
            
            rs.close();
            pstmt.close();
            conn.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 class='text-danger text-center mt-5'>Database Error: " + e.getMessage() + "</h3>");
            return;
        }

        if (isValid) {
            HttpSession session = request.getSession();
            session.setAttribute("userFullName", fullName);
            session.setAttribute("userPhone", phone);
            session.setAttribute("userAddress", userAddress);
            
            // Set their session role to the portal they just logged into (Buyer or Seller)
            session.setAttribute("userRole", requestedRole);
            
            // Track the active user
            ActiveUserTracker.getActiveUsers().add(phone);

            // Route directly to the dashboard
            response.sendRedirect("dashboard.jsp");
        } else {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Login Failed</title>");
            out.println("<link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'></head>");
            out.println("<body class='bg-light d-flex align-items-center justify-content-center vh-100'>");
            out.println("<div class='card shadow p-4 text-center' style='max-width: 400px; width: 100%; border-radius: 12px;'>");
            out.println("<h3 class='text-danger mb-3'>Login Failed</h3>");
            out.println("<p class='text-muted'>Invalid credentials or unauthorized access.</p>");
            out.println("<a href='index.jsp' class='btn btn-dark mt-3'>Try Again</a>");
            out.println("</div></body></html>");
        }
    }
}
