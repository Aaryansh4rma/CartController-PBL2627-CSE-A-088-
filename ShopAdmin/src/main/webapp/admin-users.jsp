<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("admin")) {
        response.sendRedirect("index.jsp"); return;
    }
    String adminPhone = (String) session.getAttribute("userPhone");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        <h3 class="fw-bold mb-4"><i class="fas fa-users text-primary me-2"></i>Platform Users</h3>
        
        <% 
            String msg = request.getParameter("msg");
            if ("deleted".equals(msg)) out.print("<div class='alert alert-success'><i class='fas fa-check-circle me-2'></i>User successfully removed from the platform.</div>");
            if ("error".equals(msg)) out.print("<div class='alert alert-danger'>Error removing user. Please check database constraints.</div>");
        %>

        <div class="card shadow-sm border-0 p-0" style="border-radius: 12px; overflow: hidden;">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4 py-3">Full Name</th>
                        <th>Phone Number</th>
                        <th>Role</th>
                        <th>Address</th>
                        <th class="text-end pe-4">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        boolean hasUsers = false;
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");
                            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM users ORDER BY role ASC, full_name ASC");
                            ResultSet rs = pstmt.executeQuery();
                            
                            while(rs.next()) {
                                hasUsers = true;
                                String role = rs.getString("role").toUpperCase();
                                String userPhone = rs.getString("phone");
                                String badgeColor = role.equals("ADMIN") ? "bg-danger" : (role.equals("SELLER") ? "bg-success" : "bg-primary");
                    %>
                                <tr>
                                    <td class="ps-4 fw-bold text-dark"><%= rs.getString("full_name") %></td>
                                    <td class="text-muted"><%= userPhone %></td>
                                    <td><span class="badge <%= badgeColor %>"><%= role %></span></td>
                                    <td class="text-muted small"><%= rs.getString("address") %></td>
                                    <td class="text-end pe-4">
                                        <%-- Safety Check: Prevent the admin from deleting themselves --%>
                                        <% if (userPhone.equals(adminPhone)) { %>
                                            <span class="badge bg-secondary">Current User (You)</span>
                                        <% } else { %>
                                            <form action="AdminActionServlet" method="POST" style="margin: 0;" onsubmit="return confirm('Are you sure you want to permanently remove this user?');">
                                                <input type="hidden" name="action" value="remove_user">
                                                <input type="hidden" name="target_phone" value="<%= userPhone %>">
                                                <button type="submit" class="btn btn-outline-danger btn-sm"><i class="fas fa-user-times me-1"></i> Remove</button>
                                            </form>
                                        <% } %>
                                    </td>
                                </tr>
                    <%
                            }
                            rs.close(); pstmt.close(); conn.close();
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5' class='text-danger text-center py-4'>Error loading users: " + e.getMessage() + "</td></tr>");
                        }
                        
                        if (!hasUsers) {
                            out.println("<tr><td colspan='5' class='text-center py-5 text-muted'>No users found.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
