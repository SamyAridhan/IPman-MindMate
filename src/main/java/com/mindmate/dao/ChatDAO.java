package com.mindmate.dao;

import com.mindmate.model.ChatMessage;
import java.util.List;

public interface ChatDAO {
    void saveMessage(ChatMessage message);
    List<ChatMessage> getAllMessages();
    void clearHistory(); // Useful for a "Reset Chat" button

    List<ChatMessage> getMessagesBySession(String sessionId);
    List<String> getUniqueSessionsByStudent(Long studentId);
}