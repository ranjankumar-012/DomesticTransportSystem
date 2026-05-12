<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Book — TransportIndia</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap');
  :root { --navy:#0a1628; --gold:#f0a500; --muted:#6b7a99; --white:#ffffff; }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white); min-height:100vh; }
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; border-bottom:1px solid rgba(240,165,0,0.2); }
  .logo { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); text-decoration:none; }
  .logo span { color:var(--white); }
  nav a { color:rgba(255,255,255,0.7); text-decoration:none; margin-left:1.5rem; font-size:0.9rem; }

  .container { max-width:700px; margin:0 auto; padding:3rem 1.5rem; }
  h1 { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:2rem; }
  h1 span { color:var(--gold); }

  /* VEHICLE SUMMARY */
  .vehicle-summary { background:rgba(240,165,0,0.08); border:1px solid rgba(240,165,0,0.25);
                     border-radius:10px; padding:1.5rem; margin-bottom:2rem; }
  .vs-row { display:flex; justify-content:space-between; align-items:center; }
  .vs-name { font-family:'Playfair Display',serif; font-size:1.3rem; }
  .vs-type { font-size:0.75rem; letter-spacing:2px; color:var(--gold); text-transform:uppercase; }
  .vs-route { display:flex; align-items:center; gap:0.8rem; margin-top:0.8rem; font-size:0.95rem; }
  .vs-route span { color:var(--gold); font-size:1.2rem; }
  .vs-meta { margin-top:0.6rem; font-size:0.83rem; color:var(--muted); }
  .vs-price { font-family:'Playfair Display',serif; font-size:1.8rem; color:var(--gold); }
  .vs-price-label { font-size:0.75rem; color:var(--muted); }

  /* FORM */
  .card { background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08);
          border-radius:12px; padding:2rem; }
  .field { margin-bottom:1.3rem; }
  .field label { display:block; font-size:0.73rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem; }
  .field input, .field select {
    width:100%; padding:0.8rem 1rem; background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.12); border-radius:7px; color:var(--white);
    font-family:'DM Sans',sans-serif; font-size:0.95rem; outline:none; }
  .field input:focus, .field select:focus { border-color:var(--gold); }
  .field select option { background:var(--navy); }

  /* PRICE PREVIEW */
  .price-preview { background:rgba(240,165,0,0.06); border:1px solid rgba(240,165,0,0.2);
                   border-radius:8px; padding:1rem 1.2rem; margin-bottom:1.5rem; display:flex;
                   justify-content:space-between; align-items:center; }
  .price-preview .label { font-size:0.85rem; color:var(--muted); }
  .price-preview .total { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); }

  .btn { width:100%; padding:0.9rem; background:var(--gold); color:var(--navy);
         border:none; border-radius:7px; font-weight:700; font-size:1rem; cursor:pointer; }
  .btn:hover { opacity:0.9; }
  .error { background:rgba(230,57,70,0.12); border:1px solid rgba(230,57,70,0.3);
           color:#ff6b78; padding:0.8rem 1rem; border-radius:7px; margin-bottom:1.2rem; font-size:0.88rem; }
  .back { display:inline-block; margin-bottom:1.5rem; color:var(--muted); text-decoration:none; font-size:0.88rem; }
  .back:hover { color:var(--gold); }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div>
    <a href="search">Search</a>
    <a href="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <a href="javascript:history.back()" class="back">← Back to results</a>
  <h1>Confirm <span>Booking</span></h1>

  <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

  <c:if test="${not empty vehicle}">
    <div class="vehicle-summary">
      <div class="vs-row">
        <div>
          <div class="vs-type">${vehicle.type}</div>
          <div class="vs-name">${vehicle.name}</div>
          <div class="vs-route">
            ${vehicle.source} <span>→</span> ${vehicle.destination}
          </div>
          <div class="vs-meta">
            Departs: ${vehicle.departureTime} &nbsp;|&nbsp; Arrives: ${vehicle.arrivalTime}
            &nbsp;|&nbsp; Available: ${vehicle.availableSeats} seats
          </div>
        </div>
        <div style="text-align:right">
          <div class="vs-price-label">Price per seat</div>
          <div class="vs-price">₹<fmt:formatNumber value="${vehicle.price}" maxFractionDigits="0"/></div>
        </div>
      </div>
    </div>

    <div class="card">
      <form action="booking" method="post" id="bookForm">
        <input type="hidden" name="vehicleId" value="${vehicle.id}">
        <input type="hidden" name="type" value="${vehicle.type}">
        <input type="hidden" name="source" value="${vehicle.source}">
        <input type="hidden" name="destination" value="${vehicle.destination}">
        <input type="hidden" name="price" value="${vehicle.price}" id="unitPrice">

        <div class="field">
          <label>Journey Date</label>
          <input type="date" name="date" value="${date}" required>
        </div>
        <div class="field">
          <label>Number of Seats</label>
          <select name="seats" id="seatsSelect" onchange="updateTotal()">
            <c:forEach begin="1" end="6" var="i">
              <option value="${i}">${i} seat${i>1?'s':''}</option>
            </c:forEach>
          </select>
        </div>

        <div class="price-preview">
          <div class="label">Total Amount</div>
          <div class="total" id="totalDisplay">₹<fmt:formatNumber value="${vehicle.price}" maxFractionDigits="0"/></div>
        </div>

        <button type="submit" class="btn">Proceed to Payment →</button>
      </form>
    </div>
  </c:if>
</div>

<script>
  const unitPrice = parseFloat(document.getElementById('unitPrice').value);
  function updateTotal() {
    const seats = parseInt(document.getElementById('seatsSelect').value);
    const total = (unitPrice * seats).toLocaleString('en-IN', {maximumFractionDigits:0});
    document.getElementById('totalDisplay').textContent = '₹' + total;
  }
</script>
</body>
</html>
