<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CartController - E-Commerce Management Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            /* Soft, dim professional slate-blue gradient background */
            background: linear-gradient(135deg, #2c3e50 0%, #4ca1af 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            color: #ffffff;
        }
        .hero-card { 
            border: none; 
            border-radius: 16px; 
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15); 
            transition: transform 0.3s ease, box-shadow 0.3s ease; 
        }
        .hero-card:hover { 
            transform: translateY(-8px); 
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
        }
        .brand-header-bg {
            background: rgba(255, 255, 255, 0.95);
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            margin-bottom: 2.5rem;
            color: #2c3e50;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100 justify-content-center align-items-center py-5">

    <div class="container text-center" style="max-width: 950px;">
        
        <!-- Header Banner Card -->
        <div class="brand-header-bg">
            <span class="badge bg-primary px-3 py-2 rounded-pill mb-3 fw-bold shadow-sm" style="font-size: 0.85rem;">PBL2627-CSE-A-088</span>
            <div class="text-primary mb-2"><i class="fas fa-shopping-cart fa-3x"></i></div>
            <h1 class="fw-bold display-5 text-dark mb-2">CartController</h1>
            <p class="text-muted lead mb-0">E-Commerce Management and Shopping Portal — Select your role to log in or register</p>
        </div>

        <!-- Role Selection Cards -->
        <div class="row g-4">
            <!-- Buyer Portal Option -->
            <div class="col-md-4">
                <div class="card hero-card p-4 h-100 text-center d-flex flex-column">
                    <div class="text-primary my-3"><i class="fas fa-shopping-bag fa-3x"></i></div>
                    <h4 class="fw-bold text-dark">Buyer</h4>
                    <p class="text-muted small flex-grow-1">Browse products, place orders, manage your cart, and track your wishlist items.</p>
                    <a href="login.jsp?role=buyer" class="btn btn-primary w-100 fw-bold py-2 mt-3 shadow-sm">Buyer Login</a>
                </div>
            </div>

            <!-- Seller Portal Option -->
            <div class="col-md-4">
                <div class="card hero-card p-4 h-100 text-center d-flex flex-column">
                    <div class="text-success my-3"><i class="fas fa-store fa-3x"></i></div>
                    <h4 class="fw-bold text-dark">Seller</h4>
                    <p class="text-muted small flex-grow-1">List new products, manage active stock inventory, and track real-time revenue.</p>
                    <a href="login.jsp?role=seller" class="btn btn-success w-100 fw-bold py-2 mt-3 shadow-sm">Seller Login</a>
                </div>
            </div>

            <!-- Admin Portal Option -->
            <div class="col-md-4">
                <div class="card hero-card p-4 h-100 text-center d-flex flex-column">
                    <div class="text-danger my-3"><i class="fas fa-user-shield fa-3x"></i></div>
                    <h4 class="fw-bold text-dark">Admin</h4>
                    <p class="text-muted small flex-grow-1">Monitor platform metrics, review transaction logs, and manage user accounts.</p>
                    <a href="login.jsp?role=admin" class="btn btn-danger w-100 fw-bold py-2 mt-3 shadow-sm">Admin Login</a>
                </div>
            </div>
        </div>

        <!-- Footer Info -->
        <div class="mt-5 text-light opacity-85 small">
            <p class="mb-1 fw-semibold">Arya College of Engineering & I.T. • 5th Semester PBL Project</p>
            <p class="mb-0" style="font-size: 0.8rem;">Guided by Er. Ram Babu Buri</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
