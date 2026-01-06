package com.mindmate.controller;

import com.mindmate.dao.AssessmentDAOHibernate;
import com.mindmate.model.Assessment;
import com.mindmate.util.SessionHelper;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
public class HistoryController {

    @Autowired
    private AssessmentDAOHibernate assessmentDAO; 

    @GetMapping("/api/history")
    public List<Map<String, Object>> getHistory(@RequestParam(name = "limit", defaultValue = "all") String limit, HttpSession session) {
        
        // 1. Use your Helper to get the ID safely
        Long userId = SessionHelper.getUserId(session); 

        // 2. Safety check: If user is not logged in, return empty list
        if (userId == null) {
            return Collections.emptyList();
        }

        // 3. Call the DAO
        List<Assessment> assessments = assessmentDAO.findHistoryByStudent(userId);

        // 4. ✅ NEW: Apply Filtering Logic
        if (!"all".equals(limit) && assessments != null && !assessments.isEmpty()) {
            try {
                int count = Integer.parseInt(limit);
                // We want the most recent N assessments
                if (assessments.size() > count) {
                    // Assuming list is sorted Oldest -> Newest, take the end of the list
                    assessments = assessments.subList(assessments.size() - count, assessments.size());
                }
            } catch (NumberFormatException e) {
                // If parsing fails, just return all
            }
        }

        // 4. Format for Chart.js
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd");

        return assessments.stream().map(a -> {
            Map<String, Object> map = new HashMap<>();
            
            String dateLabel = (a.getTakenAt() != null) 
                ? a.getTakenAt().format(formatter) 
                : "N/A";
                
            map.put("date", dateLabel);
            map.put("score", a.getScore());
            
            return map;
        }).collect(Collectors.toList());
    }
}