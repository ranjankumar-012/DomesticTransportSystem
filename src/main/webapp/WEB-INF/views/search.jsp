<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Search — TransportIndia</title>
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

  .container { max-width:1000px; margin:0 auto; padding:3rem 1.5rem; }
  h1 { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:2rem; }
  h1 span { color:var(--gold); }

  /* SEARCH FORM */
  .search-box { background:rgba(255,255,255,0.04); border:1px solid rgba(240,165,0,0.2);
                border-radius:12px; padding:2rem; margin-bottom:2.5rem; }
  .search-grid { display:grid; grid-template-columns:1fr 1fr 1fr 1fr auto; gap:1rem; align-items:end; }
  .field label { display:block; font-size:0.72rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem; }
  .field select, .field input {
    width:100%; padding:0.75rem 1rem; background:rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.12); border-radius:6px; color:var(--white);
    font-family:'DM Sans',sans-serif; font-size:0.9rem; outline:none; transition:border-color 0.2s; }
  .field select:focus, .field input:focus { border-color:var(--gold); }
  .field select option { background:var(--navy); }
  .btn-search { background:var(--gold); color:var(--navy); border:none;
                padding:0.78rem 1.6rem; border-radius:6px; font-weight:700;
                font-size:0.95rem; cursor:pointer; white-space:nowrap; }
  .btn-search:hover { opacity:0.9; }

  /* ERROR */
  .error { background:rgba(230,57,70,0.12); border:1px solid rgba(230,57,70,0.3);
           color:#ff6b78; padding:0.8rem 1rem; border-radius:7px; margin-bottom:1.5rem; }

  /* RESULTS */
  .results-title { font-size:0.8rem; letter-spacing:2px; text-transform:uppercase;
                   color:var(--gold); margin-bottom:1rem; }
  .result-card { background:var(--card); border:1px solid rgba(255,255,255,0.08);
                 border-radius:10px; padding:1.5rem; margin-bottom:1rem;
                 display:flex; justify-content:space-between; align-items:center;
                 transition:border-color 0.2s; }
  .result-card:hover { border-color:rgba(240,165,0,0.3); }
  .vehicle-info h3 { font-size:1.05rem; margin-bottom:0.3rem; }
  .vehicle-info .meta { font-size:0.83rem; color:var(--muted); }
  .vehicle-info .route { display:flex; align-items:center; gap:0.5rem;
                         font-size:0.9rem; margin-top:0.5rem; }
  .vehicle-info .route span { color:var(--gold); }
  .vehicle-right { text-align:right; }
  .price { font-family:'Playfair Display',serif; font-size:1.6rem; color:var(--gold); }
  .price-sub { font-size:0.78rem; color:var(--muted); margin-bottom:0.8rem; }
  .seats-badge { font-size:0.75rem; color:#4ade80; margin-bottom:0.8rem; }
  .btn-book { background:var(--gold); color:var(--navy); border:none;
              padding:0.55rem 1.3rem; border-radius:5px; font-weight:700;
              font-size:0.88rem; cursor:pointer; text-decoration:none; display:inline-block; }
  .btn-book:hover { opacity:0.88; }
  .no-results { text-align:center; padding:3rem; color:var(--muted); }
  .no-results .icon { font-size:3rem; margin-bottom:1rem; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div class="nav-links">
    <c:choose>
      <c:when test="${not empty sessionScope.user}">
        <a href="profile">Profile</a>
        <a href="booking">My Bookings</a>
        <a href="logout">Logout</a>
      </c:when>
      <c:otherwise>
        <a href="login">Login</a>
        <a href="register">Register</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

<div class="container">
  <h1>Find Your <span>Journey</span></h1>

  <div class="search-box">
    <form action="search" method="post">
      <div class="search-grid">
        <div class="field">
          <label>Transport Type</label>
          <select name="type">
            <option value="flight" ${type=='flight'?'selected':''}>✈ Flight</option>
            <option value="train"  ${type=='train' ?'selected':''}>🚆 Train</option>
            <option value="bus"    ${type=='bus'   ?'selected':''}>🚌 Bus</option>
            <option value="ship"   ${type=='ship'  ?'selected':''}>🚢 Ship</option>
          </select>
        </div>
        <div class="field">
          <label>From</label>
          <input type="text" name="source" value="${source}" placeholder="Departure city" required>
        </div>
        <div class="field">
          <label>To</label>
          <input type="text" name="destination" value="${destination}" placeholder="Arrival city" required>
        </div>
        <div class="field">
          <label>Date</label>
          <input type="date" name="date" value="${date}">
        </div>
        <button type="submit" class="btn-search">Search</button>
      </div>
    </form>
  </div>

  <c:if test="${not empty error}">
    <div class="error">${error}</div>
  </c:if>

  <c:if test="${not empty results}">
    <div class="results-title">${results.size()} result(s) found for ${source} → ${destination}</div>
    <c:forEach var="v" items="${results}">
      <div class="result-card">
        <div class="vehicle-info">
          <h3>${v.name} <span style="color:var(--muted);font-size:0.85rem;">#${v.number}</span></h3>
          <div class="meta">${type} &nbsp;•&nbsp; ${v.departureTime} → ${v.arrivalTime}</div>
          <div class="route">${v.source} <span>→</span> ${v.destination}</div>
        </div>
        <div class="vehicle-right">
          <div class="price">₹<fmt:formatNumber value="${v.price}" maxFractionDigits="0"/></div>
          <div class="price-sub">per seat</div>
          <div class="seats-badge">✓ ${v.availableSeats} seats available</div>
          <a href="booking?action=view&vehicleId=${v.id}&type=${type}&date=${date}" class="btn-book">Book Now</a>
        </div>
      </div>
    </c:forEach>
  </c:if>

  <c:if test="${empty results && not empty source}">
    <div class="no-results">
      <div class="icon">🔍</div>
      <p>No ${type}s found from <strong>${source}</strong> to <strong>${destination}</strong>.</p>
      <p style="margin-top:0.5rem;font-size:0.85rem;">Try a different route or transport type.</p>
    </div>
  </c:if>
</div>
</body>
</html>
