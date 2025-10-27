package util;

import com.google.gson.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.List;
import java.util.Map;

public class GeminiAPI {

    public static class AssignmentFeedback {
        private final BigDecimal score;
        private final String feedback;

        public AssignmentFeedback(BigDecimal score, String feedback) {
            this.score = score;
            this.feedback = feedback;
        }

        public BigDecimal getScore() {
            return score;
        }

        public String getFeedback() {
            return feedback;
        }
        
    }
    private static final String API_KEY = "AIzaSyCgrUZxhR1XyIKuVDtBs-VxbAKiKjgR9NE";

    private static final String ENDPOINT
            = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + API_KEY;

    private static final Gson GSON = new Gson();
    private static final HttpClient HTTP_CLIENT = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(30))
            .version(HttpClient.Version.HTTP_2)
            .build();

    private static Map<String, Object> buildAssignmentFeedbackSchema() {
        return Map.of(
                "type", "object",
                "properties", Map.of(
                        "score", Map.of("type", "number", "description", "The final calculated score out of 100."),
                        "feedback", Map.of("type", "string", "description", "Detailed, constructive feedback on the submission, max 80 words.")
                ),
                "required", List.of("score", "feedback")
        );
    }

    public static JsonObject callGeminiAPI(String prompt) {
        try {
            Map<String, Object> payload = Map.of(
                    "contents", List.of(
                            Map.of("parts", List.of(Map.of("text", prompt)))
                    ),
                    "generationConfig", Map.of(
                            "responseMimeType", "application/json",
                            "responseSchema", buildAssignmentFeedbackSchema()
                    )
            );

            String jsonPayload = GSON.toJson(payload);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(ENDPOINT))
                    .timeout(Duration.ofSeconds(30))
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .POST(HttpRequest.BodyPublishers.ofString(jsonPayload, StandardCharsets.UTF_8))
                    .build();

            HttpResponse<String> aiRes = HTTP_CLIENT.send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

            if (aiRes.statusCode() / 100 != 2) {
                System.err.println("Gemini API Error - Status: " + aiRes.statusCode() + ", Body: " + aiRes.body());
                return null;
            }

            JsonObject root = JsonParser.parseString(aiRes.body()).getAsJsonObject();

            String jsonOutput = root.getAsJsonArray("candidates").get(0).getAsJsonObject()
                    .getAsJsonObject("content").getAsJsonArray("parts").get(0).getAsJsonObject()
                    .get("text").getAsString();

            if (jsonOutput.startsWith("```json") && jsonOutput.endsWith("```")) {
                jsonOutput = jsonOutput.substring(7, jsonOutput.length() - 3).trim();
            } else if (jsonOutput.startsWith("```") && jsonOutput.endsWith("```")) {
                jsonOutput = jsonOutput.substring(3, jsonOutput.length() - 3).trim();
            }

            return JsonParser.parseString(jsonOutput).getAsJsonObject();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static AssignmentFeedback parseGeminiResponse(JsonObject geminiResponse) {
        if (geminiResponse == null) {
            return new AssignmentFeedback(BigDecimal.ZERO, "API call failed or returned null.");
        }

        try {
            return GSON.fromJson(geminiResponse, AssignmentFeedback.class);

        } catch (Exception e) {
            e.printStackTrace();
            return new AssignmentFeedback(BigDecimal.ZERO, "Error parsing structured JSON: " + e.getMessage());
        }
    }
}
