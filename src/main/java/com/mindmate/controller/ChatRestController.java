package com.mindmate.controller;

import com.mindmate.dao.ChatDAO;
import com.mindmate.model.ChatMessage;
import com.mindmate.model.Student;
import com.mindmate.service.GeminiService;
import com.mindmate.dao.StudentDAO;
import com.mindmate.util.SessionHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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

    @Autowired
    private GeminiService geminiService;

    /**
     * Handles sending a message. Returns 401 Unauthorized if the session is invalid.
     */
    @PostMapping("/send")
    public ResponseEntity<ChatMessage> handleSendMessage(@RequestBody String message, HttpSession session) {
        // Security Check: Ensure user is logged in AND is a student
        Long userId = SessionHelper.getUserId(session);
        String role = SessionHelper.getRole(session);

        if (userId == null || !"student".equals(role)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // 1. Save User Message to Database
        ChatMessage userMsg = new ChatMessage("user", message, LocalDateTime.now());
        chatDAO.saveMessage(userMsg);

        // 2. Get Real AI Response from Gemini Service
        String aiResponse = geminiService.generateResponse(message);

        // 3. Save AI Message to Database
        ChatMessage aiMsg = new ChatMessage("assistant", aiResponse, LocalDateTime.now());
        chatDAO.saveMessage(aiMsg);

        // Return the AI message object as JSON with a 200 OK status
        return ResponseEntity.ok(aiMsg);
    }

    /**
     * Retrieves previous messages so the chat widget survives page refreshes.
     */
    @GetMapping("/history")
    public ResponseEntity<List<ChatMessage>> getChatHistory(HttpSession session) {
        // Security Check
        Long userId = SessionHelper.getUserId(session);
        if (userId == null || !"student".equals(SessionHelper.getRole(session))) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<ChatMessage> history = chatDAO.getAllMessages();
        return ResponseEntity.ok(history);
    }
}