<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - ShopAdmin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>body { background-color: #f4f6f9; }</style>
</head>
<body>
    <div class="container mt-5" style="max-width: 500px;">
        <div class="card shadow border-0 p-4" style="border-radius: 12px;">
            <div class="text-center mb-4">
                <i class="fas fa-user-plus text-primary fs-1 mb-2"></i>
                <h3 class="fw-bold">Create an Account</h3>
                <p class="text-muted small">Register as a Buyer, Seller, or Administrator</p>
            </div>
            
            <form action="CustomerRegisterServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Full Name</label>
                    <input type="text" class="form-control" name="name" placeholder="Enter your full name" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Mobile Number</label>
                    <input type="text" class="form-control" name="phone" placeholder="Enter your mobile number" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Password</label>
                    <input type="password" class="form-control" name="password" placeholder="Choose a password" required>
                </div>
                
                <div class="mb-3">
                    <label class="form-label fw-bold small text-muted">Register As</label>
                    <select class="form-select" name="role" required>
                        <option value="buyer">Buyer / Shopper</option>
                        <option value="seller">Seller / Vendor</option>
                        <option value="admin">Administrator / Manager</option>
                    </select>
                </div>
                
                <div class="mb-4">
                    <label class="form-label fw-bold small text-muted">Address / Location</label>
                    <textarea class="form-control" name="address" rows="2" placeholder="Enter your address" required></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary w-100 fw-bold py-2">Register & Continue</button>
            </form>
            
            <div class="text-center mt-3">
                <p class="small text-muted">Already have an account? <a href="index.jsp">Sign In</a></p>
            </div>
        </div>
    </div>
</body>
</html>
