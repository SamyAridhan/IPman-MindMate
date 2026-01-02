// src/main/java/com/mindmate/config/DataInitializer.java

package com.mindmate.config;

import com.mindmate.dao.*;
import com.mindmate.model.*;
import com.mindmate.util.PasswordUtil;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

/**
 * Enhanced Data Initializer with comprehensive test data
 * Populates database with realistic Malaysian/UTM-themed test data
 * Updated: Ensures logical consistency between CANCELLED and DENIED statuses.
 * * @author Samy (A23CS0246)
 * @version Phase 3.1 - Fixed Logic
 */
@Configuration
public class DataInitializer {

    private static final Random random = new Random(42); // Fixed seed for consistent data

    @Bean
    CommandLineRunner initDatabase(
            AdminDAO adminDAO,
            CounselorDAO counselorDAO,
            StudentDAO studentDAO,
            CounselorAvailabilityDAO availabilityDAO,
            AppointmentDAO appointmentDAO,
            SystemAnalyticsDAO analyticsDAO) {
        
        return args -> {
            System.out.println("=== INITIALIZING MINDMATE TEST DATA ===");

            // ==========================================
            // 1. SEED ADMIN
            // ==========================================
            if (adminDAO.count() == 0) {
                System.out.println("🔐 Seeding Admin Account...");
                Admin admin = new Admin();
                admin.setName("System Administrator");
                admin.setEmail("admin@mindmate.com");
                admin.setPassword(PasswordUtil.hashPassword("admin123"));
                adminDAO.save(admin);
                System.out.println("✅ Admin: admin@mindmate.com / admin123");
            }

            // ==========================================
            // 2. SEED COUNSELORS (5 Total)
            // ==========================================
            List<Counselor> counselors;
            if (counselorDAO.count() < 5) {
                System.out.println("👨‍⚕️ Seeding Counselors...");
                
                // Existing 3
                seedCounselor(counselorDAO, "Dr. Sarah Johnson", "sarah.johnson@mindmate.com",
                    "Licensed Mental Health Counselor specializing in anxiety and depression",
                    "SJ", 4.8, "8 years", "High");
                
                seedCounselor(counselorDAO, "Dr. Michael Chen", "michael.chen@mindmate.com",
                    "Clinical Psychologist with focus on stress management",
                    "MC", 4.9, "12 years", "Medium");
                
                seedCounselor(counselorDAO, "Dr. Emily Rodriguez", "emily.rodriguez@mindmate.com",
                    "Therapist specializing in student mental health",
                    "ER", 4.7, "6 years", "Low");
                
                // New 2
                seedCounselor(counselorDAO, "Dr. Ahmad Faiz", "ahmad.faiz@mindmate.com",
                    "Counselor specializing in academic stress and career guidance",
                    "AF", 4.6, "5 years", "High");
                
                seedCounselor(counselorDAO, "Dr. Lisa Tan", "lisa.tan@mindmate.com",
                    "Licensed therapist focusing on relationship and social anxiety",
                    "LT", 4.9, "10 years", "Medium");
                
                System.out.println("✅ 5 Counselors created (Password: counselor123)");
            }

            // ==========================================
            // 2.5 SEED COUNSELOR AVAILABILITY
            // ==========================================
            counselors = counselorDAO.findAll();
            if (!counselors.isEmpty()) {
                System.out.println("📅 Setting Counselor Availability...");
                
                for (Counselor counselor : counselors) {
                    List<CounselorAvailability> existing = availabilityDAO.findByCounselor(counselor);
                    
                    if (existing.isEmpty()) {
                        DayOfWeek[] workDays = {
                            DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY,
                            DayOfWeek.THURSDAY, DayOfWeek.FRIDAY
                        };
                        
                        for (DayOfWeek day : workDays) {
                            CounselorAvailability availability = new CounselorAvailability(
                                counselor, day,
                                LocalTime.of(9, 0),
                                LocalTime.of(17, 0)
                            );
                            availabilityDAO.save(availability);
                        }
                    }
                }
                System.out.println("✅ Working hours (Mon-Fri, 9AM-5PM) set for all counselors");
            }

            // ==========================================
            // 3. SEED STUDENTS (12 Total)
            // ==========================================
            List<Student> students;
            if (studentDAO.count() < 12) {
                System.out.println("🎓 Seeding Students...");
                
                // Malaysian Names (UTM-themed)
                seedStudent(studentDAO, "Ahmad Zafran Hakim", "A23CS0101@student.utm.my");
                seedStudent(studentDAO, "Nurul Aina Sofiya", "A23CS0102@student.utm.my");
                seedStudent(studentDAO, "Tan Wei Xuan", "A23CS0103@student.utm.my");
                seedStudent(studentDAO, "Siti Nur Fatimah", "A23CS0104@student.utm.my");
                seedStudent(studentDAO, "Lee Chong Wei", "A23CS0105@student.utm.my");
                seedStudent(studentDAO, "Kavitha Devi", "A23CS0106@student.utm.my");
                seedStudent(studentDAO, "Muhammad Hafiz", "A23CS0107@student.utm.my");
                seedStudent(studentDAO, "Chong Mei Ling", "A23CS0108@student.utm.my");
                seedStudent(studentDAO, "Raj Kumar Singh", "A23CS0109@student.utm.my");
                seedStudent(studentDAO, "Lim Xiao Hui", "A23CS0110@student.utm.my");
                
                // Keep demo student + add international
                seedStudent(studentDAO, "Demo Student", "demo@student.mindmate.com");
                seedStudent(studentDAO, "Emma Williams", "A23CS0199@student.utm.my");
                
                System.out.println("✅ 12 Students created (Password: student123)");
            }
            students = studentDAO.findAll();

            // ==========================================
            // 4. SEED APPOINTMENTS (30 Total - Realistic Distribution)
            // ==========================================
            if (appointmentDAO.count() < 30 && !students.isEmpty() && !counselors.isEmpty()) {
                System.out.println("📅 Seeding Appointments...");
                
                LocalDate today = LocalDate.now();
                
                // Get the Demo Student specifically to ensure you see these in your dashboard
                Student demoStudent = students.stream()
                        .filter(s -> s.getEmail().equals("demo@student.mindmate.com"))
                        .findFirst()
                        .orElse(students.get(0));

                Counselor demoCounselor = counselors.get(0);
                Counselor demoCounselor2 = counselors.get(1);

                // --- 1. Specific Demo: DENIED APPOINTMENT (To test Red Badge + Noted Button) ---
                // Logic: Status=DENIED, DenialReason=Filled
                Appointment deniedAppt = new Appointment();
                deniedAppt.setStudent(demoStudent);
                deniedAppt.setCounselor(demoCounselor);
                deniedAppt.setCounselorName(demoCounselor.getName());
                deniedAppt.setDate(today.plusDays(2));
                deniedAppt.setTime(LocalTime.of(10, 0));
                deniedAppt.setSessionType("Video Call");
                deniedAppt.setStatus(Appointment.AppointmentStatus.DENIED); 
                deniedAppt.setNotes("Need urgent help.");
                deniedAppt.setDenialReason("I am fully booked that morning, please choose afternoon."); // ✅ Correct
                appointmentDAO.save(deniedAppt);

                // --- 2. Specific Demo: CANCELLED APPOINTMENT (To test status) ---
                // Logic: Status=CANCELLED, Notes=Student Reason, DenialReason=NULL
                Appointment cancelledAppt = new Appointment();
                cancelledAppt.setStudent(demoStudent);
                cancelledAppt.setCounselor(demoCounselor2);
                cancelledAppt.setCounselorName(demoCounselor2.getName());
                cancelledAppt.setDate(today.plusDays(3));
                cancelledAppt.setTime(LocalTime.of(14, 0));
                cancelledAppt.setSessionType("Chat Session");
                cancelledAppt.setStatus(Appointment.AppointmentStatus.CANCELLED);
                cancelledAppt.setNotes("I have a class test at this time."); // ✅ Correct
                cancelledAppt.setDenialReason(null); // ✅ Correct
                appointmentDAO.save(cancelledAppt);

                // --- 3. Specific Demo: PENDING APPOINTMENT ---
                Appointment pendingAppt = new Appointment();
                pendingAppt.setStudent(demoStudent);
                pendingAppt.setCounselor(demoCounselor);
                pendingAppt.setCounselorName(demoCounselor.getName());
                pendingAppt.setDate(today.plusDays(5));
                pendingAppt.setTime(LocalTime.of(9, 0));
                pendingAppt.setSessionType("In-Person");
                pendingAppt.setStatus(Appointment.AppointmentStatus.PENDING);
                appointmentDAO.save(pendingAppt);

                // --- 4. Fill rest with random data ---
                
                // --- COMPLETED (6) - Last 2 weeks ---
                seedAppointments(appointmentDAO, students, counselors, 
                    today.minusDays(14), today.minusDays(1), 6, 
                    Appointment.AppointmentStatus.COMPLETED, "Past session completed", false);
                
                // --- CONFIRMED (10) - This week + Next week ---
                seedAppointments(appointmentDAO, students, counselors,
                    today.plusDays(1), today.plusDays(10), 10,
                    Appointment.AppointmentStatus.CONFIRMED, "Appointment confirmed by counselor", false);
                
                System.out.println("✅ Appointments created (Includes Denied/Cancelled demo cases)");
            }

            // ==========================================
            // 5. SEED ANALYTICS SNAPSHOTS (12 Daily Snapshots)
            // ==========================================
            if (analyticsDAO.findAll().size() < 12) {
                System.out.println("📊 Seeding Analytics History...");
                
                LocalDateTime startDate = LocalDateTime.now().minusDays(12);
                int baseUsers = 8; 
                int baseAppointments = 15;
                int baseActive = 5;
                
                for (int i = 0; i < 12; i++) {
                    SystemAnalytics snapshot = new SystemAnalytics();
                    
                    snapshot.setTotalStudents(baseUsers + i);
                    snapshot.setTotalCounselors(5);
                    snapshot.setTotalUsers(baseUsers + i + 5);
                    snapshot.setActiveUsers(baseActive + (i / 3));
                    
                    // Appointment metrics
                    snapshot.setTotalAppointments(baseAppointments + (i * 2));
                    snapshot.setPendingAppointments(3 + random.nextInt(6));
                    snapshot.setConfirmedAppointments(5 + random.nextInt(8));
                    snapshot.setCancelledAppointments(1 + random.nextInt(4));
                    snapshot.setCompletedAppointments(baseAppointments - 10 + (i * 2));
                    
                    // Module metrics
                    snapshot.setAssessmentsTaken(3400 + (i * 20));
                    snapshot.setForumPosts(1050 + (i * 15));
                    snapshot.setContentViews(5300 + (i * 50));
                    
                    // Set recorded date
                    LocalDateTime recordedAt = startDate.plusDays(i);
                    snapshot.setRecordedAt(recordedAt);
                    
                    analyticsDAO.save(snapshot);
                }
                
                System.out.println("✅ 12 Analytics snapshots created (last 12 days)");
            }

            System.out.println("=== DATA INITIALIZATION COMPLETE ===");
            System.out.println("");
            System.out.println("📌 TEST ACCOUNTS:");
            System.out.println("   Admin:     admin@mindmate.com / admin123");
            System.out.println("   Counselor: sarah.johnson@mindmate.com / counselor123");
            System.out.println("   Student:   demo@student.mindmate.com / student123");
        };
    }

