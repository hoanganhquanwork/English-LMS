/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import dal.ProgressDAO;
import dal.QuestionDAO;
import dal.QuizDAO;
import java.util.ArrayList;
import java.util.Collection;
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

public class QuizService {

    private QuizDAO quizDAO = new QuizDAO();
    private QuestionDAO questionDAO = new QuestionDAO();
    private ProgressDAO progressDAO = new ProgressDAO();
    private ModuleItemDAO moduleItemDAO = new ModuleItemDAO();

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

        Collections.shuffle(bank);
        if (quiz.getPickCount() != null && quiz.getPickCount() < bank.size()) {
            return new ArrayList<>(bank.subList(0, quiz.getPickCount()));
        }
        return bank;
    }

    public Double getBestScore(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Không thể lấy điểm");
        }
        return quizDAO.getBestScoreFromAttempts(quizId, studentId);
    }

    public QuizAttemptDTO findLatestAttempt(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Không thể lấy điểm");
        }
        return quizDAO.findLatestAttempt(quizId, studentId);
    }

    public QuizAttemptDTO loadAttempt(long attemptId) {
        QuizAttemptDTO attempt = quizDAO.findQuizAttempById(attemptId);
        if (attempt == null) {
            return null;
        }

        List<QuizAttemptQuestionDTO> qs = quizDAO.getAttemptQuestions(attemptId);
        attempt.setQuestions(qs);

        // nạp câu trả lời (nếu đã lưu draft/submit)
        List<QuizAttemptAnswerDTO> ans = quizDAO.getAttemptAnswers(attemptId);
        attempt.setAnswers(ans);

        return attempt;
    }

    public QuizAttemptDTO startNewAttempt(int quizId, int studentId) {
        int nextNo = quizDAO.getNextAttemptNo(quizId, studentId);
        long attemptId = quizDAO.createDraftAttempt(quizId, studentId, nextNo);

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
        if (attemptId <= 0) {
            throw new IllegalArgumentException("Không thể lấy xóa đáp án");
        }
        quizDAO.clearAnswersForAttempt(attemptId);
        for (String k : parameters.keySet()) {
            if (k.startsWith("answers[")) {
                int qid = Integer.parseInt(k.substring(8, k.length() - 1));
                String[] arr = parameters.get(k);
                String v = (arr != null && arr.length > 0) ? arr[0] : null;
                if (v != null && !v.isBlank()) {
                    quizDAO.insertAnswer(attemptId, qid, Integer.valueOf(v), null);
                }

            } else if (k.startsWith("answersText[")) {
                int qid = Integer.parseInt(k.substring(12, k.length() - 1));
                String[] arr = parameters.get(k);
                String v = (arr != null && arr.length > 0) ? arr[0] : null;
                if (v != null && !v.isBlank()) {
                    quizDAO.insertAnswer(attemptId, qid, null, v.trim());
                }
            }
        }
    }

    public void gradeAndSubmitAttempt(long attemptId, int studentId, int moduleItemId, Map<String, String[]> params) {

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

        QuizDTO quiz = quizDAO.getQuizById(moduleItemId);
        Double passing = quiz.getPassingScorePct();
        boolean passed = (passing != null) && (scorePct >= passing.doubleValue());

        progressDAO.updateBestQuizScore(studentId, moduleItemId, scorePct, passed);

    }

    public QuizAttemptDTO findLatestSubmittedAttempt(int quizId, int studentId) {
        if (quizId <= 0 || studentId <= 0) {
            throw new IllegalArgumentException("Không thể tìm bản ghi");
        }
        return quizDAO.findLatestSubmittedAttempt(quizId, studentId);
    }

   
    public int createQuiz(int moduleId, String title, Integer attemptsAllowed, Double passingScorePct, Integer pickCount) {
        try {
            
            ModuleItem item = new ModuleItem();
            item.setModuleId(moduleId);
            item.setItemType("quiz");
            item.setOrderIndex(moduleItemDAO.getNextOrderIndex(moduleId));
            item.setRequired(true);

            int moduleItemId = moduleItemDAO.insertModuleItem(item);
            if (moduleItemId == -1) {
                System.err.println("Không thể tạo ModuleItem cho quiz");
                return -1;
            }

            // 2️⃣ Tạo quiz tương ứng
            Quiz quiz = new Quiz(moduleItemId, title, attemptsAllowed, passingScorePct, pickCount);
            boolean success = quizDAO.insertQuiz(quiz);

            return success ? moduleItemId : -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public boolean updateQuiz(int quizId, String title, Integer attemptsAllowed, BigDecimal passingScorePct, Integer pickCount) {
        try {
            return quizDAO.updateQuiz(quizId, title, attemptsAllowed, passingScorePct, pickCount);
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
}

