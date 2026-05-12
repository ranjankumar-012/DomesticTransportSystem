package com.transport.servlet;

import com.transport.model.Booking;
import com.transport.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Booking booking = (Booking) session.getAttribute("lastBooking");
        if (booking == null) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        req.setAttribute("booking", booking);
        req.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Booking booking       = (Booking) session.getAttribute("lastBooking");
        String paymentMethod  = req.getParameter("paymentMethod");

        if (booking == null) {
            resp.sendRedirect(req.getContextPath() + "/search");
            return;
        }

        // Insert payment record into DB
        String sql = "INSERT INTO payment (booking_id, amount, payment_method, status) VALUES (?, ?, ?, 'completed')";
        boolean paymentSuccess = false;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, booking.getId());
            ps.setDouble(2, booking.getTotalPrice());
            ps.setString(3, paymentMethod != null ? paymentMethod : "upi");
            paymentSuccess = ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }

        if (paymentSuccess) {
            session.removeAttribute("lastBooking");                  // clean up session
            req.setAttribute("booking", booking);
            req.setAttribute("paymentMethod", paymentMethod);
            req.getRequestDispatcher("/WEB-INF/views/confirmation.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Payment failed. Please try again.");
            req.setAttribute("booking", booking);
            req.getRequestDispatcher("/WEB-INF/views/payment.jsp").forward(req, resp);
        }
    }
}