<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security check: Only sellers can access this page
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("seller")) {
        response.sendRedirect("index.jsp"); return;
    }
    String userPhone = (String) session.getAttribute("userPhone");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sales & Revenue - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        
        <h3 class="fw-bold mb-4"><i class="fas fa-chart-line text-dark me-2"></i>Sales History</h3>
        
        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Transaction ID</th>
                        <th>Product Sold</th>
                        <th>Buyer Phone</th>
                        <th>Sale Price</th>
                        <th>Date & Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasSales = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM orders WHERE seller_phone = ? ORDER BY order_date DESC");
                            pstmt.setString(1, userPhone);
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasSales = true;
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-muted">
                                        <% if (rs.getString("transaction_id") != null) { %>
                                            #<%= rs.getString("transaction_id") %>
                                        <% } else { %>
                                            #ORD-<%= rs.getInt("order_id") %>
                                        <% } %>
                                    </td>
                                    <td class="fw-bold"><%= rs.getString("product_name") %></td>
                                    <td class="text-primary"><i class="fas fa-user-circle me-1"></i><%= rs.getString("buyer_phone") %></td>
                                    <td class="text-success fw-bold">₹<%= rs.getString("price") %></td>
                                    <td class="text-muted small"><%= rs.getTimestamp("order_date") %></td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-danger text-center py-4'>Error loading sales: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasSales) {
                            out.println("<tr><td colspan='5' class='text-center py-5 text-muted'><i class='fas fa-receipt mb-3' style='font-size: 3rem; opacity: 0.3;'></i><br>No sales recorded yet. Your revenue will appear here once buyers purchase your items.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
