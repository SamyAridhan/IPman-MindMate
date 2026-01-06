// src/main/java/com/mindmate/controller/AssessmentController.java
package com.mindmate.controller;

import com.mindmate.model.Question;
import com.mindmate.util.SessionHelper; // ✅ Import this

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession;

import java.util.Arrays;
import java.util.List;
import java.util.Map;

import com.mindmate.dao.AssessmentDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.Assessment;
import com.mindmate.model.Student;
import org.springframework.beans.factory.annotation.Autowired;

@Controller
@RequestMapping("/student/assessment")
public class AssessmentController {

    @Autowired
    private AssessmentDAO assessmentDAO;

    @Autowired
    private StudentDAO studentDAO;

    // --- Assessment Data (Static Configuration) ---
    private static final List<Question> ASSESSMENT_QUESTIONS = Arrays.asList(
        new Question(1, "How often do you feel nervous, anxious, or on edge?", createOptions()),
        new Question(2, "How often have you been unable to stop or control worrying?", createOptions()),
        new Question(3, "How often do you feel down, depressed, or hopeless?", createOptions()),
        new Question(4, "How often have you had little interest or pleasure in doing things?", createOptions()),
        new Question(5, "How often have you had trouble falling or staying asleep, or sleeping too much?", createOptions())
    );
    
    private static final int TOTAL_QUESTIONS = ASSESSMENT_QUESTIONS.size();

    private static List<Map<String, Object>> createOptions() {
        return Arrays.asList(
            Map.of("value", 0, "label", "Not at all"),
            Map.of("value", 1, "label", "Several days"),
            Map.of("value", 2, "label", "More than half the days"),
            Map.of("value", 3, "label", "Nearly every day")
        );
    }
    
    // --- Utility Methods (Scoring) ---
    private Map<String, Object> calculateResults(int totalScore) {
        String level;
        String action;
        String colorClass;
        String backgroundClass;
        boolean highRisk = false;

        if (totalScore >= 12) {
            level = "Severe";
            action = "Please consider reaching out for immediate support. We strongly recommend sharing your results.";
            colorClass = "text-destructive";
            backgroundClass = "bg-destructive/10";
            highRisk = true;
        } else if (totalScore >= 7) {
            level = "Moderate";
            action = "Your results suggest a moderate need for support. Exploring our resources is highly recommended.";
            colorClass = "text-primary";
            backgroundClass = "bg-primary/10";
        } else {
            level = "Minimal";
            action = "Your results suggest minimal symptoms. Keep up with healthy habits!";
            colorClass = "text-green-600";
            backgroundClass = "bg-green-100";
        }

        int maxPossibleScore = TOTAL_QUESTIONS * 3;
        int scorePercentage = (int) (((double) totalScore / maxPossibleScore) * 100);

        return Map.of(
            "totalScore", totalScore,
            "score", scorePercentage,
            "level", level,
            "action", action,
            "color", colorClass,
            "bg", backgroundClass,
            "highRisk", highRisk
        );
    }
    
    // --- Assessment Flow Handlers ---

    @GetMapping
    public String startAssessment(HttpSession session, Model model) {
        // 🔒 SECURITY CHECK
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }

        model.addAttribute("role", "student"); 

        Boolean showResults = (Boolean) session.getAttribute("showResults");
        if (showResults != null && showResults) {
            Map<String, ?> resultsMap = (Map<String, ?>) session.getAttribute("assessmentResultsData");
            if (resultsMap != null) {
                model.addAllAttributes(resultsMap); 
            }
            
            model.addAttribute("showResults", true);
            
            Boolean highRisk = (Boolean) session.getAttribute("highRisk");
            Boolean consentGiven = (Boolean) session.getAttribute("consentDialogShown");
            
            if (highRisk != null && highRisk && (consentGiven == null || !consentGiven)) {
                 model.addAttribute("showConsentDialog", true);
            }
            return "student/assessment-questions";
        }

        Integer currentQIndex = (Integer) session.getAttribute("currentQuestionIndex");
        if (currentQIndex == null || currentQIndex < 0 || currentQIndex >= TOTAL_QUESTIONS) {
            currentQIndex = 0;
            session.setAttribute("currentQuestionIndex", 0);
            session.setAttribute("assessmentResponses", new int[TOTAL_QUESTIONS]);
            session.removeAttribute("assessmentResultsData");
            session.removeAttribute("highRisk");
            session.removeAttribute("consentDialogShown");
            session.removeAttribute("showResults");
        }

