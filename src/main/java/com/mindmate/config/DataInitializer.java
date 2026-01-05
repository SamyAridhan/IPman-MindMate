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
 * Optimized for DEMO: Guarantees data for Today/Tomorrow for immediate testing.
 *
 * @author Samy (A23CS0246)
 * @version Phase 3.5 - Fully Merged
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
            SystemAnalyticsDAO analyticsDAO,
            EducationalContentDAO educationalContentDAO,
            AssessmentDAO assessmentDAO) { // ✅ Merged: Added EducationalContentDAO
        
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
                
                seedCounselor(counselorDAO, "Dr. Sarah Johnson", "sarah.johnson@mindmate.com",
                    "Licensed Mental Health Counselor specializing in anxiety and depression",
                    "SJ", 4.8, "8 years", "High");
                
                seedCounselor(counselorDAO, "Dr. Michael Chen", "michael.chen@mindmate.com",
                    "Clinical Psychologist with focus on stress management",
                    "MC", 4.9, "12 years", "Medium");
                
                seedCounselor(counselorDAO, "Dr. Emily Rodriguez", "emily.rodriguez@mindmate.com",
                    "Therapist specializing in student mental health",
                    "ER", 4.7, "6 years", "Low");
                
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
                                LocalTime.of(8, 30), // Extended range to cover early birds
                                LocalTime.of(17, 30)
                            );
                            availabilityDAO.save(availability);
                        }
                    }
                }
                System.out.println("✅ Working hours set for all counselors");
            }

            // ==========================================
            // 3. SEED STUDENTS (12 Total)
            // ==========================================
            List<Student> students;
            if (studentDAO.count() < 12) {
                System.out.println("🎓 Seeding Students...");
                
                seedStudent(studentDAO, "Demo Student", "demo@student.mindmate.com");
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
                seedStudent(studentDAO, "Emma Williams", "A23CS0199@student.utm.my");
                
                System.out.println("✅ 12 Students created (Password: student123)");
            }
            students = studentDAO.findAll();

            // ==========================================
            // 4. SEED APPOINTMENTS (Demo & Distributed)
            // ==========================================
            if (appointmentDAO.count() < 30 && !students.isEmpty() && !counselors.isEmpty()) {
                System.out.println("📅 Seeding Appointments...");
                
                LocalDate today = LocalDate.now();
                
                // Get Key Actors
                Student demoStudent = students.stream()
                        .filter(s -> s.getEmail().equals("demo@student.mindmate.com"))
                        .findFirst()
                        .orElse(students.get(0));

                Counselor mainCounselor = counselors.get(0); // Sarah Johnson (Odd ID usually)
                Counselor secondaryCounselor = counselors.get(1); // Michael Chen

                // --- 1. DEMO SCENARIOS (Manually ensure these match the counselor's pattern) ---

                // A. TODAY: Confirmed
                LocalTime timeA = (mainCounselor.getId() % 2 != 0) ? LocalTime.of(14, 0) : LocalTime.of(14, 30);
                createAppointment(appointmentDAO, demoStudent, mainCounselor, 
                    today, timeA, "Video Call", 
                    Appointment.AppointmentStatus.CONFIRMED, "Looking forward to discussing my progress.", null);

                // B. TOMORROW: Pending
                LocalTime timeB = (mainCounselor.getId() % 2 != 0) ? LocalTime.of(10, 0) : LocalTime.of(10, 30);
                createAppointment(appointmentDAO, demoStudent, mainCounselor, 
                    today.plusDays(1), timeB, "Chat Session", 
                    Appointment.AppointmentStatus.PENDING, "Feeling anxious about upcoming exams.", null);

                // C. YESTERDAY: Completed
                LocalTime timeC = (secondaryCounselor.getId() % 2 != 0) ? LocalTime.of(11, 30) : LocalTime.of(10, 30);
                createAppointment(appointmentDAO, demoStudent, secondaryCounselor, 
                    today.minusDays(1), timeC, "Video Call", 
                    Appointment.AppointmentStatus.COMPLETED, "Initial consultation.", null);

                // D. 2 DAYS AGO: Denied
                LocalTime timeD = (secondaryCounselor.getId() % 2 != 0) ? LocalTime.of(8, 30) : LocalTime.of(9, 0);
                createAppointment(appointmentDAO, demoStudent, secondaryCounselor, 
                    today.minusDays(2), timeD, "Phone Call", 
                    Appointment.AppointmentStatus.DENIED, "Urgent request.", "I was on leave that day, sorry.");

                // --- 2. FILLER DATA (For Charts & Admin Dashboard) ---
                
                // COMPLETED: Spread over last 30 days
                seedRandomAppointments(appointmentDAO, students, counselors, 
                    today.minusDays(30), today.minusDays(1), 15, 
                    Appointment.AppointmentStatus.COMPLETED, false);
                
                // UPCOMING: Spread over next 14 days
                seedRandomAppointments(appointmentDAO, students, counselors, 
                    today.plusDays(2), today.plusDays(14), 10, 
                    Appointment.AppointmentStatus.CONFIRMED, false);

                // PENDING: Spread over next week
                seedRandomAppointments(appointmentDAO, students, counselors, 
                    today.plusDays(1), today.plusDays(7), 5, 
                    Appointment.AppointmentStatus.PENDING, false);
                
                System.out.println("✅ Appointments seeded: Demo scenarios + Filler data");
            }

            // ==========================================
            // 5. SEED ANALYTICS SNAPSHOTS (14 Daily Snapshots)
            // ==========================================
            if (analyticsDAO.findAll().size() < 14) {
                System.out.println("📊 Seeding Analytics Trends...");
                
                LocalDateTime startDate = LocalDateTime.now().minusDays(14);
                
                int currentUsers = 12; 
                int currentAppts = 20;
                int currentAssessments = 3400;
                
                for (int i = 0; i < 14; i++) {
                    SystemAnalytics snapshot = new SystemAnalytics();
                    
                    currentUsers += (i % 3 == 0) ? 1 : 0; 
                    currentAppts += random.nextInt(3);    
                    currentAssessments += random.nextInt(15);

                    snapshot.setTotalStudents(currentUsers - 5);
                    snapshot.setTotalCounselors(5);
                    snapshot.setTotalUsers(currentUsers);
                    snapshot.setActiveUsers((int)(currentUsers * (0.6 + (random.nextDouble() * 0.2)))); 
                    
                    snapshot.setTotalAppointments(currentAppts);
                    snapshot.setPendingAppointments(2 + random.nextInt(3));
                    snapshot.setConfirmedAppointments(5 + random.nextInt(5));
                    snapshot.setCancelledAppointments(1 + random.nextInt(2));
                    snapshot.setCompletedAppointments(currentAppts - 10); 
                    
                    snapshot.setAssessmentsTaken(currentAssessments);
                    snapshot.setForumPosts(1050 + (i * 5));
                    snapshot.setContentViews(5000 + (i * 45));
                    snapshot.setRecordedAt(startDate.plusDays(i));
                    
                    analyticsDAO.save(snapshot);
                }
                System.out.println("✅ Analytics trends seeded");
            }

            // ==========================================
            // 6. SEED EDUCATIONAL CONTENT (Team Member's Part)
            // ==========================================
            if (educationalContentDAO.findAll().isEmpty()) {
                System.out.println("📚 Seeding educational content...");

                Counselor counselor1 = counselorDAO.findByEmail("sarah.johnson@mindmate.com").orElse(null);
                Counselor counselor2 = counselorDAO.findByEmail("michael.chen@mindmate.com").orElse(null);
                Counselor counselor3 = counselorDAO.findByEmail("emily.rodriguez@mindmate.com").orElse(null);

                if (counselor1 == null || counselor2 == null || counselor3 == null) {
                    System.out.println("⚠️ Skipping educational content seeding because one or more counselors are missing.");
                } else {
                    List<EducationalContent> contents = List.of(
                            buildContent("Mastering Academic Stress",
                                    "Learn how to identify signs of burnout and manage your study load effectively.",
                                    "<h1>Coping with Academic Pressure</h1><p>Academic stress is a common experience...</p>",
                                    "Article", 50, counselor1),
                            buildContent("Quick 5-Minute Grounding Exercise",
                                    "A fast-acting video guide to help you find calm.",
                                    "https://www.youtube.com/watch?v=inpok4MKVLM",
                                    "Video", 25, counselor2),
                            buildContent("The Science of Better Sleep",
                                    "Why your brain needs rest and how to fix your sleep schedule.",
                                    "<h2>The 10-3-2-1-0 Rule for Sleep</h2><p>Sleep hygiene is essential...</p>",
                                    "Article", 40, counselor3),
                            buildContent("Overcoming Social Anxiety",
                                    "Tips for navigating social situations.",
                                    "<h1>Navigating Social Spaces</h1><p>Social anxiety isn't just being shy...</p>",
                                    "Article", 60, counselor1),
                            buildContent("The Pomodoro Technique Explained",
                                    "Watch how this simple timer method can double your productivity.",
                                    "https://www.youtube.com/watch?v=mNBmG24djoY",
                                    "Video", 30, counselor2),
                            buildContent("Building Unshakeable Self-Confidence",
                                    "How to stop the Inner Critic.",
                                    "<h2>Quieting the Inner Critic</h2><p>Practice self-compassion...</p>",
                                    "Article", 55, counselor3)
                    );

                    contents.forEach(educationalContentDAO::save);
                    System.out.println("✅ Seeded " + contents.size() + " educational content records.");
                }
            } else {
                System.out.println("✓ Educational content already exists.");
            }

            // ==========================================
            // 7. SEED ASSESSMENTS (For Demo Student)
            // ==========================================
            if (assessmentDAO.findAll().isEmpty()) {
                System.out.println("📝 Seeding Assessments...");

                Student demoStudent = studentDAO.findByEmail("demo@student.mindmate.com").orElse(null);
                
                if (demoStudent != null) {
                    // 1. Severe (High Risk) - Last week
                    Assessment a1 = new Assessment(demoStudent, 14);
                    a1.setResultCategory("Severe"); 
                    a1.setTakenAt(LocalDateTime.now().minusDays(7));
                    a1.setResponseData("3,3,3,2,3");
                    assessmentDAO.save(a1);

                    // 2. Moderate Risk - 3 days ago
                    Assessment a2 = new Assessment(demoStudent, 12);
                    a2.setResultCategory("Moderate");
                    a2.setTakenAt(LocalDateTime.now().minusDays(3));
                    a2.setResponseData("2,1,1,2,3");
                    assessmentDAO.save(a2);

                    // 3. Minimal Risk - Today
                    Assessment a3 = new Assessment(demoStudent, 4);
                    a3.setResultCategory("Minimal");
                    a3.setTakenAt(LocalDateTime.now().minusHours(2));
                    a3.setResponseData("1,0,1,1,1");
                    assessmentDAO.save(a3);
                    
                    System.out.println("✅ Seeded 3 assessments for Demo Student.");
                }
            } else {
                 System.out.println("✓ Assessments already exist.");
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
        
        // Initialize gamification fields (from Team Member's model)
        student.setCurrentStreak(0);
        student.setTotalPoints(0);
        student.setLastCompletionDate(null);
        
        dao.save(student);
    }

    private void createAppointment(AppointmentDAO dao, Student student, Counselor counselor,
                                   LocalDate date, LocalTime time, String type,
                                   Appointment.AppointmentStatus status, String notes, String denialReason) {
        Appointment apt = new Appointment();
        apt.setStudent(student);
        apt.setCounselor(counselor);
        apt.setCounselorName(counselor.getName());
        apt.setDate(date);
        apt.setTime(time);
        apt.setSessionType(type);
        apt.setStatus(status);
        apt.setNotes(notes);
        apt.setDenialReason(denialReason);
        dao.save(apt);
    }

    private void seedRandomAppointments(AppointmentDAO dao, List<Student> students, List<Counselor> counselors,
                                        LocalDate startDate, LocalDate endDate, int count,
                                        Appointment.AppointmentStatus status, boolean isDenial) {
        
        String[] sessionTypes = {"Video Call", "Chat Session", "Phone Call"};
        
        // Pattern A (Odd IDs): 8:30, 10:00, 11:30, 14:00, 15:30
        LocalTime[] oddTimes = {
            LocalTime.of(8, 30), LocalTime.of(10, 0), LocalTime.of(11, 30),
            LocalTime.of(14, 0), LocalTime.of(15, 30)
        };

        // Pattern B (Even IDs): 9:00, 10:30, 14:30, 16:00
        LocalTime[] evenTimes = {
            LocalTime.of(9, 0), LocalTime.of(10, 30), 
            LocalTime.of(14, 30), LocalTime.of(16, 0)
        };
        
        int created = 0;
        int maxAttempts = count * 3; 
        
        for (int i = 0; i < maxAttempts && created < count; i++) {
            long days = endDate.toEpochDay() - startDate.toEpochDay();
            LocalDate randomDate = startDate.plusDays(random.nextInt((int)days + 1));
            
            if (randomDate.getDayOfWeek() == DayOfWeek.SATURDAY || randomDate.getDayOfWeek() == DayOfWeek.SUNDAY) {
                continue;
            }

            Counselor counselor = counselors.get(random.nextInt(counselors.size()));
            Student student = students.get(random.nextInt(students.size())); 
            
            // ✅ DYNAMIC TIME SELECTION BASED ON ID
            LocalTime time;
            if (counselor.getId() % 2 != 0) {
                time = oddTimes[random.nextInt(oddTimes.length)];
            } else {
                time = evenTimes[random.nextInt(evenTimes.length)];
            }

            if (dao.existsByCounselorAndDateAndTime(counselor, randomDate, time)) {
                continue;
            }

            Appointment apt = new Appointment();
            apt.setStudent(student);
            apt.setCounselor(counselor);
            apt.setCounselorName(counselor.getName());
            apt.setDate(randomDate);
            apt.setTime(time);
            apt.setSessionType(sessionTypes[random.nextInt(sessionTypes.length)]);
            apt.setStatus(status);
            apt.setNotes("Automated test appointment " + i);
            
            if (isDenial) {
                apt.setDenialReason("Counselor unavailable.");
            }

            dao.save(apt);
            created++;
        }
    }

    // Helper for Educational Content
    private EducationalContent buildContent(String title, String description, String body, String type, int points, Counselor author) {
        EducationalContent content = new EducationalContent();
        content.setTitle(title);
        content.setDescription(description);
        content.setContentBody(body);
        content.setContentType(type);
        content.setPointsValue(points);
        content.setAuthor(author);
        return content;
    }
}