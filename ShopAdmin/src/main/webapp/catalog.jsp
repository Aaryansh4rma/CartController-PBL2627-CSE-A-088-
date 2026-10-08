<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("buyer")) {
        response.sendRedirect("index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Store Catalog - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
            <a href="cart.jsp" class="btn btn-warning fw-bold"><i class="fas fa-shopping-cart me-1"></i> View Cart</a>
        </div>
        <h3 class="fw-bold mb-4">Store Catalog</h3>
        
        <% 
            String msg = request.getParameter("msg");
            if ("cart_added".equals(msg)) out.print("<div class='alert alert-success'>Item added to your cart!</div>");
            if ("saved".equals(msg)) out.print("<div class='alert alert-info'>Item added to your wishlist!</div>");
        %>

        <div class="row g-4">
            <% 
                boolean hasProducts = false;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                    PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM products WHERE stock_quantity > 0 ORDER BY created_at DESC");
                    ResultSet rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        hasProducts = true;
            %>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm h-100" style="border-radius: 12px;">
                                <div class="card-body text-center p-4">
                                    <i class="fas fa-shopping-bag text-primary mb-3" style="font-size: 3rem;"></i>
                                    <h5 class="fw-bold"><%= rs.getString("product_name") %></h5>
                                    <p class="text-muted small"><%= rs.getString("description") %></p>
                                    <h4 class="fw-bold text-success mb-4">₹<%= rs.getString("price") %></h4>
                                    
                                    <!-- Add to Cart Form -->
                                    <form action="BuyerActionServlet" method="POST" class="mb-2">
                                        <input type="hidden" name="action" value="add_to_cart">
                                        <input type="hidden" name="product_id" value="<%= rs.getInt("product_id") %>">
                                        <input type="hidden" name="product_name" value="<%= rs.getString("product_name") %>">
                                        <input type="hidden" name="price" value="<%= rs.getString("price") %>">
                                        <input type="hidden" name="seller_phone" value="<%= rs.getString("seller_phone") %>">
                                        <button type="submit" class="btn btn-warning btn-sm w-100 fw-bold"><i class="fas fa-cart-plus me-1"></i> Add to Cart</button>
                                    </form>

                                    <!-- Wishlist Form -->
                                    <form action="BuyerActionServlet" method="POST">
                                        <input type="hidden" name="action" value="wishlist">
                                        <input type="hidden" name="product_id" value="<%= rs.getInt("product_id") %>">
                                        <input type="hidden" name="product_name" value="<%= rs.getString("product_name") %>">
                                        <input type="hidden" name="price" value="<%= rs.getString("price") %>">
                                        <button type="submit" class="btn btn-outline-danger btn-sm w-100"><i class="fas fa-heart"></i> Add to Wishlist</button>
                                    </form>
                                </div>
                            </div>
                        </div>
            <%
                    }
                    rs.close(); pstmt.close(); conn.close();
                } catch (Exception e) {
                    out.println("<p class='text-danger'>Error loading catalog: " + e.getMessage() + "</p>");
                }
                
                if (!hasProducts) {
            %>
                    <div class="col-12">
                        <div class="card border-0 shadow-sm p-5 text-center" style="border-radius: 12px;">
                            <i class="fas fa-store-slash text-muted mb-3" style="font-size: 4rem; opacity: 0.3;"></i>
                            <h4 class="text-muted">Catalog is empty</h4>
                        </div>
                    </div>
            <%  } %>
        </div>
    </div>
</body>
</html>