        return displayQuestion(currentQIndex, model);
    }

    @PostMapping("/submit")
    public String processSubmission(
            @RequestParam(name = "currentQuestionIndex") int currentQIndex,
            @RequestParam(name = "response", required = false) Integer responseValue,
            @RequestParam(name = "direction") String direction,
            HttpSession session, Model model) {

        // 🔒 SECURITY CHECK
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }

        int[] responses = (int[]) session.getAttribute("assessmentResponses");
        
        if (responseValue != null && currentQIndex >= 0 && currentQIndex < TOTAL_QUESTIONS) {
            responses[currentQIndex] = responseValue;
            session.setAttribute("assessmentResponses", responses);
        }

        int nextIndex = currentQIndex;
        if (direction.equals("next")) {
            nextIndex++;
        } else if (direction.equals("previous") && currentQIndex > 0) {
            nextIndex--;
        }
        
        session.setAttribute("currentQuestionIndex", nextIndex);
        model.addAttribute("role", "student");

        if (nextIndex >= TOTAL_QUESTIONS) {
            return showResults(responses, session, model);
        }

        return displayQuestion(nextIndex, model);
    }

    @GetMapping("/consent")
    public String handleConsent(@RequestParam("share") boolean share, HttpSession session) {
        // 🔒 SECURITY CHECK
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }

        session.setAttribute("consentDialogShown", true);
        if (share) {
            System.out.println("User consented to share results.");
        }
        return "redirect:/student/assessment";
    }

    @GetMapping("/reset")
    public String resetAssessment(HttpSession session) {
        // 🔒 SECURITY CHECK
        if (!SessionHelper.isLoggedIn(session) || !"student".equals(SessionHelper.getRole(session))) {
            return "redirect:/login";
        }

        session.removeAttribute("currentQuestionIndex");
        session.removeAttribute("assessmentResponses");
        session.removeAttribute("showResults");
        session.removeAttribute("assessmentResultsData");
        session.removeAttribute("highRisk");
        session.removeAttribute("consentDialogShown");
        return "redirect:/student/assessment";
    }

    // --- Utility Views ---
    
    private String showResults(int[] responses, HttpSession session, Model model) {
        int totalScore = Arrays.stream(responses).sum();
        Map<String, Object> results = calculateResults(totalScore);

        // --- ✅ NEW: DATABASE SAVING LOGIC ---
        Long userId = SessionHelper.getUserId(session); 
        
        if (userId != null) {
            // 2. Find the student by ID
            // Since your GenericDAO findById returns the object directly (not Optional), we just check for null
            Student student = studentDAO.findById(userId);

            if (student != null) {
                // 3. Create and Save the Assessment Entity
                Assessment assessment = new Assessment(student, totalScore);
                assessment.setResultCategory((String) results.get("level")); // e.g., "Severe"
                
                assessmentDAO.save(assessment);
                System.out.println("✅ Assessment saved for student ID: " + userId);
            } else {
                System.err.println("⚠️ Error: Student found in session (ID: " + userId + ") but not in Database.");
            }
        } else {
            System.err.println("⚠️ Error: No User ID found in session. Assessment not saved.");
        }

        session.setAttribute("showResults", true);
        session.setAttribute("assessmentResultsData", results);
        session.setAttribute("highRisk", (Boolean) results.get("highRisk"));

        model.addAttribute("showResults", true);
        model.addAllAttributes(results);

        Boolean consentGiven = (Boolean) session.getAttribute("consentDialogShown");
        if ((Boolean) results.get("highRisk") && (consentGiven == null || !consentGiven)) {
             model.addAttribute("showConsentDialog", true);
        }

        return "student/assessment-questions";
    }

    private String displayQuestion(int index, Model model) {
        Question currentQuestion = ASSESSMENT_QUESTIONS.get(index);
        
        model.addAttribute("currentQuestionIndex", index);
        model.addAttribute("totalQuestions", TOTAL_QUESTIONS);
        model.addAttribute("currentQuestion", currentQuestion.getText());
        model.addAttribute("responseOptions", currentQuestion.getOptions());
        model.addAttribute("showResults", false);
        model.addAttribute("showConsentDialog", false);
        
        return "student/assessment-questions";
    }
}