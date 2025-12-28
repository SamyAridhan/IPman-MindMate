// src/main/java/com/mindmate/config/DataInitializer.java

package com.mindmate.config;

import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class for initializing database with seed data.
 * Runs automatically on application startup.
 * NOW USES DAO PATTERN instead of Repository.
 * 
 * @author Samy (A23CS0246)
 */
@Configuration
public class DataInitializer {

    /**
     * Initializes the database with sample counselors and students.
     * Only runs if tables are empty to avoid duplicate data.
     */
    @Bean
    CommandLineRunner initDatabase(CounselorDAO counselorDAO, StudentDAO studentDAO) {
        return args -> {
            
            // Check if already initialized
            if (studentDAO.count() > 0) {
                System.out.println("✓ Database already initialized. Skipping data seeding.");
                return;
            }
            
            System.out.println("=== INITIALIZING MINDMATE TEST DATA ===");
            
            // Seed counselors
            System.out.println("📚 Seeding counselors...");
            
            Counselor counselor1 = new Counselor(
                "Dr. Sarah Johnson", 
                "sarah.johnson@mindmate.com", 
                "Licensed Mental Health Counselor specializing in anxiety and depression"
            );
            counselor1.setAvatar("SJ");
            counselor1.setRating(4.8);
            counselor1.setExperience("8 years");
            counselor1.setAvailability("High");
            counselorDAO.save(counselor1);
            System.out.println("✓ Created counselor: Dr. Sarah Johnson");
            
            Counselor counselor2 = new Counselor(
                "Dr. Michael Chen", 
                "michael.chen@mindmate.com", 
                "Clinical Psychologist with focus on stress management"
            );
            counselor2.setAvatar("MC");
            counselor2.setRating(4.9);
            counselor2.setExperience("12 years");
            counselor2.setAvailability("Medium");
            counselorDAO.save(counselor2);
            System.out.println("✓ Created counselor: Dr. Michael Chen");
            
            Counselor counselor3 = new Counselor(
                "Dr. Emily Rodriguez", 
                "emily.rodriguez@mindmate.com", 
                "Therapist specializing in student mental health"
            );
            counselor3.setAvatar("ER");
            counselor3.setRating(4.7);
            counselor3.setExperience("6 years");
            counselor3.setAvailability("Low");
            counselorDAO.save(counselor3);
            System.out.println("✓ Created counselor: Dr. Emily Rodriguez");
            
            // Seed demo student
            System.out.println("📚 Seeding students...");
            Student demoStudent = new Student("Demo Student", "demo@student.mindmate.com");
            studentDAO.save(demoStudent);
            System.out.println("✓ Created student: Demo Student");
            
            System.out.println("=== TEST DATA INITIALIZATION COMPLETE ===");
        };
    }
}