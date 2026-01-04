package com.mindmate.controller;

import com.mindmate.dao.ChatDAO;
import com.mindmate.model.ChatMessage;
import com.mindmate.model.Student;
import com.mindmate.dao.StudentDAO;
import com.mindmate.util.SessionHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

    @Autowired
    private ChatDAO chatDAO;

    @Autowired
    private StudentDAO studentDAO;

    // You will create this service next to handle the Gemini API
    // @Autowired
    // private GeminiService geminiService;

    @PostMapping("/send")
    public ChatMessage handleSendMessage(@RequestBody String message, HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null) return null;

        // 1. Save User Message to Database
        ChatMessage userMsg = new ChatMessage("user", message, LocalDateTime.now());
        chatDAO.saveMessage(userMsg);

        // 2. Get AI Response (Placeholder logic for now)
        String aiResponse = "I am processing your message: " + message; 
        // String aiResponse = geminiService.generateResponse(message);

        // 3. Save AI Message to Database
        ChatMessage aiMsg = new ChatMessage("assistant", aiResponse, LocalDateTime.now());
        chatDAO.saveMessage(aiMsg);

        return aiMsg; // Returns JSON to the frontend
    }

    @GetMapping("/history")
    public List<ChatMessage> getChatHistory(HttpSession session) {
        // This allows the widget to persist chat if the user refreshes the page
        return chatDAO.getAllMessages();
    }
}