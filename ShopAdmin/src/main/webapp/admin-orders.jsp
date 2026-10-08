<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("admin")) {
        response.sendRedirect("index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Platform Transactions - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        <h3 class="fw-bold mb-4"><i class="fas fa-chart-line text-warning me-2"></i>Platform Transactions</h3>
        
        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Transaction ID</th>
                        <th>Buyer Phone</th>
                        <th>Seller Phone</th>
                        <th>Product Sold</th>
                        <th>Price</th>
                        <th>Date</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasOrders = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM orders ORDER BY order_date DESC");
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasOrders = true;
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">
                                        <% if (rs.getString("transaction_id") != null) { %>
                                            #<%= rs.getString("transaction_id") %>
                                        <% } else { %>
                                            #ORD-<%= rs.getInt("order_id") %>
                                        <% } %>
                                    </td>
                                    <td class="text-primary fw-bold"><%= rs.getString("buyer_phone") %></td>
                                    <td class="text-success fw-bold"><%= rs.getString("seller_phone") %></td>
                                    <td class="fw-bold text-dark"><%= rs.getString("product_name") %></td>
                                    <td class="text-success fw-bold">₹<%= rs.getString("price") %></td>
                                    <td class="text-muted small"><%= rs.getTimestamp("order_date") %></td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger text-center py-4'>Error loading transactions: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasOrders) {
                            out.println("<tr><td colspan='6' class='text-center py-5 text-muted'>No orders have been placed on the platform yet.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
