package com.mindmate.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    /**
     * STABLE MODEL FOR MALAYSIA (JAN 2026):
     * Using 'v1' stable endpoint and 'gemini-2.5-flash' model.
     */
    private static final String BASE_URL = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=";

    public String generateResponse(String userPrompt) {
        try {
            if (apiKey == null || apiKey.isEmpty()) {
                return "System Error: API key is missing in application.properties.";
            }

            RestTemplate restTemplate = new RestTemplate();
            String fullUrl = BASE_URL + apiKey;

            // 1. Prepare JSON Request Body
            Map<String, Object> requestBody = new HashMap<>();
            List<Map<String, Object>> contents = new ArrayList<>();
            Map<String, Object> contentMap = new HashMap<>();
            List<Map<String, String>> parts = new ArrayList<>();
            Map<String, String> textPart = new HashMap<>();

            textPart.put("text", userPrompt);
            parts.add(textPart);
            contentMap.put("parts", parts);
            contents.add(contentMap);
            requestBody.put("contents", contents);

            // 2. Set Headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // 3. POST Request to Google
            ResponseEntity<Map> response = restTemplate.postForEntity(fullUrl, entity, Map.class);
            
            // Console Debugging
            System.out.println("Gemini API Status: " + response.getStatusCode());

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return extractTextFromGeminiResponse(response.getBody());
            } else {
                return "The AI is momentarily unavailable. Please try again.";
            }

        } catch (org.springframework.web.client.HttpClientErrorException.NotFound e) {
            System.err.println("Model ID Error: " + e.getResponseBodyAsString());
            return "Configuration Error: Please ensure you are using 'gemini-2.5-flash' in BASE_URL.";
        } catch (org.springframework.web.client.HttpClientErrorException.TooManyRequests e) {
            return "You're sending messages too quickly. Please wait 60 seconds.";
        } catch (Exception e) {
            e.printStackTrace();
            return "I'm having trouble connecting to my brain right now. Please try again later.";
        }
    }

    private String extractTextFromGeminiResponse(Map responseBody) {
        try {
            List<?> candidates = (List<?>) responseBody.get("candidates");
            if (candidates == null || candidates.isEmpty()) return "I'm sorry, I cannot respond to that.";

            Map<?, ?> firstCandidate = (Map<?, ?>) candidates.get(0);
            Map<?, ?> content = (Map<?, ?>) firstCandidate.get("content");
            List<?> parts = (List<?>) content.get("parts");
            Map<?, ?> firstPart = (Map<?, ?>) parts.get(0);

            return (String) firstPart.get("text");
        } catch (Exception e) {
            return "Received an unexpected response format from the AI.";
        }
    }
}