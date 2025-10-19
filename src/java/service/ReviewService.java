/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.CourseDAO;
import dal.ReviewDAO;
import java.util.List;
import model.dto.RatingSummaryDTO;
import model.dto.ReviewDTO;

/**
 *
 * @author Admin
 */
public class ReviewService {

    ReviewDAO rdao = new ReviewDAO();
    CourseDAO cdao = new CourseDAO();

    public RatingSummaryDTO getRatingSummary(int courseId) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId không hợp lệ");
        }
        return rdao.getRatingSummary(courseId);
    }

    public int countByStars(int courseId, Integer star, String keyword) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId không hợp lệ");
        }
        return rdao.countByStars(courseId, star, keyword);
    }

    public List<ReviewDTO> getListReviewByStar(int courseId, Integer star, String keyword, int page, int pageSize) {
        if (courseId <= 0) {
            throw new IllegalArgumentException("courseId phải > 0");
        }
        if (page <= 0) {
            page = 1;
        }
        if (pageSize <= 0) {
            pageSize = 5;
        }
        return rdao.getListReviewByStar(courseId, star, keyword, page, pageSize);
    }

    public Integer findMyPageReview(int studentId, int courseId, int pageSize) {
        if (pageSize <= 0) {
            pageSize = 5;
        }

        List<ReviewDTO> list = rdao.getAllReviews(courseId);
        ReviewDTO myReview = rdao.getReviewByCourseAndStudent(courseId, studentId);
        if (myReview == null) {
            return null;
        }
        int pageIndex = -1;
        for (int i = 0; i < list.size(); i++) {
            if (myReview.getReviewId() == list.get(i).getReviewId()) {
                pageIndex = i;
                break;
            }
        }
        if (pageIndex == -1) {
            pageIndex = 1;
        }
        return (pageIndex / pageSize) + 1;
    }

    public boolean canCreateReview(int studentId, int courseId) {
        if (studentId <= 0 || courseId <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        boolean completed = cdao.isCompletedEnrollment(studentId, courseId);
        if (!completed) {
            return false;
        }
        return !rdao.existsReview(courseId, studentId);
    }

    public boolean existsReview(int studentId, int courseId) {
        if (studentId <= 0 || courseId <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        return rdao.existsReview(courseId, studentId);
    }

    public boolean createReviewIfAllowed(int courseId, int studentId, int rating, String comment) {
        if (courseId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        if (!canCreateReview(studentId, courseId)) {
            return false;
        }
        return rdao.insertReview(courseId, studentId, rating, comment);
    }

    public boolean editMyReview(int courseId, int studentId, int rating, String comment) {
        if (courseId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("ID không hợp lệ");
        }
        if (!rdao.existsReview(courseId, studentId)) {
            return false;
        }
        return rdao.updateReview(courseId, studentId, rating, comment);
    }
}
