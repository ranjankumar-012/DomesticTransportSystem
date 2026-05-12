package com.transport.servlet;

import com.transport.dao.BookingDAO;
import com.transport.dao.BookingDAOImpl;
import com.transport.model.Booking;
import com.transport.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAOImpl();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "admin".equals(s.getAttribute("role"));
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("deleteVehicle".equals(action)) {
            int id     = Integer.parseInt(req.getParameter("id"));
            String type = req.getParameter("type");
            bookingDAO.deleteVehicle(id, type);
            resp.sendRedirect(req.getContextPath() + "/admin?tab=vehicles");
            return;
        }

        if ("editVehicle".equals(action)) {
            int id      = Integer.parseInt(req.getParameter("id"));
            String type = req.getParameter("type");
            Vehicle v   = bookingDAO.getVehicleById(id, type);
            req.setAttribute("editVehicle", v);
        }

        List<Booking> bookings  = bookingDAO.getAllBookings();
        List<Vehicle> vehicles  = bookingDAO.getAllVehicles();
        req.setAttribute("bookings", bookings);
        req.setAttribute("vehicles", vehicles);
        req.setAttribute("tab", req.getParameter("tab") != null ? req.getParameter("tab") : "bookings");
        req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("addVehicle".equals(action)) {
            Vehicle v = buildVehicleFromRequest(req);
            bookingDAO.addVehicle(v);
            resp.sendRedirect(req.getContextPath() + "/admin?tab=vehicles&msg=added");
            return;
        }

        if ("updateVehicle".equals(action)) {
            Vehicle v = buildVehicleFromRequest(req);
            v.setId(Integer.parseInt(req.getParameter("id")));
            bookingDAO.updateVehicle(v);
            resp.sendRedirect(req.getContextPath() + "/admin?tab=vehicles&msg=updated");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin");
    }

    private Vehicle buildVehicleFromRequest(HttpServletRequest req) {
        Vehicle v = new Vehicle();
        v.setType(req.getParameter("type"));
        v.setName(req.getParameter("name"));
        v.setNumber(req.getParameter("number"));
        v.setSource(req.getParameter("source"));
        v.setDestination(req.getParameter("destination"));
        v.setDepartureTime(req.getParameter("departureTime"));
        v.setArrivalTime(req.getParameter("arrivalTime"));
        v.setPrice(Double.parseDouble(req.getParameter("price")));
        v.setAvailableSeats(Integer.parseInt(req.getParameter("availableSeats")));
        v.setTotalSeats(Integer.parseInt(req.getParameter("totalSeats")));
        return v;
    }
}
