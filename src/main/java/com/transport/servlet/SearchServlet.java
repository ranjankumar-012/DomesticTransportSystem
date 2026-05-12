package com.transport.servlet;

import com.transport.dao.BookingDAO;
import com.transport.dao.BookingDAOImpl;
import com.transport.model.Vehicle;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class SearchServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String type        = req.getParameter("type");
        String source      = req.getParameter("source");
        String destination = req.getParameter("destination");
        String date        = req.getParameter("date");

        if (type == null || source == null || destination == null || source.isBlank() || destination.isBlank()) {
            req.setAttribute("error", "Please fill all search fields.");
            req.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(req, resp);
            return;
        }

        List<Vehicle> results = bookingDAO.searchVehicles(type, source, destination, date);
        req.setAttribute("results", results);
        req.setAttribute("type", type);
        req.setAttribute("source", source);
        req.setAttribute("destination", destination);
        req.setAttribute("date", date);
        req.getRequestDispatcher("/WEB-INF/views/search.jsp").forward(req, resp);
    }
}
