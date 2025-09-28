<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Teacher Dashboard | LinguaTrack LMS</title>
  <link rel="stylesheet" href="css/styles.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <style>
    .stats { display:grid; grid-template-columns: repeat(4, minmax(0,1fr)); gap:12px; }
    .stats .card { display:flex; align-items:center; justify-content:space-between; padding:16px; }
    .stat-value { font-size:22px; font-weight:700; }
    .stat-label { color:var(--muted, #6b7280); font-size:14px; }
    .quick-actions { display:flex; gap:12px; flex-wrap:wrap; }
    .quick-actions .btn { display:inline-flex; align-items:center; gap:8px; }
    .two-col { display:grid; grid-template-columns: 2fr 1fr; gap:12px; }
    @media (max-width: 1000px){ .two-col { grid-template-columns: 1fr; } .stats{ grid-template-columns: repeat(2, minmax(0,1fr)); } }
    @media (max-width: 560px){ .stats{ grid-template-columns: 1fr; } }
    .badge { display:inline-block; padding:4px 8px; border-radius:999px; font-size:12px; }
    .badge.green { background:#e8f5e9; color:#2e7d32; }
    .badge.gray { background:#eceff1; color:#455a64; }
    .list { display:flex; flex-direction:column; gap:10px; }
    .list-item { display:flex; align-items:center; justify-content:space-between; gap:12px; }
  </style>
</head>
<body>
  <header class="header">
    <div class="container navbar">
      <a class="brand" href="../index.html"><div class="logo"></div><span>LinguaTrack</span></a>
      <button class="hamburger btn ghost">☰</button>
    </div>
  </header>

  <main class="container admin-layout">
      <jsp:include page="sidebar.jsp" />

    <section>
      <div class="page-title" style="display:flex; align-items:center; justify-content:space-between; gap:12px;">
        <h2>Teacher Dashboard</h2>
       
      </div>

      <div class="stats">
        <div class="card">
          <div>
            <div class="stat-value">${courseCount}</div>
            <div class="stat-label">Khóa học</div>
          </div>
          <i class="fa-solid fa-book-open" style="font-size:24px; color:#1769aa;"></i>
        </div>
        <div class="card">
          <div>
            <div class="stat-value">${studentCount}</div>
            <div class="stat-label">Học viên đang học</div>
          </div>
          <i class="fa-solid fa-user-graduate" style="font-size:24px; color:#16a34a;"></i>
        </div>
      </div>
    </section>
  </main>

  
</body>
</html>


