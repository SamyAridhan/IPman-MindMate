package com.mindmate.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;

@Service
public class GeminiService {

    // Injected from application.properties
    @Value("${gemini.api.key}")
    private String apiKey;

    private static final String BASE_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

    /**
     * Sends the user prompt to the Gemini API and returns the AI's text response.
     */
    public String generateResponse(String userPrompt) {
        try {
            // Check if API key is missing
            if (apiKey == null || apiKey.isEmpty() || apiKey.equals("YOUR_ACTUAL_KEY")) {
                return "System Error: Gemini API key is not configured in application.properties.";
            }

            RestTemplate restTemplate = new RestTemplate();
            String fullUrl = BASE_URL + apiKey;

            // 1. Prepare the JSON request body
            // Gemini API expects: { "contents": [ { "parts": [ { "text": "..." } ] } ] }
            Map<String, Object> requestBody = new HashMap<>();
            Map<String, Object> content = new HashMap<>();
            Map<String, String> part = new HashMap<>();
            
            part.put("text", userPrompt);
            content.put("parts", Collections.singletonList(part));
            requestBody.put("contents", Collections.singletonList(content));

            // 2. Set HTTP Headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            // 3. Execute the POST request
            ResponseEntity<Map> response = restTemplate.postForEntity(fullUrl, entity, Map.class);

            // 4. Parse and return the result
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return extractTextFromGeminiResponse(response.getBody());
            } else {
                return "The AI service returned an error. Please try again later.";
            }

        } catch (Exception e) {
            System.err.println("Error calling Gemini API: " + e.getMessage());
            e.printStackTrace();
            return "I'm having trouble connecting to my brain right now. Please try again later.";
        }
    }

    /**
     * Navigates the complex JSON response from Google to find the generated text string.
     */
    private String extractTextFromGeminiResponse(Map responseBody) {
        try {
            // Response structure: candidates[0] -> content -> parts[0] -> text
            List<?> candidates = (List<?>) responseBody.get("candidates");
            if (candidates == null || candidates.isEmpty()) return "No response generated.";

            Map<?, ?> firstCandidate = (Map<?, ?>) candidates.get(0);
            Map<?, ?> content = (Map<?, ?>) firstCandidate.get("content");
            List<?> parts = (List<?>) content.get("parts");
            Map<?, ?> firstPart = (Map<?, ?>) parts.get(0);

            return (String) firstPart.get("text");
        } catch (Exception e) {
            return "I received a response, but I couldn't read the data format.";
        }
    }
}