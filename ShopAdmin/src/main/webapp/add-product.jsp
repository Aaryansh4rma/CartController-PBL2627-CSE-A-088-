<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Security: Only allow sellers
    if (session.getAttribute("userRole") == null || !session.getAttribute("userRole").equals("seller")) {
        response.sendRedirect("index.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Product - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5" style="max-width: 600px;">
        <a href="dashboard.jsp" class="btn btn-outline-dark btn-sm mb-4"><i class="fas fa-arrow-left me-1"></i> Back to Dashboard</a>
        
        <div class="card shadow border-0" style="border-radius: 12px;">
            <div class="card-header bg-success text-white p-3" style="border-radius: 12px 12px 0 0;">
                <h4 class="mb-0"><i class="fas fa-box-open me-2"></i>List a New Product</h4>
            </div>
            <div class="card-body p-4">
                <form action="AddProductServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small">Product Name</label>
                        <input type="text" class="form-control" name="product_name" placeholder="e.g., Wireless Mouse" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold text-muted small">Description</label>
                        <textarea class="form-control" name="description" rows="3" placeholder="Describe the item..." required></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold text-muted small">Price (₹)</label>
                            <input type="number" step="0.01" class="form-control" name="price" placeholder="0.00" required>
                        </div>
                        <div class="col-md-6 mb-4">
                            <label class="form-label fw-bold text-muted small">Stock Quantity</label>
                            <input type="number" class="form-control" name="stock_quantity" placeholder="e.g., 50" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-success w-100 fw-bold py-2">Publish Product</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
