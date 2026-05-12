<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Profile — TransportIndia</title>
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
  .page-grid { display:grid; grid-template-columns:320px 1fr; gap:2rem; }

  /* PROFILE CARD */
  .profile-card { background:rgba(255,255,255,0.04); border:1px solid rgba(240,165,0,0.2);
                  border-radius:12px; padding:2rem; height:fit-content; }
  .avatar { width:70px; height:70px; background:var(--gold); border-radius:50%;
            display:flex; align-items:center; justify-content:center;
            font-family:'Playfair Display',serif; font-size:2rem; color:var(--navy);
            margin-bottom:1rem; }
  .profile-name { font-family:'Playfair Display',serif; font-size:1.4rem; margin-bottom:0.2rem; }
  .profile-role { font-size:0.75rem; letter-spacing:2px; text-transform:uppercase; color:var(--gold); margin-bottom:1.5rem; }

  .field { margin-bottom:1.2rem; }
  .field label { display:block; font-size:0.72rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.4rem; }
  .field input { width:100%; padding:0.75rem 1rem; background:rgba(255,255,255,0.07);
                 border:1px solid rgba(255,255,255,0.12); border-radius:7px;
                 color:var(--white); font-family:'DM Sans',sans-serif; font-size:0.9rem; outline:none; }
  .field input:focus { border-color:var(--gold); }
  .btn-save { width:100%; padding:0.8rem; background:var(--gold); color:var(--navy);
              border:none; border-radius:7px; font-weight:700; font-size:0.95rem; cursor:pointer; margin-top:0.5rem; }
  .btn-save:hover { opacity:0.9; }

  .success { background:rgba(34,197,94,0.1); border:1px solid rgba(34,197,94,0.3);
             color:#4ade80; padding:0.7rem 1rem; border-radius:7px; font-size:0.85rem; margin-bottom:1rem; }
  .error { background:rgba(230,57,70,0.1); border:1px solid rgba(230,57,70,0.3);
           color:#ff6b78; padding:0.7rem 1rem; border-radius:7px; font-size:0.85rem; margin-bottom:1rem; }

  /* BOOKINGS PANEL */
  .panel-title { font-family:'Playfair Display',serif; font-size:1.5rem; margin-bottom:1.2rem; }
  .panel-title span { color:var(--gold); }
  .booking-card { background:var(--card); border:1px solid rgba(255,255,255,0.08);
                  border-radius:9px; padding:1.2rem; margin-bottom:0.9rem;
                  display:flex; justify-content:space-between; align-items:center; }
  .b-type { font-size:0.72rem; letter-spacing:1px; text-transform:uppercase; color:var(--gold); }
  .b-route { font-size:0.95rem; margin:0.2rem 0; }
  .b-meta { font-size:0.78rem; color:var(--muted); }
  .b-price { font-family:'Playfair Display',serif; font-size:1.2rem; color:var(--gold); text-align:right; }
  .badge { display:inline-block; padding:0.2rem 0.65rem; border-radius:20px;
           font-size:0.72rem; font-weight:700; text-transform:uppercase; }
  .badge.confirmed { background:rgba(34,197,94,0.15); color:#4ade80; }
  .badge.cancelled  { background:rgba(230,57,70,0.15); color:#ff6b78; }
  .empty-msg { color:var(--muted); font-size:0.9rem; padding:1rem 0; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div class="nav-links">
    <a href="search">Search</a>
    <a href="booking">My Bookings</a>
    <a href="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="page-grid">
    <!-- LEFT: Profile Edit -->
    <div class="profile-card">
      <div class="avatar">${sessionScope.username.substring(0,1).toUpperCase()}</div>
      <div class="profile-name">${sessionScope.username}</div>
      <div class="profile-role">${sessionScope.role}</div>

      <c:if test="${not empty success}"><div class="success">${success}</div></c:if>
      <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

      <form action="profile" method="post">
        <div class="field">
          <label>Email</label>
          <input type="email" name="email" value="${sessionScope.user.email}" required>
        </div>
        <div class="field">
          <label>Phone</label>
          <input type="tel" name="phone" value="${sessionScope.user.phone}" placeholder="Mobile number">
        </div>
        <button type="submit" class="btn-save">Save Changes</button>
      </form>
    </div>

    <!-- RIGHT: Booking History -->
    <div>
      <div class="panel-title">My <span>Bookings</span></div>
      <c:choose>
        <c:when test="${empty bookings}">
          <div class="empty-msg">No bookings found. <a href="search" style="color:var(--gold)">Search now →</a></div>
        </c:when>
        <c:otherwise>
          <c:forEach var="b" items="${bookings}">
            <div class="booking-card">
              <div>
                <div class="b-type">${b.transportType} • #${b.id}</div>
                <div class="b-route">${b.source} → ${b.destination}</div>
                <div class="b-meta">${b.journeyDate} | ${b.seats} seat(s)</div>
              </div>
              <div>
                <div class="b-price">₹<fmt:formatNumber value="${b.totalPrice}" maxFractionDigits="0"/></div>
                <span class="badge ${b.status}">${b.status}</span>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
</body>
</html>
