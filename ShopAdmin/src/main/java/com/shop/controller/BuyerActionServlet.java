package com.shop.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/BuyerActionServlet")
public class BuyerActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String buyerPhone = (String) session.getAttribute("userPhone");
        
        if (buyerPhone == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://mysql-350b8369-aaryansharma77903-69e4.c.aivencloud.com:19225/shopadmin?sslMode=REQUIRED", "avnadmin", "AVNS_xR7SkvA7I7J0psqdtnC");

            if ("add_to_cart".equals(action)) {
                String productId = request.getParameter("product_id");
                String productName = request.getParameter("product_name");
                String price = request.getParameter("price");
                String sellerPhone = request.getParameter("seller_phone");
                
                String sql = "INSERT INTO cart (buyer_phone, seller_phone, product_id, product_name, price) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, buyerPhone);
                pstmt.setString(2, sellerPhone);
                pstmt.setString(3, productId);
                pstmt.setString(4, productName);
                pstmt.setString(5, price);
                pstmt.executeUpdate();
                pstmt.close();

                response.sendRedirect("catalog.jsp?msg=cart_added");
            } 
            else if ("wishlist".equals(action)) {
                String productId = request.getParameter("product_id");
                String productName = request.getParameter("product_name");
                String price = request.getParameter("price");
                
                String sql = "INSERT INTO wishlist (buyer_phone, product_id, product_name, price) VALUES (?, ?, ?, ?)";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, buyerPhone);
                pstmt.setString(2, productId);
                pstmt.setString(3, productName);
                pstmt.setString(4, price);
                pstmt.executeUpdate();
                pstmt.close();

                response.sendRedirect("catalog.jsp?msg=saved");
            }
            else if ("remove_cart".equals(action)) {
                String cartId = request.getParameter("cart_id");
                String sql = "DELETE FROM cart WHERE cart_id = ? AND buyer_phone = ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, cartId);
                pstmt.setString(2, buyerPhone);
                pstmt.executeUpdate();
                pstmt.close();

                response.sendRedirect("cart.jsp");
            }
            else if ("checkout".equals(action)) {
                // Generate a single unique Order/Transaction ID for this batch
                String txnId = "ORD-" + System.currentTimeMillis();

                PreparedStatement pstmtCart = conn.prepareStatement("SELECT * FROM cart WHERE buyer_phone = ?");
                pstmtCart.setString(1, buyerPhone);
                ResultSet rsCart = pstmtCart.executeQuery();
                
                while(rsCart.next()) {
                    String sellerPhone = rsCart.getString("seller_phone");
                    int productId = rsCart.getInt("product_id");
                    String productName = rsCart.getString("product_name");
                    double price = rsCart.getDouble("price");
                    
                    // Insert into orders with the shared transaction ID
                    PreparedStatement pstmtOrder = conn.prepareStatement("INSERT INTO orders (buyer_phone, seller_phone, product_id, product_name, price, transaction_id) VALUES (?, ?, ?, ?, ?, ?)");
                    pstmtOrder.setString(1, buyerPhone);
                    pstmtOrder.setString(2, sellerPhone);
                    pstmtOrder.setInt(3, productId);
                    pstmtOrder.setString(4, productName);
                    pstmtOrder.setDouble(5, price);
                    pstmtOrder.setString(6, txnId);
                    pstmtOrder.executeUpdate();
                    pstmtOrder.close();
                    
                    // Reduce product stock
                    PreparedStatement pstmtStock = conn.prepareStatement("UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = ?");
                    pstmtStock.setInt(1, productId);
                    pstmtStock.executeUpdate();
                    pstmtStock.close();
                }
                rsCart.close(); pstmtCart.close();
                
                // Clear the cart
                PreparedStatement pstmtClear = conn.prepareStatement("DELETE FROM cart WHERE buyer_phone = ?");
                pstmtClear.setString(1, buyerPhone);
                pstmtClear.executeUpdate();
                pstmtClear.close();

                response.sendRedirect("orders.jsp");
            }
            else if ("remove_order".equals(action)) {
                String orderId = request.getParameter("order_id");
                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM orders WHERE order_id = ? AND buyer_phone = ?");
                pstmt.setString(1, orderId);
                pstmt.setString(2, buyerPhone);
                pstmt.executeUpdate();
                pstmt.close();
                response.sendRedirect("orders.jsp");
            }
            else if ("remove_wishlist".equals(action)) {
                String wishlistId = request.getParameter("wishlist_id");
                PreparedStatement pstmt = conn.prepareStatement("DELETE FROM wishlist WHERE wishlist_id = ? AND buyer_phone = ?");
                pstmt.setString(1, wishlistId);
                pstmt.setString(2, buyerPhone);
                pstmt.executeUpdate();
                pstmt.close();
                response.sendRedirect("wishlist.jsp");
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=action_failed");
        }
    }
}
