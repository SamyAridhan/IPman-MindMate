package com.mindmate.controller;

import com.mindmate.dao.ChatDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.ChatMessage;
import com.mindmate.model.Student;
import com.mindmate.service.GeminiService;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/chat")
public class ChatRestController {

    @Autowired
    private ChatDAO chatDAO;

    @Autowired
    private StudentDAO studentDAO;

    @Autowired
    private GeminiService geminiService;

    // This key tracks which conversation the student is currently viewing/typing in
    private static final String SESSION_KEY = "CURRENT_CHAT_SESSION_ID";

    /**
     * Sends a message. 
     * If it's a new login, it generates a fresh ID to ensure a "clean" start.
     */
    @PostMapping("/send")
public ResponseEntity<ChatMessage> handleSendMessage(@RequestBody String message, HttpSession session) {
    Long userId = SessionHelper.getUserId(session);
    String role = SessionHelper.getRole(session);

    // Security Check
    if (userId == null || !"student".equals(role)) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }

    // Manage Chat Session ID (Start a new one if none exists in this browser session)
    String chatSessionId = (String) session.getAttribute(SESSION_KEY);
    if (chatSessionId == null) {
        chatSessionId = "chat_" + UUID.randomUUID().toString().substring(0, 8);
        session.setAttribute(SESSION_KEY, chatSessionId);
    }

    Student student = studentDAO.findById(userId);

    // Save User Message to Database
    ChatMessage userMsg = new ChatMessage("user", message, LocalDateTime.now());
    userMsg.setStudent(student);
    userMsg.setSessionId(chatSessionId);
    
    // Generate title from first user message in this session
    long messageCount = chatDAO.countByStudentAndSessionId(student, chatSessionId);
    if (messageCount == 0) {
        String title = generateTitle(message);
        userMsg.setTitle(title);
    }
    
    chatDAO.saveMessage(userMsg);

    // Get AI Response from Gemini
    String aiResponse = geminiService.generateResponse(message);

    // Save AI Message to Database
    ChatMessage aiMsg = new ChatMessage("assistant", aiResponse, LocalDateTime.now());
    aiMsg.setStudent(student);
    aiMsg.setSessionId(chatSessionId);

    chatDAO.saveMessage(aiMsg);

    return ResponseEntity.ok(aiMsg);
}

//Helper method to generate title from user message
private String generateTitle(String message) {
    // Truncate to first 60 characters and remove special characters
    String title = message.replaceAll("[^a-zA-Z0-9\\s]", "").trim();
    
    if (title.length() > 60) {
        title = title.substring(0, 60).trim() + "...";
    }
    
    return title.isEmpty() ? "New Chat" : title;
}

    /**
     * Gets all unique session IDs for this specific student to show in the sidebar.
     */
    @GetMapping("/sessions")
public ResponseEntity<?> getSessions(HttpSession session) {
    Long userId = SessionHelper.getUserId(session);
    String role = SessionHelper.getRole(session);
    
    if (userId == null || !"student".equals(role)) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    
    Student student = studentDAO.findById(userId);
    
    // Get session titles from database
    List<ChatMessage> sessionTitles = chatDAO.getSessionTitlesByStudent(student);
    
    // Return as a list of objects with sessionId and title
    List<Map<String, String>> sessions = sessionTitles.stream()
        .map(msg -> {
            Map<String, String> sessionData = new HashMap<>();
            sessionData.put("sessionId", msg.getSessionId());
            sessionData.put("title", msg.getTitle() != null ? msg.getTitle() : "Chat");
            return sessionData;
        })
        .toList();
    
    return ResponseEntity.ok(sessions);
}

    /**
     * Fetches messages for a specific conversation when clicked in the sidebar.
     */
    @GetMapping("/history/load")
public ResponseEntity<List<ChatMessage>> loadHistory(
        @RequestParam String sessionId, 
        HttpSession session) {
    
    Long userId = SessionHelper.getUserId(session);
    if (userId == null) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }
    
    Student student = studentDAO.findById(userId);
    
    // Load messages for this specific session
    List<ChatMessage> messages = chatDAO.getMessagesByStudentAndSession(student, sessionId);
    
    return ResponseEntity.ok(messages);
}

    /**
     * Retrieves messages for the conversation currently active in the widget.
     * Useful for page refreshes.
     */
    @GetMapping("/history/current")
    public ResponseEntity<List<ChatMessage>> getCurrentChatHistory(HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        String chatSessionId = (String) session.getAttribute(SESSION_KEY);

        if (userId == null || chatSessionId == null) {
            return ResponseEntity.ok(List.of()); 
        }

        List<ChatMessage> history = chatDAO.getMessagesBySession(chatSessionId);
        return ResponseEntity.ok(history);
    }
    
    /**
     * Resets the chat (starts a new thread), similar to Gemini's "New Chat" button.
     */
    @PostMapping("/new")
    public ResponseEntity<Void> startNewChat(HttpSession session) {
        session.removeAttribute(SESSION_KEY);
        return ResponseEntity.status(HttpStatus.OK).build();
    }
}