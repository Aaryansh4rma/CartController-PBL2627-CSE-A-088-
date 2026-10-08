<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = request.getParameter("role");
    if(role == null) role = "buyer"; // default fallback
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= role.toUpperCase() %> Login - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body class="d-flex align-items-center justify-content-center vh-100">
    <div class="card shadow p-4" style="max-width: 400px; width: 100%; border-radius: 12px;">
        <div class="text-center mb-4">
            <i class="fas fa-user-lock text-primary fa-2x mb-2"></i>
            <h3 class="fw-bold text-capitalize"><%= role %> Login</h3>
            <p class="text-muted small">Please authenticate to access your dashboard</p>
        </div>

        <form action="LoginServlet" method="POST">
            <input type="hidden" name="role" value="<%= role %>">

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted">Mobile Number / ID</label>
                <input type="text" class="form-control" name="phone" placeholder="Enter your ID or phone" required>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted">Password</label>
                <input type="password" class="form-control" name="password" placeholder="Enter password" required>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-bold">Sign In</button>
        </form>

        <div class="text-center mt-3">
            <small class="text-muted">Don't have an account? <a href="register.jsp">Register here</a></small>
            <div class="mt-2"><a href="index.jsp" class="text-muted small"><i class="fas fa-arrow-left me-1"></i> Back to Roles</a></div>
        </div>
    </div>
</body>
</html>
