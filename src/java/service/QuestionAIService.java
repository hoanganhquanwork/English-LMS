/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package service;

import com.google.gson.*;
import model.entity.*;
import java.io.IOException;
import java.net.URI;
import java.net.http.*;
import java.util.*;
import com.google.gson.reflect.TypeToken;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class QuestionAIService {

    private static final String GEMINI_API_KEY = "AIzaSyDwTpnNqLc8XLF5Ts0dzgo_YYkN3Mk6Yao";

    public List<Question> generateQuestions(String topic, String type, int count) {
        List<Question> questions = new ArrayList<>();

        // Prompt cho AI
      String prompt = "Bạn là một chuyên gia tạo câu hỏi cho người học tiếng Anh (English Language Learning). "
        + "Hãy tạo " + count + " câu hỏi học tiếng Anh về chủ đề \"" + topic + "\". "
        + "Các câu hỏi phải giúp người học rèn luyện kỹ năng ngôn ngữ như: từ vựng, ngữ pháp, giao tiếp, hoặc hiểu nghĩa câu. "
        + "Dạng câu hỏi là " + (type.equals("mcq") ? "trắc nghiệm (multiple choice)" : "tự luận (short answer)") + ". "
        + "Nếu là trắc nghiệm: mỗi câu gồm 'content', danh sách 'options' (4 phương án), "
        + "một phương án có 'isCorrect=true', và có 'explanation' giải thích lý do tại sao đáp án đúng. "
        + "Nếu là tự luận: mỗi câu có 'content', 'answerText' là câu trả lời mẫu, và 'explanation' ngắn gọn. "
        + "Câu hỏi phải bằng tiếng Anh, lời giải thích có thể bằng tiếng Việt để người học hiểu rõ. "
        + "Hãy trả về **chỉ JSON** dạng mảng, không thêm mô tả. Ví dụ: "
        + "[{"
        + "\"type\":\"mcq\",\"content\":\"Choose the correct form: He ___ to school every day.\","
        + "\"options\":["
        + "{\"content\":\"go\",\"isCorrect\":false},"
        + "{\"content\":\"goes\",\"isCorrect\":true},"
        + "{\"content\":\"gone\",\"isCorrect\":false},"
        + "{\"content\":\"going\",\"isCorrect\":false}],"
        + "\"explanation\":\"Động từ 'He' cần chia ngôi thứ 3 số ít → 'goes'.\""
        + "}]";

        try {
            // HTTP client
            HttpClient client = HttpClient.newHttpClient();
            String body = "{"
                    + "\"contents\": [{\"parts\":[{\"text\":\"" + prompt.replace("\"", "\\\"") + "\"}]}]"
                    + "}";

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            String responseBody = response.body();
            System.out.println("✅ Prompt gửi đi:\n" + prompt);
            System.out.println("✅ Response Raw từ Gemini:\n" + responseBody);

            // Lấy nội dung phản hồi chính từ Gemini
            JsonObject root = JsonParser.parseString(responseBody).getAsJsonObject();
            JsonArray candidates = root.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                String text = candidates.get(0)
                        .getAsJsonObject()
                        .getAsJsonObject("content")
                        .getAsJsonArray("parts")
                        .get(0)
                        .getAsJsonObject()
                        .get("text").getAsString();

                // ✨ Loại bỏ mọi phần không phải JSON thuần
                Matcher matcher = Pattern.compile("\\[.*]", Pattern.DOTALL).matcher(text);
                if (matcher.find()) {
                    text = matcher.group(0);
                }
                System.out.println("✅ JSON sau khi lọc:\n" + text);
                // Parse thành List<Question>
                Gson gson = new GsonBuilder()
                        .registerTypeAdapter(java.time.LocalDate.class, (JsonDeserializer<LocalDate>) (json, typeOfT, context) -> null)
                        .registerTypeAdapter(java.time.LocalDateTime.class, (JsonDeserializer<LocalDateTime>) (json, typeOfT, context) -> null)
                        .setLenient()
                        .serializeNulls()
                        .create();

                List<Question> temp = gson.fromJson(text, new TypeToken<List<Question>>() {
                }.getType());

                for (Question sq : temp) {
                    Question q = new Question();
                    q.setType(sq.getType());
                    q.setContent(sq.getContent());
                    q.setExplanation(sq.getExplanation());
                    q.setOptions(sq.getOptions());
                    q.setTextKey(sq.getTextKey());
                    questions.add(q);
                }
                System.out.println("✅ Số câu hỏi parse được: " + questions.size());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return questions;
    }

    public static void main(String[] args) {
        QuestionAIService service = new QuestionAIService();
        List<Question> list = service.generateQuestions("Giao tiếp hàng ngày", "mcq", 1);
        for (Question q : list) {
            System.out.println(q);
        }
    }

}
