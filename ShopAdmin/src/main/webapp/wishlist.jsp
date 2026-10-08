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
    <title>My Wishlist - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        <h3 class="fw-bold mb-4">My Wishlist</h3>
        
        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Product Name</th>
                        <th>Price</th>
                        <th>Saved Date</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasWishlist = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM wishlist WHERE buyer_phone = ? ORDER BY added_at DESC");
                            pstmt.setString(1, buyerPhone);
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasWishlist = true;
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-dark"><i class="fas fa-heart text-danger me-2"></i> <%= rs.getString("product_name") %></td>
                                    <td class="text-success fw-bold">₹<%= rs.getString("price") %></td>
                                    <td class="text-muted small"><%= rs.getTimestamp("added_at") %></td>
                                    <td class="text-end pe-4">
                                        <form action="BuyerActionServlet" method="POST" style="margin: 0;">
                                            <input type="hidden" name="action" value="remove_wishlist">
                                            <input type="hidden" name="wishlist_id" value="<%= rs.getInt("wishlist_id") %>">
                                            <button type="submit" class="btn btn-outline-danger btn-sm"><i class="fas fa-trash-alt me-1"></i> Remove</button>
                                        </form>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4' class='text-danger text-center py-4'>Error loading wishlist: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasWishlist) {
                            out.println("<tr><td colspan='4' class='text-center py-5 text-muted'><i class='fas fa-heart mb-3' style='font-size: 3rem; opacity: 0.3;'></i><br>Your wishlist is empty.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
