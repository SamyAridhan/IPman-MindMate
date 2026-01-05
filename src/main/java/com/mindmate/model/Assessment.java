package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "assessments")
public class Assessment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    // REMOVED: private String testType; 

    @Column(name = "total_score")
    private int score; // Renamed to simple 'score' or keep 'totalScore' if you prefer

    @Column(name = "result_category")
    private String resultCategory; // e.g., "Severe"

    @Column(name = "taken_at")
    private LocalDateTime takenAt;

    @Column(name = "response_data") 
    private String responseData;

    public Assessment() {
        this.takenAt = LocalDateTime.now();
    }

    public Assessment(Student student, int score) {
        this.student = student;
        this.score = score;
        this.takenAt = LocalDateTime.now();
    }

    // --- Getters and Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Student getStudent() { return student; }
    public void setStudent(Student student) { this.student = student; }

    public int getScore() { return score; }
    public void setScore(int score) { this.score = score; }

    public String getResultCategory() { return resultCategory; }
    public void setResultCategory(String resultCategory) { this.resultCategory = resultCategory; }

    public LocalDateTime getTakenAt() { return takenAt; }
    public void setTakenAt(LocalDateTime takenAt) { this.takenAt = takenAt; }

    public String getResponseData() {
        return responseData;
    }

    public void setResponseData(String responseData) {
        this.responseData = responseData;
    }
}