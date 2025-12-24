// src/main/java/com/mindmate/config/DataInitializer.java

package com.mindmate.config;

import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.repository.CounselorRepository;
import com.mindmate.repository.StudentRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for initializing database with seed data.
 * Runs automatically on application startup.
 * 
 * @author Samy (A23CS0246)
 */
@Configuration
public class DataInitializer {

    /**
     * Initializes the database with sample counselors and students.
     * Only runs if tables are empty to avoid duplicate data.
     * 
     * @param counselorRepo Repository for counselor data
     * @param studentRepo Repository for student data
     * @return CommandLineRunner that executes on startup
     */
    @Bean
    CommandLineRunner initDatabase(CounselorRepository counselorRepo, 
                                   StudentRepository studentRepo) {
        return args -> {
            
            // Seed counselors if table is empty
            if (counselorRepo.count() == 0) {
                System.out.println("📚 Initializing counselor data...");
                
                // Counselor 1: Dr. Sarah Johnson
                Counselor counselor1 = new Counselor(
                    "Dr. Sarah Johnson", 
                    "sarah.johnson@mindmate.com", 
                    "Licensed Mental Health Counselor specializing in anxiety and depression"
                );
                counselor1.setAvatar("SJ");
                counselor1.setRating(4.8);
                counselor1.setExperience("8 years");
                counselor1.setAvailability("High");
                counselorRepo.save(counselor1);
                
                // Counselor 2: Dr. Michael Chen
                Counselor counselor2 = new Counselor(
                    "Dr. Michael Chen", 
                    "michael.chen@mindmate.com", 
                    "Clinical Psychologist with focus on stress management and coping strategies"
                );
                counselor2.setAvatar("MC");
                counselor2.setRating(4.9);
                counselor2.setExperience("12 years");
                counselor2.setAvailability("Medium");
                counselorRepo.save(counselor2);
                
                // Counselor 3: Dr. Emily Rodriguez
                Counselor counselor3 = new Counselor(
                    "Dr. Emily Rodriguez", 
                    "emily.rodriguez@mindmate.com", 
                    "Therapist specializing in student mental health and academic stress"
                );
                counselor3.setAvatar("ER");
                counselor3.setRating(4.7);
                counselor3.setExperience("6 years");
                counselor3.setAvailability("Low");
                counselorRepo.save(counselor3);
                
                System.out.println("✅ Counselor data initialized successfully");
            }

            // Seed demo student if table is empty
            if (studentRepo.count() == 0) {
                System.out.println("📚 Initializing student data...");
                
                Student demoStudent = new Student(
                    "Demo Student", 
                    "demo@student.mindmate.com"
                );
                studentRepo.save(demoStudent);
                
                System.out.println("✅ Student data initialized successfully");
            }
            
            System.out.println("🚀 Database initialization complete!");
        };
    }
}