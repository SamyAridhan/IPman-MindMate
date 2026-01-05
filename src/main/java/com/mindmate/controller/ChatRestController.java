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
import java.util.List;
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

        // 1. Manage Chat Session ID (Start a new one if none exists in this browser session)
        String chatSessionId = (String) session.getAttribute(SESSION_KEY);
        if (chatSessionId == null) {
            chatSessionId = "chat_" + UUID.randomUUID().toString().substring(0, 8);
            session.setAttribute(SESSION_KEY, chatSessionId);
        }

        Student student = studentDAO.findById(userId);

        // 2. Save User Message to Database
        ChatMessage userMsg = new ChatMessage("user", message, LocalDateTime.now());
        userMsg.setStudent(student);
        userMsg.setSessionId(chatSessionId);
        chatDAO.saveMessage(userMsg);

        // 3. Get AI Response from Gemini
        String aiResponse = geminiService.generateResponse(message);

        // 4. Save AI Message to Database
        ChatMessage aiMsg = new ChatMessage("assistant", aiResponse, LocalDateTime.now());
        aiMsg.setStudent(student);
        aiMsg.setSessionId(chatSessionId);
        chatDAO.saveMessage(aiMsg);

        return ResponseEntity.ok(aiMsg);
    }

    /**
     * Gets all unique session IDs for this specific student to show in the sidebar.
     */
    @GetMapping("/sessions")
    public ResponseEntity<List<String>> getChatSessions(HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        List<String> sessions = chatDAO.getUniqueSessionsByStudent(userId);
        return ResponseEntity.ok(sessions);
    }

    /**
     * Fetches messages for a specific conversation when clicked in the sidebar.
     */
    @GetMapping("/history/load")
    public ResponseEntity<List<ChatMessage>> getSpecificHistory(@RequestParam String sessionId, HttpSession session) {
        Long userId = SessionHelper.getUserId(session);
        if (userId == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        // IMPORTANT: Switch the current session ID so future "sends" stay in this conversation
        session.setAttribute(SESSION_KEY, sessionId);

        List<ChatMessage> history = chatDAO.getMessagesBySession(sessionId);
        return ResponseEntity.ok(history);
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