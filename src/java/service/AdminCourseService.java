package service;

import dal.AdminCourseDAO;

public class AdminCourseService {
    private final AdminCourseDAO dao = new AdminCourseDAO();
    public int countActiveCourses() { return dao.countActiveCourses(); }
}
