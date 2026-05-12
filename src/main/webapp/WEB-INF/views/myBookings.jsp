<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Bookings — TransportIndia</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap');
  :root { --navy:#0a1628; --gold:#f0a500; --muted:#6b7a99; --white:#ffffff; --card:#0d1f3c; }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white); min-height:100vh; }
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; border-bottom:1px solid rgba(240,165,0,0.2); }
  .logo { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); text-decoration:none; }
  .logo span { color:var(--white); }
  .nav-links a { color:rgba(255,255,255,0.7); text-decoration:none; margin-left:1.5rem; font-size:0.9rem; }
  .nav-links a:hover { color:var(--gold); }

  .container { max-width:900px; margin:0 auto; padding:3rem 1.5rem; }
  h1 { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:0.4rem; }
  h1 span { color:var(--gold); }
  .subtitle { color:var(--muted); margin-bottom:2rem; font-size:0.9rem; }

  .booking-card { background:var(--card); border:1px solid rgba(255,255,255,0.08);
                  border-radius:10px; padding:1.5rem; margin-bottom:1rem;
                  display:flex; justify-content:space-between; align-items:center; }
  .booking-card.cancelled { opacity:0.55; }
  .b-left h3 { font-size:1rem; margin-bottom:0.3rem; }
  .b-left .route { font-size:0.9rem; color:var(--gold); margin-bottom:0.3rem; }
  .b-left .meta { font-size:0.8rem; color:var(--muted); }
  .b-right { text-align:right; }
  .b-price { font-family:'Playfair Display',serif; font-size:1.4rem; color:var(--gold); }
  .b-seats { font-size:0.78rem; color:var(--muted); margin-bottom:0.6rem; }
  .badge { display:inline-block; padding:0.25rem 0.75rem; border-radius:20px;
           font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.5px; }
  .badge.confirmed { background:rgba(34,197,94,0.15); color:#4ade80; border:1px solid rgba(34,197,94,0.3); }
  .badge.cancelled  { background:rgba(230,57,70,0.15); color:#ff6b78; border:1px solid rgba(230,57,70,0.3); }
  .badge.pending    { background:rgba(240,165,0,0.15); color:var(--gold); border:1px solid rgba(240,165,0,0.3); }

  .btn-cancel { background:transparent; border:1px solid rgba(230,57,70,0.5);
                color:#ff6b78; padding:0.4rem 1rem; border-radius:5px;
                font-size:0.8rem; cursor:pointer; margin-top:0.6rem; }
  .btn-cancel:hover { background:rgba(230,57,70,0.1); }

  .empty { text-align:center; padding:4rem; color:var(--muted); }
  .empty .icon { font-size:3.5rem; margin-bottom:1rem; }
  .btn-search { display:inline-block; margin-top:1rem; background:var(--gold);
                color:var(--navy); padding:0.7rem 1.8rem; border-radius:6px;
                text-decoration:none; font-weight:700; font-size:0.9rem; }
  .type-icon { margin-right:0.4rem; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div class="nav-links">
    <a href="search">Search</a>
    <a href="profile">Profile</a>
    <a href="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <h1>My <span>Bookings</span></h1>
  <div class="subtitle">All your journeys in one place</div>

  <c:choose>
    <c:when test="${empty bookings}">
      <div class="empty">
        <div class="icon">🎫</div>
        <p>No bookings yet.</p>
        <a href="search" class="btn-search">Search & Book Now</a>
      </div>
    </c:when>
    <c:otherwise>
      <c:forEach var="b" items="${bookings}">
        <div class="booking-card ${b.status}">
          <div class="b-left">
            <h3>
              <span class="type-icon">
                <c:choose>
                  <c:when test="${b.transportType=='flight'}">✈</c:when>
                  <c:when test="${b.transportType=='train'}">🚆</c:when>
                  <c:when test="${b.transportType=='bus'}">🚌</c:when>
                  <c:otherwise>🚢</c:otherwise>
                </c:choose>
              </span>
              Booking #${b.id}
            </h3>
            <div class="route">${b.source} → ${b.destination}</div>
            <div class="meta">
              Date: ${b.journeyDate} &nbsp;|&nbsp;
              Seats: ${b.seats} &nbsp;|&nbsp;
              Type: ${b.transportType}
            </div>
          </div>
          <div class="b-right">
            <div class="b-price">₹<fmt:formatNumber value="${b.totalPrice}" maxFractionDigits="0"/></div>
            <div class="b-seats">${b.seats} seat(s)</div>
            <span class="badge ${b.status}">${b.status}</span>
            <c:if test="${b.status == 'confirmed'}">
              <br>
              <form action="booking" method="get" style="display:inline">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id" value="${b.id}">
                <button type="submit" class="btn-cancel"
                  onclick="return confirm('Cancel this booking?')">Cancel</button>
              </form>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>
</div>
</body>
</html>
