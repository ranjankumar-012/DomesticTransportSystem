-- ============================================================
--  Domestic Transport Management System — Corrected Schema
--  Matches: UserDAOImpl, BookingDAOImpl, Vehicle, Booking, User
-- ============================================================

DROP DATABASE IF EXISTS TransportManagementSystem;
CREATE DATABASE TransportManagementSystem;
USE TransportManagementSystem;

-- -------------------------------------------------------
-- 1. passengers  (matches UserDAOImpl columns exactly)
--    id, username, password, email, phone, role
-- -------------------------------------------------------
CREATE TABLE passengers (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    phone       VARCHAR(15),
    role        VARCHAR(10)  NOT NULL DEFAULT 'user',
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP
);

-- -------------------------------------------------------
-- 2. admins  (matches UserDAOImpl — loginUser admin block)
--    id, username, password, email
-- -------------------------------------------------------
CREATE TABLE admins (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  UNIQUE NOT NULL,
    password    VARCHAR(255) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL
);

-- -------------------------------------------------------
-- 3. flights  (matches BookingDAOImpl — mapVehicle)
--    id, name, number, source, destination,
--    departure_time, arrival_time, price,
--    available_seats, total_seats
-- -------------------------------------------------------
CREATE TABLE flights (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    number           VARCHAR(50),
    source           VARCHAR(100) NOT NULL,
    destination      VARCHAR(100) NOT NULL,
    departure_time   VARCHAR(50),
    arrival_time     VARCHAR(50),
    price            DECIMAL(10,2) NOT NULL,
    available_seats  INT DEFAULT 100,
    total_seats      INT DEFAULT 100
);

-- -------------------------------------------------------
-- 4. trains
-- -------------------------------------------------------
CREATE TABLE trains (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    number           VARCHAR(50),
    source           VARCHAR(100) NOT NULL,
    destination      VARCHAR(100) NOT NULL,
    departure_time   VARCHAR(50),
    arrival_time     VARCHAR(50),
    price            DECIMAL(10,2) NOT NULL,
    available_seats  INT DEFAULT 200,
    total_seats      INT DEFAULT 200
);

-- -------------------------------------------------------
-- 5. buses
-- -------------------------------------------------------
CREATE TABLE buses (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    number           VARCHAR(50),
    source           VARCHAR(100) NOT NULL,
    destination      VARCHAR(100) NOT NULL,
    departure_time   VARCHAR(50),
    arrival_time     VARCHAR(50),
    price            DECIMAL(10,2) NOT NULL,
    available_seats  INT DEFAULT 50,
    total_seats      INT DEFAULT 50
);

-- -------------------------------------------------------
-- 6. ships
-- -------------------------------------------------------
CREATE TABLE ships (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    number           VARCHAR(50),
    source           VARCHAR(100) NOT NULL,
    destination      VARCHAR(100) NOT NULL,
    departure_time   VARCHAR(50),
    arrival_time     VARCHAR(50),
    price            DECIMAL(10,2) NOT NULL,
    available_seats  INT DEFAULT 300,
    total_seats      INT DEFAULT 300
);

-- -------------------------------------------------------
-- 7. bookings  (matches BookingDAOImpl — createBooking,
--               mapBooking, cancelBooking, getAllBookings)
--    id, user_id, transport_type, vehicle_id,
--    source, destination, journey_date, seats,
--    total_price, status, booking_time
-- -------------------------------------------------------
CREATE TABLE bookings (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    transport_type  ENUM('flight','train','bus','ship') NOT NULL,
    vehicle_id      INT NOT NULL,
    source          VARCHAR(100),
    destination     VARCHAR(100),
    journey_date    DATE NOT NULL,
    seats           INT  DEFAULT 1,
    total_price     DECIMAL(10,2),
    status          ENUM('confirmed','cancelled','pending') DEFAULT 'confirmed',
    booking_time    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES passengers(id)
);

-- -------------------------------------------------------
-- 8. payment  (matches PaymentServlet)
--    id, booking_id, amount, payment_method, status
-- -------------------------------------------------------
CREATE TABLE payment (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT NOT NULL,
    amount          DECIMAL(10,2) NOT NULL,
    payment_method  VARCHAR(50)   DEFAULT 'upi',
    status          ENUM('pending','completed','failed') DEFAULT 'completed',
    payment_time    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

-- ============================================================
--  SAMPLE DATA
-- ============================================================

-- Admin account  (password: admin123)
INSERT INTO admins (username, password, email)
VALUES ('admin', 'admin123', 'admin@transport.com');

-- Flights
INSERT INTO flights (name, number, source, destination, departure_time, arrival_time, price, available_seats, total_seats) VALUES
('IndiGo',    '6E-101', 'Delhi',   'Mumbai',    '06:00', '08:10', 3500.00, 100, 100),
('Air India', 'AI-202', 'Delhi',   'Bangalore', '09:00', '11:30', 8500.00, 100, 100),
('SpiceJet',  'SG-303', 'Mumbai',  'Chennai',   '13:00', '14:45', 2800.00, 100, 100),
('IndiGo',    '6E-205', 'Chennai', 'Delhi',     '07:00', '09:30', 4000.00, 100, 100);

-- Trains
INSERT INTO trains (name, number, source, destination, departure_time, arrival_time, price, available_seats, total_seats) VALUES
('Rajdhani Express', '12951', 'Delhi',  'Mumbai', '16:00', '08:00', 2200.00, 200, 200),
('Shatabdi Express', '12001', 'Delhi',  'Agra',   '06:00', '08:00',  850.00, 200, 200),
('Duronto Express',  '12213', 'Mumbai', 'Delhi',  '23:00', '15:30', 1900.00, 200, 200);

-- Buses
INSERT INTO buses (name, number, source, destination, departure_time, arrival_time, price, available_seats, total_seats) VALUES
('UPSRTC Volvo', 'UP-001', 'Delhi',  'Agra',   '07:00', '11:00', 400.00, 50, 50),
('RSRTC Express','RJ-002', 'Delhi',  'Jaipur', '08:00', '13:00', 550.00, 50, 50),
('MSRTC Shivneri','MH-003','Mumbai', 'Pune',   '06:00', '09:30', 300.00, 50, 50);

-- Ships
INSERT INTO ships (name, number, source, destination, departure_time, arrival_time, price, available_seats, total_seats) VALUES
('Andaman Ferry',     'AF-101', 'Chennai', 'Port Blair',  '08:00', '56:00', 3200.00, 300, 300),
('Lakshadweep Cruise','LC-202', 'Kochi',   'Lakshadweep', '09:00', '33:00', 5500.00, 300, 300);
