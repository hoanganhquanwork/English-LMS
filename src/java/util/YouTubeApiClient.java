/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONObject;
/**
 *
 * @author Lenovo
 */
public class YouTubeApiClient {
    private final String apiKey;

    public YouTubeApiClient(String apiKey) {
        this.apiKey = apiKey;
    }

    // Regex hỗ trợ nhiều dạng URL YouTube
    private static final Pattern ytIdPattern = Pattern.compile(
        "(?:youtu\\.be/|youtube(?:-nocookie)?\\.com/(?:watch\\?v=|embed/|v/|shorts/|user/.+?#p/u/\\d+/))([A-Za-z0-9_-]{11})"
    );

    // Trích videoId từ link YouTube hoặc input là id
    public static String extractVideoId(String youtubeUrl) {
        if (youtubeUrl == null) return null;
        youtubeUrl = youtubeUrl.trim();

        Matcher m = ytIdPattern.matcher(youtubeUrl);
        if (m.find()) {
            return m.group(1);
        }
       
        if (youtubeUrl.matches("[A-Za-z0-9_-]{11}")) {
            return youtubeUrl;
        }
        return null;
    }
    
    public static String toEmbedUrl(String urlOrId) 
    {
        String id = extractVideoId(urlOrId);
        if (id == null) return null;
        return "https://www.youtube.com/embed/" + id;
    }

    // Gọi YouTube Data API v3 để lấy duration ISO 8601
    public String fetchIsoDuration(String videoId) throws Exception {
        if (videoId == null) throw new IllegalArgumentException("videoId null");

        String endpoint = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id="
                          + videoId + "&key=" + apiKey;

        URL url = new URL(endpoint);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int code = conn.getResponseCode();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(
                code == 200 ? conn.getInputStream() : conn.getErrorStream(),
                StandardCharsets.UTF_8))) {

            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) sb.append(line);

            if (code != 200) {
                throw new RuntimeException("YouTube API error: " + sb.toString());
            }

            JSONObject json = new JSONObject(sb.toString());
            JSONArray items = json.getJSONArray("items");
            if (items.isEmpty()) throw new RuntimeException("Video not found");

            JSONObject contentDetails = items.getJSONObject(0).getJSONObject("contentDetails");
            return contentDetails.getString("duration"); // ví dụ: "PT5M30S"
        }
    }

    // Chuyển ISO 8601 duration (PT#H#M#S) -> số giây
    public static int isoDurationToSeconds(String iso) {
        if (iso == null || iso.isEmpty()) return 0;
        // Bỏ "PT"
        String s = iso.startsWith("PT") ? iso.substring(2) : iso;
        int hours = 0, minutes = 0, seconds = 0;

        // parse giờ
        int hIdx = s.indexOf('H');
        if (hIdx >= 0) {
            hours = Integer.parseInt(s.substring(0, hIdx));
            s = s.substring(hIdx + 1);
        }

        // parse phút
        int mIdx = s.indexOf('M');
        if (mIdx >= 0) {
            minutes = Integer.parseInt(s.substring(0, mIdx));
            s = s.substring(mIdx + 1);
        }

        // parse giây
        int secIdx = s.indexOf('S');
        if (secIdx >= 0) {
            String secPart = s.substring(0, secIdx);
            if (!secPart.isEmpty()) {
                seconds = Integer.parseInt(secPart);
            }
        }

        return hours * 3600 + minutes * 60 + seconds;
    }
}
