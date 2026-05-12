<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Register — TransportIndia</title>
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
  nav a { color:rgba(255,255,255,0.7); text-decoration:none; font-size:0.9rem; }

  .page { flex:1; display:flex; justify-content:center; align-items:center; padding:3rem 1rem; }
  .card { background:rgba(255,255,255,0.04); border:1px solid rgba(240,165,0,0.2);
          border-radius:14px; padding:3rem; width:100%; max-width:440px; }
  .card-title { font-family:'Playfair Display',serif; font-size:2rem; margin-bottom:0.4rem; }
  .card-sub { color:var(--muted); font-size:0.9rem; margin-bottom:2rem; }

  .field { margin-bottom:1.3rem; }
  .field label { display:block; font-size:0.75rem; color:var(--muted);
                 text-transform:uppercase; letter-spacing:1px; margin-bottom:0.5rem; }
  .field input { width:100%; padding:0.8rem 1rem; background:rgba(255,255,255,0.07);
                 border:1px solid rgba(255,255,255,0.12); border-radius:7px;
                 color:var(--white); font-family:'DM Sans',sans-serif; font-size:0.95rem;
                 outline:none; transition:border-color 0.2s; }
  .field input:focus { border-color:var(--gold); }
  .field input::placeholder { color:rgba(255,255,255,0.25); }

  .btn { width:100%; padding:0.9rem; background:var(--gold); color:var(--navy);
         border:none; border-radius:7px; font-weight:700; font-size:1rem;
         cursor:pointer; margin-top:0.5rem; transition:box-shadow 0.2s; }
  .btn:hover { box-shadow:0 6px 20px rgba(240,165,0,0.35); }

  .error { background:rgba(230,57,70,0.15); border:1px solid rgba(230,57,70,0.4);
           color:#ff6b78; padding:0.8rem 1rem; border-radius:7px; font-size:0.88rem; margin-bottom:1.2rem; }
  .footer-link { text-align:center; margin-top:1.5rem; font-size:0.88rem; color:var(--muted); }
  .footer-link a { color:var(--gold); text-decoration:none; }
</style>
</head>
<body>
<nav>
  <a href="index.jsp" class="logo">Transport<span>India</span></a>
  <a href="login">Login</a>
</nav>
<div class="page">
  <div class="card">
    <div class="card-title">Create Account</div>
    <div class="card-sub">Join TransportIndia and start booking</div>

    <% if(request.getAttribute("error") != null) { %>
      <div class="error">${error}</div>
    <% } %>

    <form action="register" method="post">
      <div class="field">
        <label>Username</label>
        <input type="text" name="username" placeholder="Choose a username" required>
      </div>
      <div class="field">
        <label>Email</label>
        <input type="email" name="email" placeholder="your@email.com" required>
      </div>
      <div class="field">
        <label>Phone</label>
        <input type="tel" name="phone" placeholder="10-digit mobile number">
      </div>
      <div class="field">
        <label>Password</label>
        <input type="password" name="password" placeholder="Create a password" required>
      </div>
      <button type="submit" class="btn">Create Account →</button>
    </form>
    <div class="footer-link">Already have an account? <a href="login">Login here</a></div>
  </div>
</div>
</body>
</html>
