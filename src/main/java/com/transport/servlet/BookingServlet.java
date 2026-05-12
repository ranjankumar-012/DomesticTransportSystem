package com.transport.servlet;

import com.transport.dao.BookingDAO;
import com.transport.dao.BookingDAOImpl;
import com.transport.model.Booking;
import com.transport.model.User;
import com.transport.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("view".equals(action)) {
            // Show booking form for a selected vehicle
            int vehicleId      = Integer.parseInt(req.getParameter("vehicleId"));
            String type        = req.getParameter("type");
            String date        = req.getParameter("date");
            Vehicle vehicle    = bookingDAO.getVehicleById(vehicleId, type);
            req.setAttribute("vehicle", vehicle);
            req.setAttribute("date", date);
            req.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(req, resp);

        } else if ("cancel".equals(action)) {
            User user = (User) session.getAttribute("user");
            int bookingId = Integer.parseInt(req.getParameter("id"));
            bookingDAO.cancelBooking(bookingId, user.getId());
            resp.sendRedirect(req.getContextPath() + "/profile");

        } else {
            // Show user's bookings
            User user = (User) session.getAttribute("user");
            List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/WEB-INF/views/myBookings.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user       = (User) session.getAttribute("user");
        int vehicleId   = Integer.parseInt(req.getParameter("vehicleId"));
        String type     = req.getParameter("type");
        String source   = req.getParameter("source");
        String dest     = req.getParameter("destination");
        String date     = req.getParameter("date");
        int seats       = Integer.parseInt(req.getParameter("seats"));
        double price    = Double.parseDouble(req.getParameter("price"));

        Booking booking = new Booking();
        booking.setUserId(user.getId());
        booking.setTransportType(type);
        booking.setVehicleId(vehicleId);
        booking.setSource(source);
        booking.setDestination(dest);
        booking.setJourneyDate(date);
        booking.setSeats(seats);
        booking.setTotalPrice(price * seats);
        booking.setStatus("confirmed");

        if (bookingDAO.createBooking(booking)) {
            // Store booking in session for payment/confirmation page
            session.setAttribute("lastBooking", booking);
            resp.sendRedirect(req.getContextPath() + "/payment");
        } else {
            req.setAttribute("error", "Booking failed. Please try again.");
            Vehicle vehicle = bookingDAO.getVehicleById(vehicleId, type);
            req.setAttribute("vehicle", vehicle);
            req.setAttribute("date", date);
            req.getRequestDispatcher("/WEB-INF/views/booking.jsp").forward(req, resp);
        }
    }
}

