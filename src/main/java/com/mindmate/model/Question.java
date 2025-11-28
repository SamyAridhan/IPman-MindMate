package com.mindmate.model;

import java.util.List;
import java.util.Map;

/**
 * Model class to represent a single assessment question.
 * It holds the question text and the available response options.
 */
public class Question {
    
    private final int id;
    private final String text;
    // Options are structured as a List of Maps: 
    // e.g., [{ "value": 0, "label": "Not at all" }, ...]
    private final List<Map<String, Object>> options;

    /**
     * Constructor for the Question model.
     * * @param id The unique identifier for the question.
     * @param text The text of the question.
     * @param options The list of available answer options.
     */
    public Question(int id, String text, List<Map<String, Object>> options) {
        this.id = id;
        this.text = text;
        this.options = options;
    }

    // --- Getters ---
    
    public int getId() {
        return id;
    }

    public String getText() {
        return text;
    }

    public List<Map<String, Object>> getOptions() {
        return options;
    }

    // --- Optional: For better debugging/logging ---
    @Override
    public String toString() {
        return "Question{" +
                "id=" + id +
                ", text='" + text + '\'' +
                ", options=" + options +
                '}';
    }
}
