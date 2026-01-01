// src/main/java/com/mindmate/config/DataInitializer.java

package com.mindmate.config;

import com.mindmate.dao.AdminDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.dao.CounselorAvailabilityDAO; // ✅ NEW IMPORT
import com.mindmate.model.Admin;
import com.mindmate.model.Counselor;
import com.mindmate.model.Student;
import com.mindmate.model.CounselorAvailability; // ✅ NEW IMPORT
import com.mindmate.util.PasswordUtil;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.DayOfWeek; // ✅ NEW IMPORT
import java.time.LocalTime; // ✅ NEW IMPORT
import java.util.List;      // ✅ NEW IMPORT

/**
 * Configuration class for initializing database with seed data.
 * Runs automatically on application startup.
 * Handles password hashing for all seeded users.
 * * @author Samy (A23CS0246)
 */
@Configuration
public class DataInitializer {

    /**
     * Initializes the database with Admin, Counselors, Student, AND Availability.
     * Checks each table individually to ensure complete data seeding.
     */
    @Bean
    CommandLineRunner initDatabase(AdminDAO adminDAO, 
                                   CounselorDAO counselorDAO, 
                                   StudentDAO studentDAO,
                                   CounselorAvailabilityDAO availabilityDAO) { // ✅ INJECT NEW DAO
        return args -> {
            System.out.println("=== INITIALIZING MINDMATE DATA ===");

            // ==========================================
            // 1. SEED ADMIN
            // ==========================================
            if (adminDAO.count() == 0) {
                System.out.println("🌱 Seeding Default Admin...");
                Admin admin = new Admin();
                admin.setName("System Administrator");
                admin.setEmail("admin@mindmate.com");
                // Hash the password
                admin.setPassword(PasswordUtil.hashPassword("admin123"));
                
                adminDAO.save(admin);
                System.out.println("✅ Admin created: admin@mindmate.com / admin123");
            } else {
                System.out.println("✓ Admin data already exists.");
            }

            // ==========================================
            // 2. SEED COUNSELORS
            // ==========================================
            if (counselorDAO.count() == 0) {
                System.out.println("📚 Seeding counselors...");

                // Counselor 1: Sarah
                Counselor c1 = new Counselor(
                    "Dr. Sarah Johnson", 
                    "sarah.johnson@mindmate.com", 
                    "Licensed Mental Health Counselor specializing in anxiety and depression"
                );
                c1.setAvatar("SJ");
                c1.setRating(4.8);
                c1.setExperience("8 years");
                c1.setAvailability("High");
                c1.setPassword(PasswordUtil.hashPassword("counselor123"));
                counselorDAO.save(c1);

                // Counselor 2: Michael
                Counselor c2 = new Counselor(
                    "Dr. Michael Chen", 
                    "michael.chen@mindmate.com", 
                    "Clinical Psychologist with focus on stress management"
                );
                c2.setAvatar("MC");
                c2.setRating(4.9);
                c2.setExperience("12 years");
                c2.setAvailability("Medium");
                c2.setPassword(PasswordUtil.hashPassword("counselor123"));
                counselorDAO.save(c2);

                // Counselor 3: Emily
                Counselor c3 = new Counselor(
                    "Dr. Emily Rodriguez", 
                    "emily.rodriguez@mindmate.com", 
                    "Therapist specializing in student mental health"
                );
                c3.setAvatar("ER");
                c3.setRating(4.7);
                c3.setExperience("6 years");
                c3.setAvailability("Low");
                c3.setPassword(PasswordUtil.hashPassword("counselor123"));
                counselorDAO.save(c3);

                System.out.println("✅ 3 Counselors created (Password: counselor123)");
            } else {
                System.out.println("✓ Counselor data already exists.");
            }

            // ==========================================
            // 2.5 SEED COUNSELOR AVAILABILITY (✅ NEW SECTION)
            // ==========================================
            List<Counselor> allCounselors = counselorDAO.findAll();
            if (!allCounselors.isEmpty()) {
                System.out.println("📅 Checking counselor availability...");
                
                for (Counselor counselor : allCounselors) {
                    // Check if this counselor already has availability set
                    // Note: This works perfectly with your DAO which filters by 'isActive=true'
                    List<CounselorAvailability> existing = availabilityDAO.findByCounselor(counselor);
                    
                    if (existing.isEmpty()) {
                        // Set Monday-Friday, 9 AM - 5 PM for all counselors
                        DayOfWeek[] workDays = {
                            DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY,
                            DayOfWeek.THURSDAY, DayOfWeek.FRIDAY
                        };
                        
                        for (DayOfWeek day : workDays) {
                            CounselorAvailability availability = new CounselorAvailability(
                                counselor,
                                day,
                                LocalTime.of(9, 0),  // 9:00 AM
                                LocalTime.of(17, 0)  // 5:00 PM
                            );
                            // Assuming your Model defaults 'isActive' to true, or the constructor handles it.
                            availabilityDAO.save(availability);
                        }
                        
                        System.out.println("   ✓ Set working hours (9-5) for " + counselor.getName());
                    }
                }
                
                System.out.println("✅ Counselor availability check complete.");
            } else {
                System.out.println("✓ No counselors found to set availability.");
            }

            // ==========================================
            // 3. SEED STUDENT
            // ==========================================
            if (studentDAO.count() == 0) {
                System.out.println("📚 Seeding demo student...");
                
                Student demoStudent = new Student("Demo Student", "demo@student.mindmate.com");
                demoStudent.setPassword(PasswordUtil.hashPassword("student123"));
                
                studentDAO.save(demoStudent);
                System.out.println("✅ Student created: demo@student.mindmate.com / student123");
            } else {
                System.out.println("✓ Student data already exists.");
            }

            System.out.println("=== DATA INITIALIZATION COMPLETE ===");
        };
    }
}