package service;

import dal.QuestionManagerDAO;
import java.util.ArrayList;
import java.util.List;
import model.dto.QuestionListItemDTO;
import model.entity.Users;
import util.YouTubeApiClient;

public class QuestionManagerService {

    private final QuestionManagerDAO dao;

    public QuestionManagerService() {
        this.dao = new QuestionManagerDAO();
    }

    public List<QuestionListItemDTO> getFilteredQuestions(String status, String keyword, String instructor, String type) {
        if (status == null || status.isBlank()) {
            status = "all";
        }
        if (keyword == null) {
            keyword = "";
        }
        if (instructor == null) {
            instructor = "";
        }
        if (type == null || type.isBlank()) {
            type = "all";
        }

        return dao.getFilteredQuestions(status, keyword, instructor, type);
    }

    public QuestionListItemDTO getQuestionDetail(int questionId) {
        if (questionId <= 0) {
            return null;
        }
        QuestionListItemDTO q = dao.getQuestionDetail(questionId);

        if (q != null && q.getMediaUrl() != null) {
            String url = q.getMediaUrl();

            if (url.contains("youtube.com") || url.contains("youtu.be")) {
                String embedUrl = YouTubeApiClient.toEmbedUrl(url);
                q.setMediaUrl(embedUrl);
            } else if (url.contains("watch?v=")) {
                q.setMediaUrl(url.replace("watch?v=", "embed/"));
            }
        }
        return q;
    }

    public void handleManagerAction(String action, String[] questionIds, String reason, Users manager) {
        if (action == null || action.trim().isEmpty() || questionIds == null || questionIds.length == 0) {
            return;
        }

        switch (action) {
            case "approve":
            case "bulkApprove":
                approveQuestions(questionIds);
                break;

            case "reject":
            case "bulkReject":
                rejectQuestions(questionIds, reason);
                break;

            case "archive":
                archiveQuestions(questionIds);
                break;

            case "restore":
                approveQuestions(questionIds);
                break;

            default:
                break;
        }
    }

    private void approveQuestions(String[] ids) {
        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr);
                dao.updateQuestionStatus(id, "approved");
            } catch (Exception ignored) {
            }
        }
    }

    private void rejectQuestions(String[] ids, String reason) {
        if (reason == null || reason.trim().isEmpty()) {
            return;
        }

        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr);
                dao.rejectQuestionWithReason(id, reason);
            } catch (Exception ignored) {
            }
        }
    }

    private void archiveQuestions(String[] ids) {
        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr);
                dao.updateQuestionStatus(id, "archived");
            } catch (Exception ignored) {
            }
        }
    }
    
   public List<String> searchInstructorNames(String keyword) {

    if (keyword == null || keyword.trim().isEmpty()) {
        return new ArrayList<>(); 
    }

    keyword = keyword.trim();

    if (!keyword.matches("^[\\p{L}\\s]+$")) {
        return new ArrayList<>();
    }

    return dao.findInstructorNames(keyword);
}
}
