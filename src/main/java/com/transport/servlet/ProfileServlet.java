package com.transport.servlet;

import com.transport.dao.BookingDAO;
import com.transport.dao.BookingDAOImpl;
import com.transport.dao.UserDAO;
import com.transport.dao.UserDAOImpl;
import com.transport.model.Booking;
import com.transport.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO       = new UserDAOImpl();
    private final BookingDAO bookingDAO = new BookingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute("user");
        List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        User user  = (User) session.getAttribute("user");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        user.setEmail(email);
        user.setPhone(phone);
        if (userDAO.updateUser(user)) {
            session.setAttribute("user", user);
            req.setAttribute("success", "Profile updated successfully.");
        } else {
            req.setAttribute("error", "Update failed.");
        }
        List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
        req.setAttribute("bookings", bookings);
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }
}

