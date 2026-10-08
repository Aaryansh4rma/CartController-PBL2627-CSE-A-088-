<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("buyer")) {
        response.sendRedirect("index.jsp"); return;
    }
    String buyerPhone = (String) session.getAttribute("userPhone");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        <h3 class="fw-bold mb-4">My Orders</h3>
        
        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Order ID / Ref</th>
                        <th>Product Name</th>
                        <th>Price Paid</th>
                        <th>Order Date</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasOrders = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM orders WHERE buyer_phone = ? ORDER BY order_date DESC");
                            pstmt.setString(1, buyerPhone);
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasOrders = true;
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-primary">#<%= rs.getString("transaction_id") %></td>
                                    <td class="fw-bold text-dark"><i class="fas fa-box text-secondary me-2"></i> <%= rs.getString("product_name") %></td>
                                    <td class="text-success fw-bold">₹<%= rs.getString("price") %></td>
                                    <td class="text-muted small"><%= rs.getTimestamp("order_date") %></td>
                                    <td class="text-end pe-4">
                                        <form action="BuyerActionServlet" method="POST" style="margin: 0;">
                                            <input type="hidden" name="action" value="remove_order">
                                            <input type="hidden" name="order_id" value="<%= rs.getInt("order_id") %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm"><i class="fas fa-trash-alt me-1"></i> Remove</button>
                                        </form>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-danger text-center py-4'>Error loading orders: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasOrders) {
                            out.println("<tr><td colspan='5' class='text-center py-5 text-muted'><i class='fas fa-box-open mb-3' style='font-size: 3rem; opacity: 0.3;'></i><br>You haven't placed any orders yet.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
