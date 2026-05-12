<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Panel — TransportIndia</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=DM+Sans:wght@300;400;500&display=swap');
  :root { --navy:#0a1628; --gold:#f0a500; --muted:#6b7a99; --white:#ffffff; --card:#0d1f3c; --red:#e63946; }
  * { margin:0; padding:0; box-sizing:border-box; }
  body { font-family:'DM Sans',sans-serif; background:var(--navy); color:var(--white); min-height:100vh; }
  nav { display:flex; justify-content:space-between; align-items:center;
        padding:1.2rem 3rem; border-bottom:1px solid rgba(240,165,0,0.2); }
  .logo { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--gold); text-decoration:none; }
  .logo span { color:var(--white); }
  .nav-right { display:flex; align-items:center; gap:1.5rem; font-size:0.88rem; }
  .nav-right a { color:rgba(255,255,255,0.7); text-decoration:none; }
  .nav-right a:hover { color:var(--gold); }
  .admin-badge { background:rgba(240,165,0,0.15); color:var(--gold); padding:0.3rem 0.8rem;
                 border-radius:20px; font-size:0.75rem; letter-spacing:1px; }

  .container { max-width:1100px; margin:0 auto; padding:2.5rem 1.5rem; }
  .page-title { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:0.3rem; }
  .page-title span { color:var(--gold); }
  .page-sub { color:var(--muted); font-size:0.88rem; margin-bottom:2rem; }

  /* TABS */
  .tabs { display:flex; gap:0; border-bottom:1px solid rgba(255,255,255,0.1); margin-bottom:2rem; }
  .tab { padding:0.7rem 1.8rem; font-size:0.88rem; cursor:pointer; color:var(--muted);
         border-bottom:2px solid transparent; text-decoration:none; transition:all 0.2s; }
  .tab:hover { color:var(--white); }
  .tab.active { color:var(--gold); border-bottom-color:var(--gold); }

  /* TABLE */
  .table-wrap { overflow-x:auto; }
  table { width:100%; border-collapse:collapse; font-size:0.85rem; }
  th { text-align:left; padding:0.75rem 1rem; font-size:0.72rem; letter-spacing:1px;
       text-transform:uppercase; color:var(--muted);
       border-bottom:1px solid rgba(255,255,255,0.08); }
  td { padding:0.85rem 1rem; border-bottom:1px solid rgba(255,255,255,0.05); vertical-align:middle; }
  tr:hover td { background:rgba(255,255,255,0.02); }
  .badge { display:inline-block; padding:0.2rem 0.6rem; border-radius:20px;
           font-size:0.72rem; font-weight:700; text-transform:uppercase; }
  .badge.confirmed { background:rgba(34,197,94,0.15); color:#4ade80; }
  .badge.cancelled  { background:rgba(230,57,70,0.15); color:#ff6b78; }
  .badge.flight  { background:rgba(99,179,237,0.15); color:#63b3ed; }
  .badge.train   { background:rgba(154,230,180,0.15); color:#9ae6b4; }
  .badge.bus     { background:rgba(252,196,25,0.15); color:#fcc419; }
  .badge.ship    { background:rgba(183,148,244,0.15); color:#b794f4; }

  .btn-sm { padding:0.35rem 0.8rem; border-radius:5px; font-size:0.78rem;
            font-weight:600; cursor:pointer; border:none; text-decoration:none; display:inline-block; }
  .btn-edit { background:rgba(240,165,0,0.15); color:var(--gold); border:1px solid rgba(240,165,0,0.3); }
  .btn-edit:hover { background:rgba(240,165,0,0.25); }
  .btn-del  { background:rgba(230,57,70,0.12); color:#ff6b78; border:1px solid rgba(230,57,70,0.3); margin-left:0.4rem; }
  .btn-del:hover { background:rgba(230,57,70,0.22); }

  /* ADD/EDIT VEHICLE FORM */
  .form-section { background:rgba(255,255,255,0.04); border:1px solid rgba(240,165,0,0.2);
                  border-radius:12px; padding:2rem; margin-bottom:2rem; }
  .form-section h3 { font-size:1rem; margin-bottom:1.5rem; color:var(--gold); }
  .form-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(180px,1fr)); gap:1rem; }
  .field label { display:block; font-size:0.7rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.4rem; }
  .field input, .field select {
    width:100%; padding:0.65rem 0.9rem; background:rgba(255,255,255,0.07);
    border:1px solid rgba(255,255,255,0.12); border-radius:6px; color:var(--white);
    font-family:'DM Sans',sans-serif; font-size:0.88rem; outline:none; }
  .field input:focus, .field select:focus { border-color:var(--gold); }
  .field select option { background:var(--navy); }
  .btn-add { background:var(--gold); color:var(--navy); border:none;
             padding:0.65rem 1.6rem; border-radius:6px; font-weight:700;
             font-size:0.9rem; cursor:pointer; margin-top:1rem; }

  .msg { padding:0.7rem 1rem; border-radius:7px; font-size:0.85rem; margin-bottom:1rem; }
  .msg.added   { background:rgba(34,197,94,0.1); border:1px solid rgba(34,197,94,0.3); color:#4ade80; }
  .msg.updated { background:rgba(99,179,237,0.1); border:1px solid rgba(99,179,237,0.3); color:#63b3ed; }
  .empty-msg { color:var(--muted); padding:2rem; text-align:center; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <div class="nav-right">
    <span class="admin-badge">ADMIN</span>
    <a href="index.jsp">Home</a>
    <a href="logout">Logout</a>
  </div>
</nav>

<div class="container">
  <div class="page-title">Admin <span>Dashboard</span></div>
  <div class="page-sub">Manage bookings and transport vehicles</div>

  <c:if test="${param.msg == 'added'}">  <div class="msg added">Vehicle added successfully.</div></c:if>
  <c:if test="${param.msg == 'updated'}"><div class="msg updated">Vehicle updated successfully.</div></c:if>

  <!-- TABS -->
  <div class="tabs">
    <a href="admin?tab=bookings" class="tab ${tab=='bookings'?'active':''}">All Bookings</a>
    <a href="admin?tab=vehicles" class="tab ${tab=='vehicles'?'active':''}">Manage Vehicles</a>
  </div>

  <!-- ===== BOOKINGS TAB ===== -->
  <c:if test="${tab == 'bookings'}">
    <div class="table-wrap">
      <c:choose>
        <c:when test="${empty bookings}">
          <div class="empty-msg">No bookings found.</div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>#ID</th><th>User</th><th>Type</th><th>Route</th>
                <th>Date</th><th>Seats</th><th>Amount</th><th>Status</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="b" items="${bookings}">
                <tr>
                  <td>${b.id}</td>
                  <td>${b.vehicleName}</td>
                  <td><span class="badge ${b.transportType}">${b.transportType}</span></td>
                  <td>${b.source} → ${b.destination}</td>
                  <td>${b.journeyDate}</td>
                  <td>${b.seats}</td>
                  <td>₹<fmt:formatNumber value="${b.totalPrice}" maxFractionDigits="0"/></td>
                  <td><span class="badge ${b.status}">${b.status}</span></td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </c:if>

  <!-- ===== VEHICLES TAB ===== -->
  <c:if test="${tab == 'vehicles'}">

    <!-- ADD / EDIT FORM -->
    <div class="form-section">
      <h3>${not empty editVehicle ? 'Edit Vehicle' : 'Add New Vehicle'}</h3>
      <form action="admin" method="post">
        <input type="hidden" name="action" value="${not empty editVehicle ? 'updateVehicle' : 'addVehicle'}">
        <c:if test="${not empty editVehicle}">
          <input type="hidden" name="id" value="${editVehicle.id}">
        </c:if>
        <div class="form-grid">
          <div class="field">
            <label>Type</label>
            <select name="type">
              <option value="flight" ${editVehicle.type=='flight'?'selected':''}>Flight</option>
              <option value="train"  ${editVehicle.type=='train' ?'selected':''}>Train</option>
              <option value="bus"    ${editVehicle.type=='bus'   ?'selected':''}>Bus</option>
              <option value="ship"   ${editVehicle.type=='ship'  ?'selected':''}>Ship</option>
            </select>
          </div>
          <div class="field">
            <label>Name</label>
            <input type="text" name="name" value="${editVehicle.name}" placeholder="e.g. IndiGo" required>
          </div>
          <div class="field">
            <label>Number</label>
            <input type="text" name="number" value="${editVehicle.number}" placeholder="e.g. 6E-101">
          </div>
          <div class="field">
            <label>Source</label>
            <input type="text" name="source" value="${editVehicle.source}" placeholder="From city" required>
          </div>
          <div class="field">
            <label>Destination</label>
            <input type="text" name="destination" value="${editVehicle.destination}" placeholder="To city" required>
          </div>
          <div class="field">
            <label>Departure</label>
            <input type="text" name="departureTime" value="${editVehicle.departureTime}" placeholder="e.g. 06:00">
          </div>
          <div class="field">
            <label>Arrival</label>
            <input type="text" name="arrivalTime" value="${editVehicle.arrivalTime}" placeholder="e.g. 08:30">
          </div>
          <div class="field">
            <label>Price (₹)</label>
            <input type="number" name="price" value="${editVehicle.price}" placeholder="3500" step="0.01" required>
          </div>
          <div class="field">
            <label>Total Seats</label>
            <input type="number" name="totalSeats" value="${editVehicle.totalSeats}" placeholder="100" required>
          </div>
          <div class="field">
            <label>Available Seats</label>
            <input type="number" name="availableSeats" value="${editVehicle.availableSeats}" placeholder="100" required>
          </div>
        </div>
        <button type="submit" class="btn-add">
          ${not empty editVehicle ? 'Update Vehicle' : '+ Add Vehicle'}
        </button>
      </form>
    </div>

    <!-- VEHICLES TABLE -->
    <div class="table-wrap">
      <c:choose>
        <c:when test="${empty vehicles}">
          <div class="empty-msg">No vehicles found.</div>
        </c:when>
        <c:otherwise>
          <table>
            <thead>
              <tr>
                <th>#</th><th>Type</th><th>Name</th><th>Number</th>
                <th>Route</th><th>Timings</th><th>Price</th><th>Seats</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:forEach var="v" items="${vehicles}">
                <tr>
                  <td>${v.id}</td>
                  <td><span class="badge ${v.type}">${v.type}</span></td>
                  <td>${v.name}</td>
                  <td>${v.number}</td>
                  <td>${v.source} → ${v.destination}</td>
                  <td>${v.departureTime} – ${v.arrivalTime}</td>
                  <td>₹<fmt:formatNumber value="${v.price}" maxFractionDigits="0"/></td>
                  <td>${v.availableSeats}/${v.totalSeats}</td>
                  <td>
                    <a href="admin?action=editVehicle&id=${v.id}&type=${v.type}&tab=vehicles" class="btn-sm btn-edit">Edit</a>
                    <a href="admin?action=deleteVehicle&id=${v.id}&type=${v.type}&tab=vehicles"
                       class="btn-sm btn-del"
                       onclick="return confirm('Delete this vehicle?')">Delete</a>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </c:otherwise>
      </c:choose>
    </div>
  </c:if>

</div>
</body>
</html>
