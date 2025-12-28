// src/main/java/com/mindmate/model/Counselor.java

package com.mindmate.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import java.time.LocalDateTime;

/**
 * Entity representing a mental health counselor.
 * Manages counselor profile data and availability.
 */
@Entity
@Table(name = "counselors")
public class Counselor {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Column(nullable = false)
    private String name;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    @Column(unique = true, nullable = false)
    private String email;

    @Column(length = 500)
    private String specialization;

    @Column(length = 10)
    private String avatar; // e.g., "SJ" for initials

    // FIXED: Removed 'scale' and 'precision' attributes for Double type
    // to prevent "scale has no meaning" error during startup.
    @Column
    private Double rating; // e.g., 4.8

    @Column(length = 50)
    private String experience; // e.g., "8 years"

    @Column(length = 20)
    private String availability; // e.g., "High", "Medium", "Low"

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // Lifecycle callback
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Constructors
    public Counselor() {}

    public Counselor(String name, String email, String specialization) {
        this.name = name;
        this.email = email;
        this.specialization = specialization;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Double getRating() {
        return rating;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Counselor{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", specialization='" + specialization + '\'' +
                ", rating=" + rating +
                '}';
    }
}