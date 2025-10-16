package com.service.backend.services;

import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.service.backend.DTO.geminipattern.GeminiRequest;
import com.service.backend.DTO.geminipattern.GeminiResponse;

import java.util.List;

@Service
public class GeminiService {
    private String apiKey = "AIzaSyAtgfr9dFtCd6QjZZkpv5iaegMdfGsGY-s";

    private String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

    private final RestTemplate restTemplate;

    public GeminiService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public String getGeminiResponse(String prompt) {
        try {
            GeminiRequest.Part part = new GeminiRequest.Part(prompt);
            GeminiRequest.Content content = new GeminiRequest.Content(List.of(part));
            GeminiRequest request = new GeminiRequest(List.of(content));

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // Nếu apiKey có dạng access token (ví dụ "ya29.") dùng Bearer, ngược lại chuyền ?key=
            if (apiKey != null && apiKey.startsWith("ya29.")) {
                headers.setBearerAuth(apiKey);
            }

            HttpEntity<GeminiRequest> entity = new HttpEntity<>(request, headers);

            String url = apiUrl;
            if (apiKey != null && !apiKey.isEmpty() && !apiKey.startsWith("ya29.")) {
                url = apiUrl + (apiUrl.contains("?") ? "&" : "?") + "key=" + apiKey;
            }

            ResponseEntity<GeminiResponse> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                GeminiResponse.class
            );

            GeminiResponse body = response.getBody();
            if (body == null || body.getCandidates() == null || body.getCandidates().isEmpty()) {
                return "No content returned from Gemini";
            }

            return body.getCandidates().get(0).getContent().getParts().get(0).getText();
        } catch (HttpClientErrorException he) {
            // show response body to debug 400/404/401
            throw new RuntimeException("Lỗi khi gọi Gemini API: " + he.getStatusCode() + ": " + he.getResponseBodyAsString(), he);
        } catch (Exception e) {
            throw new RuntimeException("Lỗi khi gọi Gemini API: " + e.getMessage(), e);
        }
    }
}
