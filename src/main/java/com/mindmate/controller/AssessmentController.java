package com.mindmate.controller;

import com.mindmate.model.Question; // Needs the Question Model
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpSession; // Use Jakarta import

import java.util.Arrays;
import java.util.List;
import java.util.Map;

// Class-level RequestMapping defines the base URL for the assessment module
@Controller
@RequestMapping("/student/assessment")
public class AssessmentController {

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
        // ... (Keep the exact scoring logic from the previous controller) ...
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

    /**
     * Initializes or continues the assessment.
     * Maps to: GET /student/assessment
     */
    @GetMapping
    public String startAssessment(HttpSession session, Model model) {
        // Pass the role just in case the header needs it
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
            session.removeAttribute("showResults"); // Ensure this is explicitly reset
        }

        return displayQuestion(currentQIndex, model);
    }

    /**
     * Processes the user's answer.
     * Maps to: POST /student/assessment/submit
     */
    @PostMapping("/submit")
    public String processSubmission(
            @RequestParam(name = "currentQuestionIndex") int currentQIndex,
            @RequestParam(name = "response", required = false) Integer responseValue,
            @RequestParam(name = "direction") String direction,
            HttpSession session, Model model) {

        int[] responses = (int[]) session.getAttribute("assessmentResponses");
        
        // This ensures the response for the question the user is LEAVING is always recorded.
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

    /**
     * Handles consent dialog action.
     * Maps to: GET /student/assessment/consent
     */
    @GetMapping("/consent")
    public String handleConsent(@RequestParam("share") boolean share, HttpSession session) {
        session.setAttribute("consentDialogShown", true);
        if (share) {
            System.out.println("User consented to share results.");
        }
        return "redirect:/student/assessment";
    }

    /**
     * Resets the assessment state.
     * Maps to: GET /student/assessment/reset
     */
    @GetMapping("/reset")
    public String resetAssessment(HttpSession session) {
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