/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ProgressDAO;

/**
 *
 * @author Admin
 */
public class ProgressService {

    private final ProgressDAO progressDAO = new ProgressDAO();

    public void createFirstProgressIfNeeded(int studentId, int moduleItemId) {
        progressDAO.createFirstProgress(studentId, moduleItemId);
    }

    public boolean updateReadingCompletedProgress(int studentId, int moduleItemId) {
        return progressDAO.updateReadingCompletedProgress(studentId, moduleItemId);
    }

    public boolean updateDiscussionCompletedProgress(int studentId, int moduleItemId) {
        return progressDAO.updateDiscussionCompletedProgress(studentId, moduleItemId);
    }

    public boolean markVideoWatched(int studentId, int moduleItemId) {
        return progressDAO.markVideoWatched(studentId, moduleItemId);
    }

    public boolean hasWatchedVideo(int studentId, int moduleItemId) {
        return progressDAO.hasWatchedVideo(studentId, moduleItemId);
    }

    public boolean markLessonVideoCompleted(int studentId, int moduleItemId) {
        return progressDAO.markLessonVideoCompleted(studentId, moduleItemId);
    }

    public boolean isLessonCompleted(int studentId, int moduleItemId) {
        return progressDAO.isLessonCompleted(studentId, moduleItemId);
    }

}
