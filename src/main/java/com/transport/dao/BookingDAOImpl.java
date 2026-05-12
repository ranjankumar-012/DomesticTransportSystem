package com.transport.dao;

import com.transport.model.Booking;
import com.transport.model.Vehicle;
import com.transport.util.DBConnection;

import java.sql.*;
import java.util.*;

public class BookingDAOImpl implements BookingDAO {

    // Maps transport type to its DB table name
    private String getTable(String type) {
        return switch (type.toLowerCase()) {
            case "flight" -> "flights";
            case "train"  -> "trains";
            case "bus"    -> "buses";
            case "ship"   -> "ships";
            default -> throw new IllegalArgumentException("Unknown type: " + type);
        };
    }

    @Override
    public List<Vehicle> searchVehicles(String type, String source, String destination, String date) {
        List<Vehicle> list = new ArrayList<>();
        String table = getTable(type);
        String sql = "SELECT * FROM " + table +
                     " WHERE LOWER(source) = LOWER(?) AND LOWER(destination) = LOWER(?) AND available_seats > 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, source);
            ps.setString(2, destination);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapVehicle(rs, type));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Vehicle getVehicleById(int id, String type) {
        String table = getTable(type);
        String sql = "SELECT * FROM " + table + " WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapVehicle(rs, type);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean createBooking(Booking booking) {
        String table = getTable(booking.getTransportType());
        // Insert booking record
        String sql = "INSERT INTO bookings (user_id, transport_type, vehicle_id, source, destination, journey_date, seats, total_price, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'confirmed')";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, booking.getUserId());
                ps.setString(2, booking.getTransportType());
                ps.setInt(3, booking.getVehicleId());
                ps.setString(4, booking.getSource());
                ps.setString(5, booking.getDestination());
                ps.setString(6, booking.getJourneyDate());
                ps.setInt(7, booking.getSeats());
                ps.setDouble(8, booking.getTotalPrice());
                ps.executeUpdate();
            }
            // Decrease available seats
            String updateSeats = "UPDATE " + table + " SET available_seats = available_seats - ? WHERE id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(updateSeats)) {
                ps2.setInt(1, booking.getSeats());
                ps2.setInt(2, booking.getVehicleId());
                ps2.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE user_id = ? ORDER BY booking_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapBooking(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean cancelBooking(int bookingId, int userId) {
        // First get booking details to restore seats
        String getSql = "SELECT * FROM bookings WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            Booking b = null;
            try (PreparedStatement ps = conn.prepareStatement(getSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) b = mapBooking(rs);
            }
            if (b == null) return false;

            // Update status to cancelled
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE bookings SET status = 'cancelled' WHERE id = ?")) {
                ps.setInt(1, bookingId);
                ps.executeUpdate();
            }
            // Restore seats
            String table = getTable(b.getTransportType());
            try (PreparedStatement ps = conn.prepareStatement(
                    "UPDATE " + table + " SET available_seats = available_seats + ? WHERE id = ?")) {
                ps.setInt(1, b.getSeats());
                ps.setInt(2, b.getVehicleId());
                ps.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Booking> getAllBookings() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, p.username FROM bookings b JOIN passengers p ON b.user_id = p.id ORDER BY b.booking_time DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Booking b = mapBooking(rs);
                try { b.setVehicleName(rs.getString("username")); } catch (SQLException ignored) {}
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String[] types = {"flight", "train", "bus", "ship"};
        for (String type : types) {
            String sql = "SELECT * FROM " + getTable(type);
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapVehicle(rs, type));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    @Override
    public boolean addVehicle(Vehicle v) {
        String table = getTable(v.getType());
        String sql = "INSERT INTO " + table +
                     " (name, number, source, destination, departure_time, arrival_time, price, available_seats, total_seats) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getNumber());
            ps.setString(3, v.getSource());
            ps.setString(4, v.getDestination());
            ps.setString(5, v.getDepartureTime());
            ps.setString(6, v.getArrivalTime());
            ps.setDouble(7, v.getPrice());
            ps.setInt(8, v.getAvailableSeats());
            ps.setInt(9, v.getTotalSeats());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateVehicle(Vehicle v) {
        String table = getTable(v.getType());
        String sql = "UPDATE " + table +
                     " SET name=?, source=?, destination=?, departure_time=?, arrival_time=?, price=?, available_seats=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getSource());
            ps.setString(3, v.getDestination());
            ps.setString(4, v.getDepartureTime());
            ps.setString(5, v.getArrivalTime());
            ps.setDouble(6, v.getPrice());
            ps.setInt(7, v.getAvailableSeats());
            ps.setInt(8, v.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteVehicle(int id, String type) {
        String sql = "DELETE FROM " + getTable(type) + " WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Vehicle mapVehicle(ResultSet rs, String type) throws SQLException {
        Vehicle v = new Vehicle();
        v.setId(rs.getInt("id"));
        v.setType(type);
        try { v.setName(rs.getString("name")); } catch (SQLException ignored) {}
        try { v.setNumber(rs.getString("number")); } catch (SQLException ignored) {}
        v.setSource(rs.getString("source"));
        v.setDestination(rs.getString("destination"));
        try { v.setDepartureTime(rs.getString("departure_time")); } catch (SQLException ignored) {}
        try { v.setArrivalTime(rs.getString("arrival_time")); } catch (SQLException ignored) {}
        v.setPrice(rs.getDouble("price"));
        v.setAvailableSeats(rs.getInt("available_seats"));
        try { v.setTotalSeats(rs.getInt("total_seats")); } catch (SQLException ignored) {}
        return v;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setTransportType(rs.getString("transport_type"));
        b.setVehicleId(rs.getInt("vehicle_id"));
        b.setSource(rs.getString("source"));
        b.setDestination(rs.getString("destination"));
        b.setJourneyDate(rs.getString("journey_date"));
        b.setSeats(rs.getInt("seats"));
        b.setTotalPrice(rs.getDouble("total_price"));
        b.setStatus(rs.getString("status"));
        return b;
    }
}
