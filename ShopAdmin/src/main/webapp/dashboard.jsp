<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userRole") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    String currentRole = (String) session.getAttribute("userRole");
    String userPhone = (String) session.getAttribute("userPhone");
    String userName = "User";
    
    int sellerProductCount = 0; double totalRevenue = 0.00;
    int buyerOrdersCount = 0; int buyerCartCount = 0; int buyerWishlistCount = 0;
    int totalUsers = 0; int totalProducts = 0; int totalOrders = 0; double platformRevenue = 0.00;
    String buyerProductsHtml = "";
    
    if (userPhone != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
            
            PreparedStatement pstmtName = conn.prepareStatement("SELECT full_name FROM users WHERE phone = ?");
            pstmtName.setString(1, userPhone);
            ResultSet rsName = pstmtName.executeQuery();
            if(rsName.next()) userName = rsName.getString("full_name");
            rsName.close(); pstmtName.close();
            
            if ("admin".equals(currentRole)) {
                PreparedStatement p1 = conn.prepareStatement("SELECT COUNT(*) FROM users");
                ResultSet r1 = p1.executeQuery(); if(r1.next()) totalUsers = r1.getInt(1); r1.close(); p1.close();
                
                PreparedStatement p2 = conn.prepareStatement("SELECT COUNT(*) FROM products");
                ResultSet r2 = p2.executeQuery(); if(r2.next()) totalProducts = r2.getInt(1); r2.close(); p2.close();
                
                PreparedStatement p3 = conn.prepareStatement("SELECT COUNT(*) FROM orders");
                ResultSet r3 = p3.executeQuery(); if(r3.next()) totalOrders = r3.getInt(1); r3.close(); p3.close();
                
                PreparedStatement p4 = conn.prepareStatement("SELECT SUM(price) FROM orders");
                ResultSet r4 = p4.executeQuery(); if(r4.next()) { platformRevenue = r4.getDouble(1); if (r4.wasNull()) platformRevenue = 0.00; } r4.close(); p4.close();
            }
            else if ("seller".equals(currentRole)) {
                PreparedStatement pstmt1 = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE seller_phone = ?");
                pstmt1.setString(1, userPhone);
                ResultSet rs1 = pstmt1.executeQuery(); if(rs1.next()) sellerProductCount = rs1.getInt(1); rs1.close(); pstmt1.close();
                
                PreparedStatement pstmt2 = conn.prepareStatement("SELECT SUM(price) FROM orders WHERE seller_phone = ?");
                pstmt2.setString(1, userPhone);
                ResultSet rs2 = pstmt2.executeQuery(); if(rs2.next()) { totalRevenue = rs2.getDouble(1); if (rs2.wasNull()) totalRevenue = 0.00; } rs2.close(); pstmt2.close();
            } 
            else if ("buyer".equals(currentRole)) {
                PreparedStatement pstmt3 = conn.prepareStatement("SELECT COUNT(*) FROM orders WHERE buyer_phone = ?");
                pstmt3.setString(1, userPhone);
                ResultSet rs3 = pstmt3.executeQuery(); if(rs3.next()) buyerOrdersCount = rs3.getInt(1); rs3.close(); pstmt3.close();
                
                PreparedStatement pstmtCart = conn.prepareStatement("SELECT COUNT(*) FROM cart WHERE buyer_phone = ?");
                pstmtCart.setString(1, userPhone);
                ResultSet rsCart = pstmtCart.executeQuery(); if(rsCart.next()) buyerCartCount = rsCart.getInt(1); rsCart.close(); pstmtCart.close();
                
                PreparedStatement pstmt4 = conn.prepareStatement("SELECT COUNT(*) FROM wishlist WHERE buyer_phone = ?");
                pstmt4.setString(1, userPhone);
                ResultSet rs4 = pstmt4.executeQuery(); if(rs4.next()) buyerWishlistCount = rs4.getInt(1); rs4.close(); pstmt4.close();
                
                PreparedStatement pstmtProd = conn.prepareStatement("SELECT * FROM products WHERE stock_quantity > 0 ORDER BY created_at DESC");
                ResultSet rsProd = pstmtProd.executeQuery();
                boolean hasProducts = false;
                StringBuilder sb = new StringBuilder();
                while(rsProd.next()) {
                    hasProducts = true;
                    String prodName = rsProd.getString("product_name");
                    String prodDesc = rsProd.getString("description");
                    sb.append("<div class='col-md-4 mb-4 product-item' data-name='").append(prodName.toLowerCase()).append("'>");
                    sb.append("<div class='card border-0 shadow-sm h-100 product-card' style='border-radius: 14px;'>");
                    sb.append("<div class='card-body text-center p-4'>");
                    sb.append("<div class='mb-3 text-primary'><i class='fas fa-box-open fa-3x'></i></div>");
                    sb.append("<h5 class='fw-bold text-dark'>").append(prodName).append("</h5>");
                    sb.append("<p class='text-muted small'>").append(prodDesc).append("</p>");
                    sb.append("<h4 class='fw-bold text-success mb-4'>₹").append(rsProd.getString("price")).append("</h4>");
                    
                    sb.append("<form action='BuyerActionServlet' method='POST' class='mb-2'>");
                    sb.append("<input type='hidden' name='action' value='add_to_cart'>");
                    sb.append("<input type='hidden' name='product_id' value='").append(rsProd.getInt("product_id")).append("'>");
                    sb.append("<input type='hidden' name='product_name' value='").append(prodName).append("'>");
                    sb.append("<input type='hidden' name='price' value='").append(rsProd.getString("price")).append("'>");
                    sb.append("<input type='hidden' name='seller_phone' value='").append(rsProd.getString("seller_phone")).append("'>");
                    sb.append("<button type='submit' class='btn btn-warning btn-sm w-100 fw-bold py-2'><i class='fas fa-cart-plus me-1'></i> Add to Cart</button>");
                    sb.append("</form>");
                    
                    sb.append("<form action='BuyerActionServlet' method='POST'>");
                    sb.append("<input type='hidden' name='action' value='wishlist'>");
                    sb.append("<input type='hidden' name='product_id' value='").append(rsProd.getInt("product_id")).append("'>");
                    sb.append("<input type='hidden' name='product_name' value='").append(prodName).append("'>");
                    sb.append("<input type='hidden' name='price' value='").append(rsProd.getString("price")).append("'>");
                    sb.append("<button type='submit' class='btn btn-outline-danger btn-sm w-100 py-2'><i class='fas fa-heart me-1'></i> Add to Wishlist</button>");
                    sb.append("</form>");
                    
                    sb.append("</div></div></div>");
                }
                if(!hasProducts) {
                    sb.append("<div class='col-12'><div class='card border-0 shadow-sm p-5 text-center' style='border-radius: 14px;'>");
                    sb.append("<i class='fas fa-store-slash text-muted mb-3' style='font-size: 4rem; opacity: 0.3;'></i>");
                    sb.append("<h4 class='text-muted'>Catalog is empty</h4><p class='text-muted small'>No products available right now.</p>");
                    sb.append("</div></div>");
                }
                rsProd.close(); pstmtProd.close();
                buyerProductsHtml = sb.toString();
            }
            conn.close();
        } catch(Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CartController</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            /* Soft dim slate-blue background for the entire page */
            background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            color: #f8fafc;
        }
        .navbar-custom { background-color: #0f172a; }
        .card-custom { border: none; border-radius: 16px; background: rgba(255, 255, 255, 0.95); box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.3s ease; }
        .card-custom:hover { transform: translateY(-5px); }
        
        /* Distinct Unique Background Colors for Each Role Banner */
        .hero-buyer { background: linear-gradient(135deg, #0284c7, #0369a1); border-radius: 18px; color: white; box-shadow: 0 10px 25px rgba(2, 132, 199, 0.3); }
        .hero-seller { background: linear-gradient(135deg, #059669, #047857); border-radius: 18px; color: white; box-shadow: 0 10px 25px rgba(5, 150, 105, 0.3); }
                /* Refined Professional Indigo/Purple Theme for Admin */
        .hero-admin { background: linear-gradient(135deg, #6366f1, #4338ca); border-radius: 18px; color: white; box-shadow: 0 10px 25px rgba(99, 102, 241, 0.3); }
        
        
        .product-card { background: rgba(255, 255, 255, 0.95); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom mb-4 shadow-sm py-3">
        <div class="container">
            <a class="navbar-brand fw-bold fs-4 text-white" href="dashboard.jsp"><i class="fas fa-shopping-cart me-2"></i>CartController <span class="badge bg-secondary fs-6 ms-2" style="font-size: 0.7rem !important;">PBL2627-CSE-A-088</span></a>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav align-items-center">
                    <li class="nav-item me-3">
                        <span class="badge bg-light text-dark px-3 py-2 fs-6 shadow-sm">
                            <i class="fas fa-user-tag me-1 text-primary"></i> Role: <%= currentRole.toUpperCase() %>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-light btn-sm px-3 py-2 fw-bold" href="index.jsp"><i class="fas fa-sign-out-alt me-1"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mb-5">
        <div id="roleDashboardContent"></div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.addEventListener('DOMContentLoaded', (event) => {
            setRole('<%= currentRole %>');
        });

        function filterProducts() {
            let input = document.getElementById('productSearchInput').value.toLowerCase();
            let items = document.getElementsByClassName('product-item');
            for (let i = 0; i < items.length; i++) {
                let name = items[i].getAttribute('data-name');
                items[i].style.display = name.includes(input) ? "" : "none";
            }
        }

        function setRole(role) {
            const contentArea = document.getElementById('roleDashboardContent');

            if (role === 'buyer') {
                contentArea.innerHTML = `
                    <!-- Buyer Banner: Ocean Blue Theme -->
                    <div class="p-5 mb-5 hero-buyer position-relative overflow-hidden">
                        <span class="badge bg-white text-primary fw-bold mb-2 px-3 py-2 rounded-pill">Welcome back, <%= userName %>!</span>
                        <h1 class="display-5 fw-bold mb-3 text-white">Smart Shopping & Endless Choices</h1>
                        <p class="lead mb-4 text-white opacity-90">Explore top products, manage your cart, and enjoy seamless checkouts instantly.</p>
                        <div class="d-flex gap-3">
                            <a href="cart.jsp" class="btn btn-light text-primary fw-bold px-4 py-2"><i class="fas fa-shopping-cart me-2"></i>View Cart (<%= buyerCartCount %>)</a>
                            <a href="orders.jsp" class="btn btn-outline-light fw-bold px-4 py-2"><i class="fas fa-box me-2"></i>My Orders (<%= buyerOrdersCount %>)</a>
                        </div>
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-4">
                            <div class="card card-custom p-4 h-100 border-start border-primary border-4" style="cursor: pointer;" onclick="location.href='orders.jsp'">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-muted text-uppercase small fw-bold mb-1">My Orders</h6>
                                        <h2 class="fw-bold mb-0 text-primary"><%= buyerOrdersCount %></h2>
                                    </div>
                                    <div class="text-primary bg-light p-3 rounded-circle"><i class="fas fa-shopping-bag fa-2x"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-custom p-4 h-100 border-start border-warning border-4" style="cursor: pointer;" onclick="location.href='cart.jsp'">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-muted text-uppercase small fw-bold mb-1">My Cart</h6>
                                        <h2 class="fw-bold mb-0 text-warning"><%= buyerCartCount %></h2>
                                    </div>
                                    <div class="text-warning bg-light p-3 rounded-circle"><i class="fas fa-shopping-cart fa-2x"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-custom p-4 h-100 border-start border-success border-4" style="cursor: pointer;" onclick="location.href='wishlist.jsp'">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-muted text-uppercase small fw-bold mb-1">Wishlist</h6>
                                        <h2 class="fw-bold mb-0 text-success"><%= buyerWishlistCount %></h2>
                                    </div>
                                    <div class="text-success bg-light p-3 rounded-circle"><i class="fas fa-heart fa-2x"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row align-items-center mb-4">
                        <div class="col-md-6"><h3 class="fw-bold mb-0 text-white">Explore Store Catalog</h3></div>
                        <div class="col-md-6">
                            <div class="input-group shadow-sm">
                                <span class="input-group-text bg-white border-end-0"><i class="fas fa-search text-muted"></i></span>
                                <input type="text" id="productSearchInput" class="form-control border-start-0 py-2" placeholder="Search by product name..." onkeyup="filterProducts()">
                            </div>
                        </div>
                    </div>

                    <div class="row g-4" id="productCatalogGrid">
                        <%= buyerProductsHtml %>
                    </div>
                `;
            } 
            else if (role === 'seller') {
                contentArea.innerHTML = `
                    <!-- Seller Banner: Emerald Green Theme -->
                    <div class="p-5 mb-5 hero-seller">
                        <span class="badge bg-white text-success fw-bold mb-2 px-3 py-2 rounded-pill">Vendor Portal — <%= userName %></span>
                        <h1 class="display-5 fw-bold mb-3 text-white">Scale Your Business Without Limits</h1>
                        <p class="lead mb-4 text-white opacity-90">List new products, monitor live inventory, and track real-time revenue earnings.</p>
                        <a href="add-product.jsp" class="btn btn-light text-success fw-bold px-4 py-2"><i class="fas fa-plus-circle me-2"></i>+ Add New Product</a>
                    </div>

                    <div class="row g-4 mb-5">
                        <div class="col-md-6">
                            <div class="card card-custom p-4 h-100 border-start border-success border-4" style="cursor: pointer;" onclick="location.href='my-products.jsp'">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-muted text-uppercase small fw-bold mb-1">Active Products Listed</h6>
                                        <h2 class="fw-bold mb-0 text-success"><%= sellerProductCount %></h2>
                                    </div>
                                    <div class="text-success bg-light p-3 rounded-circle"><i class="fas fa-boxes fa-2x"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card card-custom p-4 h-100 border-start border-dark border-4" style="cursor: pointer;" onclick="location.href='seller-revenue.jsp'">
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="text-muted text-uppercase small fw-bold mb-1">Total Revenue Earned</h6>
                                        <h2 class="fw-bold mb-0 text-dark">₹<%= String.format("%.2f", totalRevenue) %></h2>
                                    </div>
                                    <div class="text-dark bg-light p-3 rounded-circle"><i class="fas fa-rupee-sign fa-2x"></i></div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
            } 
            else if (role === 'admin') {
                contentArea.innerHTML = `
                    <!-- Admin Banner: Crimson Red Theme -->
                    <div class="p-5 mb-5 hero-admin">
                        <span class="badge bg-white text-danger fw-bold mb-2 px-3 py-2 rounded-pill">Administrator Control Panel</span>
                        <h1 class="display-5 fw-bold mb-3 text-white">Platform Overview & Management</h1>
                        <p class="lead mb-4 text-white opacity-90">Monitor overall user activity, platform revenue, and manage system accounts securely.</p>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="card card-custom p-4 h-100 border-start border-primary border-4" style="cursor: pointer;" onclick="location.href='admin-users.jsp'">
                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Total Users</h6>
                                <h2 class="fw-bold text-primary mb-0"><%= totalUsers %></h2>
                                <p class="small text-muted mb-0 mt-2">Manage accounts</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom p-4 h-100 border-start border-success border-4" style="cursor: pointer;" onclick="location.href='admin-products.jsp'">
                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Live Products</h6>
                                <h2 class="fw-bold text-success mb-0"><%= totalProducts %></h2>
                                <p class="small text-muted mb-0 mt-2">Platform inventory</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom p-4 h-100 border-start border-warning border-4" style="cursor: pointer;" onclick="location.href='admin-orders.jsp'">
                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Total Orders</h6>
                                <h2 class="fw-bold text-warning mb-0"><%= totalOrders %></h2>
                                <p class="small text-muted mb-0 mt-2">Transactions</p>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card card-custom p-4 h-100 border-start border-dark border-4" style="cursor: pointer;" onclick="location.href='admin-orders.jsp'">
                                <h6 class="text-muted text-uppercase small fw-bold mb-1">Platform Revenue</h6>
                                <h2 class="fw-bold text-dark mb-0">₹<%= String.format("%.2f", platformRevenue) %></h2>
                                <p class="small text-muted mb-0 mt-2">Total money exchanged</p>
                            </div>
                        </div>
                    </div>
                `;
            }
        }
    </script>
</body>
</html>