    // ==========================================
    // HELPER METHODS
    // ==========================================

    private void seedCounselor(CounselorDAO dao, String name, String email, String specialization,
                               String avatar, double rating, String experience, String availability) {
        Counselor counselor = new Counselor(name, email, specialization);
        counselor.setAvatar(avatar);
        counselor.setRating(rating);
        counselor.setExperience(experience);
        counselor.setAvailability(availability);
        counselor.setPassword(PasswordUtil.hashPassword("counselor123"));
        dao.save(counselor);
    }

    private void seedStudent(StudentDAO dao, String name, String email) {
        Student student = new Student(name, email);
        student.setPassword(PasswordUtil.hashPassword("student123"));
        dao.save(student);
    }

    private int seedAppointments(AppointmentDAO dao, List<Student> students, List<Counselor> counselors,
                                 LocalDate startDate, LocalDate endDate, int count,
                                 Appointment.AppointmentStatus status, String notes, boolean isDenial) {
        
        String[] sessionTypes = {"Video Call", "Chat Session", "Phone Call"};
        LocalTime[] times = {
            LocalTime.of(9, 0), LocalTime.of(10, 0), LocalTime.of(11, 0),
            LocalTime.of(13, 0), LocalTime.of(14, 0), LocalTime.of(15, 0), LocalTime.of(16, 0)
        };
        
        int created = 0;
        LocalDate currentDate = startDate;
        int attempts = 0; 
        
        while (created < count && !currentDate.isAfter(endDate) && attempts < 100) {
            // Skip weekends
            if (currentDate.getDayOfWeek() == DayOfWeek.SATURDAY || 
                currentDate.getDayOfWeek() == DayOfWeek.SUNDAY) {
                currentDate = currentDate.plusDays(1);
                continue;
            }
            
            Counselor counselor = counselors.get(random.nextInt(counselors.size()));
            LocalTime time = times[random.nextInt(times.length)];
            
            Appointment appointment = new Appointment();
            appointment.setStudent(students.get(random.nextInt(students.size())));
            appointment.setCounselor(counselor);
            appointment.setCounselorName(counselor.getName());
            
            appointment.setDate(currentDate);
            appointment.setTime(time);
            appointment.setSessionType(sessionTypes[random.nextInt(sessionTypes.length)]);
            appointment.setStatus(status);
            appointment.setNotes(notes);
            
            // ✅ Only set Denial Reason if logic dictates (Student Cancellation is NOT a denial)
            if (isDenial) {
                 appointment.setDenialReason("Counselor unavailable at this time.");
            } else {
                 appointment.setDenialReason(null);
            }
            
            dao.save(appointment);
            created++;
            
            currentDate = currentDate.plusDays(random.nextInt(3) + 1);
            attempts++;
        }
        
        return created;
    }
}