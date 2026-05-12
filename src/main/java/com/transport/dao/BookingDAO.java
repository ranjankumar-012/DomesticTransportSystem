package com.transport.dao;

import com.transport.model.Booking;
import com.transport.model.Vehicle;

import java.util.List;

public interface BookingDAO {
    List<Vehicle> searchVehicles(String type, String source, String destination, String date);
    Vehicle getVehicleById(int id, String type);
    boolean createBooking(Booking booking);
    List<Booking> getBookingsByUser(int userId);
    boolean cancelBooking(int bookingId, int userId);
    List<Booking> getAllBookings();
    List<Vehicle> getAllVehicles();
    boolean addVehicle(Vehicle vehicle);
    boolean updateVehicle(Vehicle vehicle);
    boolean deleteVehicle(int id, String type);
}
