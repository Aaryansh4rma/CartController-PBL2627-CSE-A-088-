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
import javax.servlet.http.HttpSession;

@WebServlet("/AddProductServlet")
public class AddProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        String sellerPhone = (String) session.getAttribute("userPhone");
        
        if (sellerPhone == null) {
            out.println("<h3 class='text-danger'>Session expired. Please log in again.</h3>");
            return;
        }

        String productName = request.getParameter("product_name");
        String description = request.getParameter("description");
        
        try {
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQuantity = Integer.parseInt(request.getParameter("stock_quantity"));

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
            
            String sql = "INSERT INTO products (seller_phone, product_name, description, price, stock_quantity) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, sellerPhone);
            pstmt.setString(2, productName);
            pstmt.setString(3, description);
            pstmt.setDouble(4, price);
            pstmt.setInt(5, stockQuantity);
            
            int rows = pstmt.executeUpdate();
            
            pstmt.close();
            conn.close();
            
            if (rows > 0) {
                out.println("<html><head><link href='https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css' rel='stylesheet'></head>");
                out.println("<body class='p-5 text-center'>") ;
                out.println("<h2 class='text-success mb-3'>Product Added Successfully!</h2>");
                out.println("<a href='dashboard.jsp' class='btn btn-primary'>Back to Dashboard</a>");
                out.println("</body></html>");
            } else {
                out.println("<h3 class='text-danger'>Failed to save product. No rows affected.</h3>");
            }
            
        } catch (Exception e) {
            out.println("<html><body class='p-5'>");
            out.println("<h3 class='text-danger'>Database or Server Error:</h3>");
            out.println("<p><b>Error Details:</b> " + e.getMessage() + "</p>");
            out.println("<a href='add-product.jsp'>Go Back</a>");
            out.println("</body></html>");
            e.printStackTrace();
        }
    }
}
