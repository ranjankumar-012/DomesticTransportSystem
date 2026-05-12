<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Payment — TransportIndia</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap');
  :root { --navy:#0a1628; --gold:#f0a500; --muted:#6b7a99; --white:#ffffff; }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white); min-height:100vh; }
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; border-bottom:1px solid rgba(240,165,0,0.2); }
  .logo { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); text-decoration:none; }
  .logo span { color:var(--white); }

  .container { max-width:560px; margin:0 auto; padding:3rem 1.5rem; }
  h1 { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:0.4rem; }
  h1 span { color:var(--gold); }
  .subtitle { color:var(--muted); font-size:0.9rem; margin-bottom:2rem; }

  /* ORDER SUMMARY */
  .summary { background:rgba(240,165,0,0.07); border:1px solid rgba(240,165,0,0.22);
             border-radius:10px; padding:1.4rem; margin-bottom:2rem; }
  .summary-title { font-size:0.72rem; letter-spacing:2px; text-transform:uppercase;
                   color:var(--gold); margin-bottom:1rem; }
  .summary-row { display:flex; justify-content:space-between; font-size:0.88rem;
                 color:rgba(255,255,255,0.75); margin-bottom:0.5rem; }
  .summary-row.total { border-top:1px solid rgba(255,255,255,0.1); padding-top:0.8rem;
                       margin-top:0.5rem; font-weight:600; color:var(--white); font-size:1rem; }
  .summary-row.total .val { font-family:'Playfair Display',serif; color:var(--gold); font-size:1.3rem; }

  /* PAYMENT METHODS */
  .card { background:rgba(255,255,255,0.04); border:1px solid rgba(255,255,255,0.08);
          border-radius:12px; padding:2rem; }
  .method-title { font-size:0.72rem; letter-spacing:2px; text-transform:uppercase;
                  color:var(--muted); margin-bottom:1rem; }
  .method-grid { display:grid; grid-template-columns:1fr 1fr; gap:0.8rem; margin-bottom:1.5rem; }
  .method-option { position:relative; }
  .method-option input[type="radio"] { position:absolute; opacity:0; }
  .method-label { display:flex; flex-direction:column; align-items:center; gap:0.4rem;
                  padding:1rem; background:rgba(255,255,255,0.05);
                  border:1px solid rgba(255,255,255,0.1); border-radius:8px;
                  cursor:pointer; transition:border-color 0.2s, background 0.2s; font-size:0.85rem; }
  .method-option input:checked + .method-label {
    border-color:var(--gold); background:rgba(240,165,0,0.08); }
  .method-icon { font-size:1.5rem; }

  .btn { width:100%; padding:0.9rem; background:var(--gold); color:var(--navy);
         border:none; border-radius:7px; font-weight:700; font-size:1rem; cursor:pointer; }
  .btn:hover { opacity:0.9; }
  .error { background:rgba(230,57,70,0.12); border:1px solid rgba(230,57,70,0.3);
           color:#ff6b78; padding:0.8rem 1rem; border-radius:7px; margin-bottom:1.2rem; font-size:0.88rem; }
  .secure { text-align:center; font-size:0.78rem; color:var(--muted); margin-top:1rem; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
</nav>

<div class="container">
  <h1>Secure <span>Payment</span></h1>
  <div class="subtitle">Complete your booking by paying below</div>

  <c:if test="${not empty error}"><div class="error">${error}</div></c:if>

  <c:if test="${not empty booking}">
    <div class="summary">
      <div class="summary-title">Booking Summary</div>
      <div class="summary-row"><span>Route</span><span>${booking.source} → ${booking.destination}</span></div>
      <div class="summary-row"><span>Type</span><span>${booking.transportType}</span></div>
      <div class="summary-row"><span>Date</span><span>${booking.journeyDate}</span></div>
      <div class="summary-row"><span>Seats</span><span>${booking.seats}</span></div>
      <div class="summary-row total">
        <span>Total</span>
        <span class="val">₹<fmt:formatNumber value="${booking.totalPrice}" maxFractionDigits="0"/></span>
      </div>
    </div>

    <div class="card">
      <form action="payment" method="post">
        <div class="method-title">Select Payment Method</div>
        <div class="method-grid">
          <div class="method-option">
            <input type="radio" name="paymentMethod" id="upi" value="upi" checked>
            <label for="upi" class="method-label">
              <span class="method-icon">📱</span> UPI
            </label>
          </div>
          <div class="method-option">
            <input type="radio" name="paymentMethod" id="card" value="credit_card">
            <label for="card" class="method-label">
              <span class="method-icon">💳</span> Credit Card
            </label>
          </div>
          <div class="method-option">
            <input type="radio" name="paymentMethod" id="debit" value="debit_card">
            <label for="debit" class="method-label">
              <span class="method-icon">🏧</span> Debit Card
            </label>
          </div>
          <div class="method-option">
            <input type="radio" name="paymentMethod" id="netbanking" value="net_banking">
            <label for="netbanking" class="method-label">
              <span class="method-icon">🏦</span> Net Banking
            </label>
          </div>
        </div>
        <button type="submit" class="btn">Pay ₹<fmt:formatNumber value="${booking.totalPrice}" maxFractionDigits="0"/> →</button>
      </form>
      <div class="secure">🔒 Secured & Encrypted Payment</div>
    </div>
  </c:if>
</div>
</body>
</html>
