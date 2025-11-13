/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ModuleDAO;
import dal.ProgressDAO;
import dal.QuestionDAO;
import dal.QuizDAO;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import model.dto.QuestionDTO;
import model.dto.QuizAttemptAnswerDTO;
import model.dto.QuizAttemptDTO;
import model.dto.QuizAttemptQuestionDTO;
import model.dto.QuizDTO;
import dal.ModuleItemDAO;
import java.math.BigDecimal;
import model.entity.ModuleItem;
import model.entity.Quiz;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class QuizService {

    private QuizDAO quizDAO = new QuizDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private ProgressDAO progressDAO = new ProgressDAO();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();
    private ModuleDAO moduleDAO = new ModuleDAO();

    public QuizDTO getQuizById(int quizId) {
        if (quizId <= 0) {
            throw new IllegalArgumentException("Không thể lấy quiz");
        }
        return quizDAO.getQuizById(quizId);
    }

    public List<QuestionDTO> pickRandomQuestions(QuizDTO quiz) {
        if (quiz == null) {
            return Collections.emptyList();
        }
        List<QuestionDTO> bank = quiz.getBank();

        if (bank == null || bank.isEmpty()) {
            return Collections.emptyList();
        }
        List<QuestionDTO> copy = new ArrayList<>(bank);
        Collections.shuffle(copy);
        Integer pick = quiz.getPickCount();
        if (pick != null && pick < copy.size()) {
            return new ArrayList<>(copy.subList(0, pick));
        }
        return copy;
    }

    public int countSubmittedAttempts(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return quizDAO.countSubmittedAttempts(quizId, studentId);
    }

    public Double getBestScore(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Không thể lấy điểm");
        }
        return quizDAO.getBestScoreFromAttempts(quizId, studentId);
    }

    public QuizAttemptDTO findLatestAttempt(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        return quizDAO.findLatestAttempt(quizId, studentId);
    }

    //nếu là draft và quá deadline tự động nộp và chấm
    public void finalizeIfExpired(long attemptId) {
        QuizAttemptDTO a = quizDAO.findQuizAttempById(attemptId);
        if (a == null) {
            return;
        }
        if (!"draft".equalsIgnoreCase(a.getStatus())) {
            return;
        }

        LocalDateTime deadline = a.getDeadlineAt();
        if (deadline == null || LocalDateTime.now().isBefore(deadline)) {
            return;
        }

        quizDAO.markCorrectnessForMCQ(attemptId);
        quizDAO.markCorrectnessForTextUsingKeys(attemptId);

        int[] ct = quizDAO.countCorrectAndTotal(attemptId);
        int correct = ct[0], total = ct[1];
        double scorePct = (total == 0) ? 0.0 : (correct * 100.0 / total);

        int ok = quizDAO.markSubmittedTimeout(attemptId, scorePct);
        if (ok == 1) {
            int quizId = a.getQuizId();
            int studentId = a.getStudentId();

            QuizDTO quiz = quizDAO.getQuizById(quizId);
            if (quiz != null && quiz.getPassingScorePct() != null) {
                double passing = quiz.getPassingScorePct();
                boolean passed = scorePct >= passing;
                progressDAO.updateBestQuizOrAssigmentScore(studentId, quizId, scorePct, passed);
            }
        }
    }

    public QuizAttemptDTO loadAttempt(long attemptId) {
        QuizAttemptDTO attempt = quizDAO.findQuizAttempById(attemptId);
        if (attempt == null) {
            return null;
        }

        finalizeIfExpired(attemptId);
        attempt = quizDAO.findQuizAttempById(attemptId);
        List<QuizAttemptQuestionDTO> qs = quizDAO.getAttemptQuestions(attemptId);
        attempt.setQuestions(qs);

        // nạp câu trả lời (nếu đã lưu draft/submit)
        List<QuizAttemptAnswerDTO> ans = quizDAO.getAttemptAnswers(attemptId);
        attempt.setAnswers(ans);

        return attempt;
    }

    public QuizAttemptDTO startNewAttempt(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        int nextNo = quizDAO.getNextAttemptNo(quizId, studentId);
        Long attemptIdObj = quizDAO.createDraftAttempt(quizId, studentId, nextNo);
        if (attemptIdObj == null) {
            throw new IllegalStateException("Không tạo được attempt");
        }
        long attemptId = attemptIdObj;

        QuizDTO quiz = quizDAO.getQuizById(quizId);
        List<QuestionDTO> picked = pickRandomQuestions(quiz);

        int order = 1;
        for (QuestionDTO q : picked) {
            quizDAO.insertAttemptQuestion(attemptId, q.getQuestionId(), order++);
        }
//       nap lai day du de tra ve
        return loadAttempt(attemptId);
    }

    public void saveDraftAnswer(Long attemptId, Map<String, String[]> parameters) {
        if (attemptId == null || attemptId <= 0) {
            throw new IllegalArgumentException("AttemptId không tồn tại");
        }
        finalizeIfExpired(attemptId);
        QuizAttemptDTO a = quizDAO.findQuizAttempById(attemptId);
        if (a == null) {
            throw new IllegalStateException("Attempt không tồn tại");
        }
        if (!"draft".equalsIgnoreCase(a.getStatus())) {
            return;
        }
        LocalDateTime deadline = a.getDeadlineAt();
        if (deadline != null && LocalDateTime.now().isAfter(deadline)) {
            return;
        }

        for (String k : parameters.keySet()) {
            String[] arr = parameters.get(k);
            String v = (arr != null && arr.length > 0) ? arr[0] : null;
            if (k.startsWith("answers[")) {
                int qid = Integer.parseInt(k.substring(8, k.length() - 1));
                Integer optId = (v == null || v.isBlank()) ? null : Integer.valueOf(v);
                quizDAO.saveAnswer(attemptId, qid, optId, null);

            } else if (k.startsWith("answersText[")) {
                int qid = Integer.parseInt(k.substring(12, k.length() - 1));
                String text = (v == null || v.isBlank()) ? null : v.trim();
                quizDAO.saveAnswer(attemptId, qid, null, text);
            }
        }
    }

    public void gradeAndSubmitAttempt(long attemptId, Map<String, String[]> params) {
        if (attemptId <= 0) {
            throw new IllegalArgumentException("Tham số không hợp lệ");
        }
        finalizeIfExpired(attemptId);
        QuizAttemptDTO a = quizDAO.findQuizAttempById(attemptId);
        if (a == null) {
            throw new IllegalStateException("Attempt không tồn tại");
        }
        if (!"draft".equalsIgnoreCase(a.getStatus())) {
            return;
        }

        saveDraftAnswer(attemptId, params);

        quizDAO.markCorrectnessForMCQ(attemptId);
        quizDAO.markCorrectnessForTextUsingKeys(attemptId);

        int[] ct = quizDAO.countCorrectAndTotal(attemptId);
        int correct = ct[0], total = ct[1];
        double scorePct = (total == 0) ? 0.0 : (correct * 100.0 / total);

        int ok = quizDAO.markSubmitted(attemptId, scorePct);
        if (ok != 1) {
            throw new IllegalStateException("Submit thất bại");
        }

        QuizDTO quiz = quizDAO.getQuizById(a.getQuizId());
        Double passing = quiz.getPassingScorePct();

        boolean passed = false;
        //neu dang practice thi chi can nop la danh dau complete
        if (passing == null) {
            passed = true;
        } else {
            passed = scorePct >= passing.doubleValue();
        }
//        boolean passed = (passing != null) && (scorePct >= passing.doubleValue());

        progressDAO.updateBestQuizOrAssigmentScore(a.getStudentId(), a.getQuizId(), scorePct, passed);

    }

    public QuizAttemptDTO findLatestSubmittedAttempt(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Không thể tìm bản ghi");
        }
        return quizDAO.findLatestSubmittedAttempt(quizId, studentId);
    }

    public int createQuiz(int moduleId, String title, Double passingScorePct, Integer pickCount, Integer timeLimit) {
        try {
            ModuleItem item = new ModuleItem();
            item.setModule(moduleDAO.getModuleById(moduleId));
            item.setItemType("quiz");
            item.setOrderIndex(moduleItemDAO.getNextOrderIndex(moduleId));
            item.setRequired(passingScorePct != null);

            int moduleItemId = moduleItemDAO.insertModuleItem(item);
            if (moduleItemId == -1) {
                System.err.println("Không thể tạo ModuleItem cho quiz");
                return -1;
            }

            Quiz quiz = new Quiz(moduleItemId, title, passingScorePct, pickCount, timeLimit);
            boolean success = quizDAO.insertQuiz(quiz);

            return success ? moduleItemId : -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateQuiz(int quizId, String title, Double passingScorePct, Integer pickCount, Integer timeLimitMin) {
        try {
            Quiz q = new Quiz();
            q.setQuizId(quizId);
            q.setTitle(title);
            q.setPassingScorePct(passingScorePct);
            q.setPickCount(pickCount);
            q.setTimeLimitMin(timeLimitMin);

            return quizDAO.updateQuiz(q);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteQuiz(int quizId) {
        try {

            boolean itemDeleted = moduleItemDAO.deleteModuleItem(quizId);
            return itemDeleted;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Quiz getQuiz(int quizId) {
        return quizDAO.getQuiz(quizId);
    }

}
