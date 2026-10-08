<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Security: Only allow sellers
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("seller")) {
        response.sendRedirect("index.jsp"); return;
    }
    String userPhone = (String) session.getAttribute("userPhone");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Listed Products - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="fw-bold mb-0">My Listed Products</h3>
            <a href="add-product.jsp" class="btn btn-success"><i class="fas fa-plus me-1"></i> Add Another</a>
        </div>
        
        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Product Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Stock</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasProducts = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM products WHERE seller_phone = ? ORDER BY created_at DESC");
                            pstmt.setString(1, userPhone);
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasProducts = true;
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-dark"><i class="fas fa-box text-primary me-2"></i> <%= rs.getString("product_name") %></td>
                                    <td class="text-muted small" style="max-width: 300px;"><%= rs.getString("description") %></td>
                                    <td class="text-success fw-bold">₹<%= rs.getString("price") %></td>
                                    <td><span class="badge bg-secondary"><%= rs.getInt("stock_quantity") %> in stock</span></td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4' class='text-danger text-center py-4'>Error loading products: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasProducts) {
                            out.println("<tr><td colspan='4' class='text-center py-5 text-muted'><i class='fas fa-box-open mb-3' style='font-size: 3rem; opacity: 0.3;'></i><br>You haven't listed any products yet.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
