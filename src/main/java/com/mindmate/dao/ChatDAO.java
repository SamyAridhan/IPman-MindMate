package com.mindmate.dao;

import com.mindmate.model.ChatMessage;
import com.mindmate.model.Student;
import java.util.List;

public interface ChatDAO {
    void saveMessage(ChatMessage message);
    List<ChatMessage> getAllMessages();
    void clearHistory(); // Useful for a "Reset Chat" button

    List<ChatMessage> getMessagesBySession(String sessionId);
    List<String> getUniqueSessionsByStudent(Long studentId);
    
    // NEW: Count messages in a session for a student
    long countByStudentAndSessionId(Student student, String sessionId);
    
    // NEW: Get session titles (first user message of each session) for sidebar
    List<ChatMessage> getSessionTitlesByStudent(Student student);
    
    // NEW: Get messages for a student in a session
    List<ChatMessage> getMessagesByStudentAndSession(Student student, String sessionId);
}