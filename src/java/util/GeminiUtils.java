package util;

import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import model.entity.Flashcard;
import org.json.*;

public class GeminiUtils {

    private static final String API_KEY = "AIzaSyCEfBe--9SWIpK6wt0i2N7BbQqwHfWslwY";
    private static final String API_URL =
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + API_KEY;

  
    public static List<Flashcard> generateFlashcards(String prompt, int setId) {
        List<Flashcard> list = new ArrayList<>();

        if (prompt == null || prompt.trim().isEmpty()) {
            return list;
        }

        try {
            String fullPrompt =
                    "Bạn là hệ thống tạo flashcard học tiếng Anh. "
                    + "Hãy tạo tối đa 10 flashcard ngắn gọn, mỗi thẻ gồm 'front' và 'back'. "
                    + "Trả về duy nhất JSON mảng dạng [{\"front\":\"...\",\"back\":\"...\"}] "
                    + "và không thêm bất kỳ văn bản nào khác.\n\n"
                    + "Chủ đề: " + prompt.trim();

            JSONObject body = new JSONObject()
                    .put("contents", new JSONArray()
                            .put(new JSONObject()
                                    .put("parts", new JSONArray()
                                            .put(new JSONObject().put("text", fullPrompt)))));

            HttpURLConnection conn = (HttpURLConnection) new URL(API_URL).openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toString().getBytes(StandardCharsets.UTF_8));
            }

            StringBuilder response = new StringBuilder();
            try (BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = br.readLine()) != null) response.append(line);
            }

            JSONObject res = new JSONObject(response.toString());
            String text = res.getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .optString("text", "");

            if (text.startsWith("```")) {
                text = text.replaceAll("```json", "").replaceAll("```", "").trim();
            }

            JSONArray arr = new JSONArray(text);
            for (int i = 0; i < arr.length(); i++) {
                JSONObject c = arr.getJSONObject(i);
                String front = c.optString("front", "").trim();
                String back = c.optString("back", "").trim();

                if (!front.isEmpty() && !back.isEmpty()) {
                    list.add(new Flashcard(setId, front, back));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}