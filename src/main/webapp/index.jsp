<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TransportIndia — Book Your Journey</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500&display=swap');
  :root {
    --navy: #0a1628; --gold: #f0a500; --cream: #fdf6ec;
    --red: #e63946; --white: #ffffff; --muted: #6b7a99;
  }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white); min-height:100vh; }

  /* NAV */
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; background:rgba(10,22,40,0.95);
        border-bottom:1px solid rgba(240,165,0,0.2); position:sticky; top:0; z-index:100; }
  .logo { font-family:'Playfair Display',serif; font-size:1.6rem; color:var(--gold); letter-spacing:1px; }
  .logo span { color:var(--white); }
  .nav-links a { color:rgba(255,255,255,0.8); text-decoration:none; margin-left:2rem;
                 font-size:0.9rem; font-weight:500; letter-spacing:0.5px;
                 transition:color 0.2s; }
  .nav-links a:hover { color:var(--gold); }
  .btn-nav { background:var(--gold); color:var(--navy) !important;
             padding:0.5rem 1.4rem; border-radius:4px; font-weight:700 !important; }

  /* HERO */
  .hero { min-height:88vh; display:flex; flex-direction:column;
          justify-content:center; align-items:center; text-align:center;
          padding:4rem 2rem;
          background: linear-gradient(160deg, #0a1628 0%, #112240 50%, #0a1628 100%); }
  .hero-tag { font-size:0.8rem; letter-spacing:3px; color:var(--gold);
              text-transform:uppercase; margin-bottom:1.5rem; }
  .hero h1 { font-family:'Playfair Display',serif; font-size:clamp(2.5rem,6vw,5rem);
             line-height:1.1; margin-bottom:1.5rem; max-width:800px; }
  .hero h1 span { color:var(--gold); }
  .hero p { color:rgba(255,255,255,0.6); font-size:1.1rem; max-width:500px; margin-bottom:3rem; }

  /* SEARCH CARD */
  .search-card { background:rgba(255,255,255,0.05); border:1px solid rgba(240,165,0,0.2);
                 border-radius:12px; padding:2rem; width:100%; max-width:700px;
                 backdrop-filter:blur(10px); }
  .search-card h3 { font-size:0.85rem; letter-spacing:2px; text-transform:uppercase;
                    color:var(--gold); margin-bottom:1.5rem; }
  .search-row { display:grid; grid-template-columns:1fr 1fr 1fr auto; gap:1rem; align-items:end; }
  .field label { display:block; font-size:0.75rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem; }
  .field input, .field select {
    width:100%; padding:0.75rem 1rem; background:rgba(255,255,255,0.08);
    border:1px solid rgba(255,255,255,0.15); border-radius:6px; color:var(--white);
    font-family:'DM Sans',sans-serif; font-size:0.95rem; outline:none;
    transition:border-color 0.2s; }
  .field input:focus, .field select:focus { border-color:var(--gold); }
  .field select option { background:var(--navy); }
  .btn-search { background:var(--gold); color:var(--navy); border:none;
                padding:0.78rem 1.8rem; border-radius:6px; font-weight:700;
                font-size:1rem; cursor:pointer; white-space:nowrap;
                transition:transform 0.15s, box-shadow 0.15s; }
  .btn-search:hover { transform:translateY(-2px); box-shadow:0 6px 20px rgba(240,165,0,0.4); }

  /* TRANSPORT ICONS */
  .modes { display:flex; gap:2rem; justify-content:center; margin-top:3rem; flex-wrap:wrap; }
  .mode { display:flex; flex-direction:column; align-items:center; gap:0.5rem;
          cursor:pointer; opacity:0.6; transition:opacity 0.2s; }
  .mode:hover { opacity:1; }
  .mode-icon { font-size:2rem; }
  .mode-label { font-size:0.75rem; letter-spacing:1px; text-transform:uppercase; color:var(--muted); }

  /* FEATURES */
  .features { padding:5rem 3rem; background:#0d1f3c; }
  .features h2 { font-family:'Playfair Display',serif; font-size:2.2rem;
                 text-align:center; margin-bottom:3rem; }
  .features h2 span { color:var(--gold); }
  .feature-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
                  gap:2rem; max-width:1000px; margin:0 auto; }
  .feature-card { background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08);
                  border-radius:10px; padding:2rem; text-align:center; transition:transform 0.2s; }
  .feature-card:hover { transform:translateY(-4px); border-color:rgba(240,165,0,0.3); }
  .feature-icon { font-size:2.5rem; margin-bottom:1rem; }
  .feature-card h4 { font-size:1rem; margin-bottom:0.5rem; }
  .feature-card p { font-size:0.85rem; color:var(--muted); line-height:1.6; }

  /* FOOTER */
  footer { text-align:center; padding:2rem; background:var(--navy);
           color:var(--muted); font-size:0.85rem;
           border-top:1px solid rgba(255,255,255,0.06); }
</style>
</head>
<body>

<nav>
  <div class="logo">Transport<span>India</span></div>
  <div class="nav-links">
    <a href="search">Search</a>
    <c:choose>
      <c:when test="${not empty sessionScope.user}">
        <a href="profile">Profile</a>
        <c:if test="${sessionScope.role == 'admin'}"><a href="admin">Admin</a></c:if>
        <a href="logout">Logout</a>
      </c:when>
      <c:otherwise>
        <a href="login">Login</a>
        <a href="register" class="btn-nav">Register</a>
      </c:otherwise>
    </c:choose>
  </div>
</nav>

<section class="hero">
  <div class="hero-tag">Domestic Travel Made Simple</div>
  <h1>Book Your Journey<br>Across <span>India</span></h1>
  <p>Flights, trains, buses and ships — all in one place. Fast, reliable, affordable.</p>

  <div class="search-card">
    <h3>Quick Search</h3>
    <form action="search" method="post">
      <div class="search-row">
        <div class="field">
          <label>Transport</label>
          <select name="type">
            <option value="flight">✈ Flight</option>
            <option value="train">🚆 Train</option>
            <option value="bus">🚌 Bus</option>
            <option value="ship">🚢 Ship</option>
          </select>
        </div>
        <div class="field">
          <label>From</label>
          <input type="text" name="source" placeholder="e.g. Delhi" required>
        </div>
        <div class="field">
          <label>To</label>
          <input type="text" name="destination" placeholder="e.g. Mumbai" required>
        </div>
        <button type="submit" class="btn-search">Search →</button>
      </div>
    </form>
  </div>

  <div class="modes">
    <div class="mode"><div class="mode-icon">✈</div><div class="mode-label">Flights</div></div>
    <div class="mode"><div class="mode-icon">🚆</div><div class="mode-label">Trains</div></div>
    <div class="mode"><div class="mode-icon">🚌</div><div class="mode-label">Buses</div></div>
    <div class="mode"><div class="mode-icon">🚢</div><div class="mode-label">Ships</div></div>
  </div>
</section>

<section class="features">
  <h2>Why <span>TransportIndia</span>?</h2>
  <div class="feature-grid">
    <div class="feature-card">
      <div class="feature-icon">⚡</div>
      <h4>Instant Booking</h4>
      <p>Book your seat in seconds with real-time availability across all transport types.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">🔒</div>
      <h4>Secure Payments</h4>
      <p>Your transactions are safe with our encrypted payment gateway.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">📋</div>
      <h4>Easy Management</h4>
      <p>View, manage and cancel your bookings anytime from your profile.</p>
    </div>
    <div class="feature-card">
      <div class="feature-icon">🗺</div>
      <h4>Pan-India Coverage</h4>
      <p>Flights, trains, buses and ships covering all major cities across India.</p>
    </div>
  </div>
</section>

<footer>
  &copy; 2026 TransportIndia — Domestic Transport Management System
</footer>

</body>
</html>
