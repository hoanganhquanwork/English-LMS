<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Đặt currentPage để làm nổi bật menu "Tiến độ học tập"
    request.setAttribute("currentPage", "progress");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Tiến độ học tập | LinguaTrack</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/parent_link_approval.css" />
    </head>
    <body>
        <%@ include file="parent_header.jsp" %>

        <main class="container">
            <div class="page-title">
                <h2>Tiến độ học tập của con</h2>
                <p class="lead">Theo dõi chi tiết quá trình học tập và thành tích của con em.</p>
            </div>

            <!-- Child Selector -->
            <div class="child-selector">
                <label>Chọn con để xem tiến độ:</label>
                <select id="childSelect" class="input" onchange="switchChild()">
                    <option value="an">Nguyễn Văn An (12 tuổi)</option>
                    <option value="ly">Nguyễn Thị Ly (15 tuổi)</option>
                    <option value="bao">Nguyễn Văn Bảo (10 tuổi)</option>
                </select>
            </div>

            <!-- Progress Overview -->
            <div class="progress-overview">
                <div class="overview-card">
                    <div class="card-icon">📚</div>
                    <div class="card-content">
                        <h3>3</h3>
                        <p>Khóa học đang học</p>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">⏱️</div>
                    <div class="card-content">
                        <h3>24h</h3>
                        <p>Tổng thời gian học</p>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">🎯</div>
                    <div class="card-content">
                        <h3>85%</h3>
                        <p>Tiến độ trung bình</p>
                    </div>
                </div>
                <div class="overview-card">
                    <div class="card-icon">🏆</div>
                    <div class="card-content">
                        <h3>2</h3>
                        <p>Chứng chỉ đã đạt</p>
                    </div>
                </div>
            </div>

            <!-- Course Progress -->
            <section class="progress-section">
                <h3>Tiến độ từng khóa học</h3>

                <div class="course-progress-list">
                    <div class="course-progress-item">
                        <div class="course-header">
                            <div class="course-info">
                                <h4>IELTS 6.5+ Intensive</h4>
                                <p class="course-meta">Bắt đầu: 15/01/2025 • Giáo viên: Ms. Sarah Johnson</p>
                            </div>
                            <span class="status-badge pending">Đang học</span>
                        </div>

                        <div class="progress-stats">
                            <div class="stat-item">
                                <span class="stat-label">Tiến độ tổng</span>
                                <div class="progress-bar">
                                    <div class="progress-fill" style="width: 75%"></div>
                                </div>
                                <span class="stat-value">75%</span>
                            </div>

                            <div class="stat-item">
                                <span class="stat-label">Bài học hoàn thành</span>
                                <span class="stat-value">12/16</span>
                            </div>

                            <div class="stat-item">
                                <span class="stat-label">Quiz đã làm</span>
                                <span class="stat-value">8/12</span>
                            </div>

                            <div class="stat-item">
                                <span class="stat-label">Điểm trung bình</span>
                                <span class="stat-value">8.5/10</span>
                            </div>
                        </div>

                        <div class="recent-activities">
                            <h5>Hoạt động gần đây</h5>
                            <div class="activity-list">
                                <div class="activity-item">
                                    <span class="activity-time">2h trước</span>
                                    <span class="activity-desc">Hoàn thành bài học "Speaking Part 2"</span>
                                    <span class="activity-score">9/10</span>
                                </div>
                                <div class="activity-item">
                                    <span class="activity-time">1 ngày trước</span>
                                    <span class="activity-desc">Làm quiz "Grammar Review"</span>
                                    <span class="activity-score">8/10</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="course-progress-item">
                        <div class="course-header">
                            <div class="course-info">
                                <h4>Tiếng Anh cơ bản A1-A2</h4>
                                <p class="course-meta">Bắt đầu: 10/12/2024 • Giáo viên: Ms. Linda Smith</p>
                            </div>
                            <span class="status-badge active">Hoàn thành</span>
                        </div>

                        <div class="progress-stats">
                            <div class="stat-item">
                                <span class="stat-label">Tiến độ tổng</span>
                                <div class="progress-bar">
                                    <div class="progress-fill completed" style="width: 100%"></div>
                                </div>
                                <span class="stat-value">100%</span>
                            </div>

                            <div class="stat-item">
                                <span class="stat-label">Điểm cuối khóa</span>
                                <span class="stat-value">9.2/10</span>
                            </div>

                            <div class="stat-item">
                                <span class="stat-label">Chứng chỉ</span>
                                <span class="stat-value">✓ Đã nhận</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Learning Analytics -->
            <section class="analytics-section">
                <h3>Phân tích học tập</h3>

                <div class="analytics-grid">
                    <div class="analytics-card">
                        <h4>Thời gian học theo tuần</h4>
                        <div class="chart-placeholder">
                            <div class="chart-bars">
                                <div class="chart-bar" style="height: 60%"><span>T2</span></div>
                                <div class="chart-bar" style="height: 80%"><span>T3</span></div>
                                <div class="chart-bar" style="height: 40%"><span>T4</span></div>
                                <div class="chart-bar" style="height: 90%"><span>T5</span></div>
                                <div class="chart-bar" style="height: 70%"><span>T6</span></div>
                                <div class="chart-bar" style="height: 30%"><span>T7</span></div>
                                <div class="chart-bar" style="height: 20%"><span>CN</span></div>
                            </div>
                        </div>
                    </div>

                    <div class="analytics-card">
                        <h4>Điểm số theo kỹ năng</h4>
                        <div class="skill-scores">
                            <div class="skill-item">
                                <span class="skill-name">Listening</span>
                                <div class="skill-bar">
                                    <div class="skill-fill" style="width: 85%"></div>
                                </div>
                                <span class="skill-score">8.5</span>
                            </div>
                            <div class="skill-item">
                                <span class="skill-name">Reading</span>
                                <div class="skill-bar">
                                    <div class="skill-fill" style="width: 90%"></div>
                                </div>
                                <span class="skill-score">9.0</span>
                            </div>
                            <div class="skill-item">
                                <span class="skill-name">Writing</span>
                                <div class="skill-bar">
                                    <div class="skill-fill" style="width: 75%"></div>
                                </div>
                                <span class="skill-score">7.5</span>
                            </div>
                            <div class="skill-item">
                                <span class="skill-name">Speaking</span>
                                <div class="skill-bar">
                                    <div class="skill-fill" style="width: 80%"></div>
                                </div>
                                <span class="skill-score">8.0</span>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

          
            </section>
        </main>

        <jsp:include page="/footer.jsp" />

       
    </body>
    </html>


