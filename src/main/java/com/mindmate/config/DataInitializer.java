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
 * @version Phase 3.4 - Synced with Counselor Schedules
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

                Counselor mainCounselor = counselors.get(0); // Sarah Johnson (Odd ID usually, check DB)
                Counselor secondaryCounselor = counselors.get(1); // Michael Chen

                // --- 1. DEMO SCENARIOS (Manually ensure these match the counselor's pattern) ---
                // Assuming ID generation starts at 1 (Odd) -> Pattern A (8:30, 10:00...)
                // Assuming ID generation continues to 2 (Even) -> Pattern B (9:00, 10:30...)

                // A. TODAY: Confirmed (Using 14:00 for Odd / 14:30 for Even)
                LocalTime timeA = (mainCounselor.getId() % 2 != 0) ? LocalTime.of(14, 0) : LocalTime.of(14, 30);
                createAppointment(appointmentDAO, demoStudent, mainCounselor, 
                    today, timeA, "Video Call", 
                    Appointment.AppointmentStatus.CONFIRMED, "Looking forward to discussing my progress.", null);

                // B. TOMORROW: Pending (Using 10:00 for Odd / 10:30 for Even)
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

    // ✅ FIXED: Helper now respects the Odd/Even counselor ID timing logic
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
}