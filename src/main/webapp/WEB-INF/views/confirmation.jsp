<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Booking Confirmed — TransportIndia</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap');
  :root { --navy:#0a1628; --gold:#f0a500; --muted:#6b7a99; --white:#ffffff; }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white);
         min-height:100vh; display:flex; flex-direction:column; }
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; border-bottom:1px solid rgba(240,165,0,0.2); }
  .logo { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); text-decoration:none; }
  .logo span { color:var(--white); }
  nav a { color:rgba(255,255,255,0.7); text-decoration:none; margin-left:1.5rem; font-size:0.9rem; }

  .page { flex:1; display:flex; justify-content:center; align-items:center; padding:3rem 1.5rem; }
  .card { background:rgba(255,255,255,0.04); border:1px solid rgba(240,165,0,0.2);
          border-radius:14px; padding:3rem; width:100%; max-width:520px; text-align:center; }

  .check-circle { width:80px; height:80px; background:rgba(34,197,94,0.15);
                  border:2px solid rgba(34,197,94,0.5); border-radius:50%;
                  display:flex; align-items:center; justify-content:center;
                  font-size:2.5rem; margin:0 auto 1.5rem; }
  .confirm-title { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:0.4rem; }
  .confirm-sub { color:var(--muted); font-size:0.9rem; margin-bottom:2rem; }

  /* TICKET */
  .ticket { background:rgba(255,255,255,0.04); border:1px dashed rgba(240,165,0,0.3);
            border-radius:10px; padding:1.5rem; text-align:left; margin-bottom:2rem; }
  .ticket-row { display:flex; justify-content:space-between; padding:0.5rem 0;
                border-bottom:1px solid rgba(255,255,255,0.06); font-size:0.88rem; }
  .ticket-row:last-child { border-bottom:none; }
  .ticket-row .key { color:var(--muted); }
  .ticket-row .val { font-weight:500; }
  .ticket-row .val.gold { color:var(--gold); font-family:'Playfair Display',serif; font-size:1.1rem; }
  .ticket-row .val.green { color:#4ade80; }

  .btn-group { display:flex; gap:1rem; }
  .btn { flex:1; padding:0.85rem; border-radius:7px; font-weight:700;
         font-size:0.95rem; cursor:pointer; text-decoration:none;
         display:inline-block; text-align:center; }
  .btn-primary { background:var(--gold); color:var(--navy); border:none; }
  .btn-outline { background:transparent; color:var(--white);
                 border:1px solid rgba(255,255,255,0.2); }
  .btn-outline:hover { border-color:var(--gold); color:var(--gold); }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div>
    <a href="profile">Profile</a>
    <a href="booking">My Bookings</a>
  </div>
</nav>

<div class="page">
  <div class="card">
    <div class="check-circle">✓</div>
    <div class="confirm-title">Booking Confirmed!</div>
    <div class="confirm-sub">Your journey has been booked successfully. Have a great trip!</div>

    <c:if test="${not empty booking}">
      <div class="ticket">
        <div class="ticket-row">
          <span class="key">Booking ID</span>
          <span class="val">#${booking.id}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Transport</span>
          <span class="val">${booking.transportType}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Route</span>
          <span class="val">${booking.source} → ${booking.destination}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Journey Date</span>
          <span class="val">${booking.journeyDate}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Seats</span>
          <span class="val">${booking.seats}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Payment Method</span>
          <span class="val">${paymentMethod}</span>
        </div>
        <div class="ticket-row">
          <span class="key">Amount Paid</span>
          <span class="val gold">₹<fmt:formatNumber value="${booking.totalPrice}" maxFractionDigits="0"/></span>
        </div>
        <div class="ticket-row">
          <span class="key">Status</span>
          <span class="val green">✓ Confirmed</span>
        </div>
      </div>
    </c:if>

    <div class="btn-group">
      <a href="search" class="btn btn-outline">Book Another</a>
      <a href="profile" class="btn btn-primary">View Profile →</a>
    </div>
  </div>
</div>
</body>
</html>
