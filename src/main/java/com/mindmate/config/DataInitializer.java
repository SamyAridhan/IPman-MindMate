// src/main/java/com/mindmate/config/DataInitializer.java

package com.mindmate.config;

import com.mindmate.dao.AdminDAO;
import com.mindmate.dao.CounselorDAO;
import com.mindmate.dao.EducationalContentDAO;
import com.mindmate.dao.StudentDAO;
import com.mindmate.model.Admin;
import com.mindmate.model.Counselor;
import com.mindmate.model.EducationalContent;
import com.mindmate.model.Student;
import com.mindmate.util.PasswordUtil; // ✅ Import PasswordUtil
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import java.util.List;

/**
 * Configuration class for initializing database with seed data.
 * Runs automatically on application startup.
 * Handles password hashing for all seeded users.
 * * @author Samy (A23CS0246)
 */
@Configuration
public class DataInitializer {

    /**
     * Initializes the database with Admin, Counselors, and Student.
     * Checks each table individually to ensure complete data seeding.
     */
    @Bean
    CommandLineRunner initDatabase(AdminDAO adminDAO, CounselorDAO counselorDAO, StudentDAO studentDAO,
            EducationalContentDAO educationalContentDAO) {
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
                // ✅ Hash the password
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
                        "Licensed Mental Health Counselor specializing in anxiety and depression");
                c1.setAvatar("SJ");
                c1.setRating(4.8);
                c1.setExperience("8 years");
                c1.setAvailability("High");
                c1.setPassword(PasswordUtil.hashPassword("counselor123")); // ✅ Hash password
                counselorDAO.save(c1);

                // Counselor 2: Michael
                Counselor c2 = new Counselor(
                        "Dr. Michael Chen",
                        "michael.chen@mindmate.com",
                        "Clinical Psychologist with focus on stress management");
                c2.setAvatar("MC");
                c2.setRating(4.9);
                c2.setExperience("12 years");
                c2.setAvailability("Medium");
                c2.setPassword(PasswordUtil.hashPassword("counselor123")); // ✅ Hash password
                counselorDAO.save(c2);

                // Counselor 3: Emily
                Counselor c3 = new Counselor(
                        "Dr. Emily Rodriguez",
                        "emily.rodriguez@mindmate.com",
                        "Therapist specializing in student mental health");
                c3.setAvatar("ER");
                c3.setRating(4.7);
                c3.setExperience("6 years");
                c3.setAvailability("Low");
                c3.setPassword(PasswordUtil.hashPassword("counselor123")); // ✅ Hash password
                counselorDAO.save(c3);

                System.out.println("✅ 3 Counselors created (Password: counselor123)");
            } else {
                System.out.println("✓ Counselor data already exists.");
            }

            // ==========================================
            // 3. SEED STUDENT
            // ==========================================
            if (studentDAO.count() == 0) {
                System.out.println("📚 Seeding demo student...");

                Student demoStudent = new Student("Demo Student", "demo@student.mindmate.com");
                demoStudent.setPassword(PasswordUtil.hashPassword("student123")); // ✅ Hash password

                // Initialize gamification fields
                demoStudent.setCurrentStreak(0);
                demoStudent.setTotalPoints(0);
                demoStudent.setLastCompletionDate(null);

                studentDAO.save(demoStudent);
                System.out.println("✅ Student created: demo@student.mindmate.com / student123");
                System.out.println("   - Current Streak: 0");
                System.out.println("   - Total Points: 0");
                System.out.println("   - Last Completion Date: NULL");
            } else {
                System.out.println("✓ Student data already exists.");
            }

            // ==========================================
            // 4. SEED EDUCATIONAL CONTENT
            // ==========================================
            if (educationalContentDAO.findAll().isEmpty()) {
                System.out.println("Seeding educational content...");

                Counselor counselor1 = counselorDAO.findByEmail("sarah.johnson@mindmate.com").orElse(null);
                Counselor counselor2 = counselorDAO.findByEmail("michael.chen@mindmate.com").orElse(null);
                Counselor counselor3 = counselorDAO.findByEmail("emily.rodriguez@mindmate.com").orElse(null);

                if (counselor1 == null || counselor2 == null || counselor3 == null) {
                    System.out.println(
                            "⚠️ Skipping educational content seeding because one or more counselors are missing.");
                } else {
                    List<EducationalContent> contents = List.of(
                            buildContent(
                                    "Mastering Academic Stress",
                                    "Learn how to identify signs of burnout and manage your study load effectively.",
                                    """
                                            <h1>Coping with Academic Pressure</h1><p>Academic stress is a common experience for students, but it doesn't have to be overwhelming.</p><h2>Top 3 Strategies:</h2><ul><li><strong>Prioritization:</strong> Use the Eisenhower Matrix to separate urgent tasks from important ones.</li><li><strong>The 50/10 Rule:</strong> Study for 50 minutes, then take a 10-minute complete break away from screens.</li><li><strong>Physical Activity:</strong> Just 20 minutes of walking can significantly lower cortisol levels.</li></ul>
                                            """,
                                    "Article",
                                    50,
                                    counselor1),
                            buildContent(
                                    "Quick 5-Minute Grounding Exercise",
                                    "A fast-acting video guide to help you find calm during a panic attack or high-stress moment.",
                                    "https://www.youtube.com/watch?v=inpok4MKVLM",
                                    "Video",
                                    25,
                                    counselor2),
                            buildContent(
                                    "The Science of Better Sleep",
                                    "Why your brain needs rest and how to fix your sleep schedule for better grades.",
                                    """
                                            <h2>The 10-3-2-1-0 Rule for Sleep</h2><p>Sleep hygiene is the set of habits that allow you to fall asleep easily and stay asleep.</p><ul><li><strong>10 hours before bed:</strong> No more caffeine.</li><li><strong>3 hours before bed:</strong> No more food or alcohol.</li><li><strong>2 hours before bed:</strong> No more work.</li><li><strong>1 hour before bed:</strong> No more blue light (phones/laptops).</li><li><strong>0:</strong> The number of times you should hit the snooze button.</li></ul>
                                            """,
                                    "Article",
                                    40,
                                    counselor3),
                            buildContent(
                                    "Overcoming Social Anxiety",
                                    "Tips for navigating social situations and making new friends on campus.",
                                    """
                                            <h1>Navigating Social Spaces</h1><p>Social anxiety isn't just being shy; it's a fear of being judged. Here is how to challenge those thoughts:</p><h3>The Spotlight Effect</h3><p>Remember that most people are too worried about themselves to notice your minor mistakes. This is called the spotlight effect—the tendency to overestimate how much others notice about us.</p>
                                            """,
                                    "Article",
                                    60,
                                    counselor1),
                            buildContent(
                                    "The Pomodoro Technique Explained",
                                    "Watch how this simple timer method can double your productivity.",
                                    "https://www.youtube.com/watch?v=mNBmG24djoY",
                                    "Video",
                                    30,
                                    counselor2),
                            buildContent(
                                    "Building Unshakeable Self-Confidence",
                                    "How to stop the \"Inner Critic\" and start valuing your unique strengths.",
                                    """
                                            <h2>Quieting the Inner Critic</h2><p>We often say things to ourselves that we would never say to a friend. Practice self-compassion by acknowledging your efforts, not just your results.</p><blockquote>"You have been criticizing yourself for years and it hasn't worked. Try approving of yourself and see what happens." — Louise Hay</blockquote>
                                            """,
                                    "Article",
                                    55,
                                    counselor3),
                            buildContent(
                                    "Guided Box Breathing Session",
                                    "Follow this rhythm to reset your nervous system in under 3 minutes.",
                                    "https://www.youtube.com/watch?v=tEmt1ZnuxAk",
                                    "Video",
                                    20,
                                    counselor1),
                            buildContent(
                                    "Digital Detox: Reclaim Your Focus",
                                    "How social media impacts your dopamine levels and how to break the scroll cycle.",
                                    """
                                            <h1>The Dopamine Loop</h1><p>Constant notifications keep our brains in a state of high alert. A digital detox isn't about quitting technology; it's about setting boundaries.</p><h3>Try this:</h3><p>Set "No-Phone Zones" in your house, specifically the dining table and the bedroom.</p>
                                            """,
                                    "Article",
                                    45,
                                    counselor2),
                            buildContent(
                                    "The Art of Active Listening",
                                    "Improve your relationships by learning how to truly hear what others are saying.",
                                    """
                                            <h2>What is Active Listening?</h2><p>It involves fully concentrating, understanding, responding, and then remembering what is being said.</p><ul><li>Maintain eye contact.</li><li>Don't formulate your rebuttal while they are talking.</li><li>Ask open-ended questions like "How did that make you feel?"></li></ul>
                                            """,
                                    "Article",
                                    50,
                                    counselor3),
                            buildContent(
                                    "The Power of \"Yet\"",
                                    "Carol Dweck explains why your intelligence isn't fixed and how you can grow.",
                                    "https://www.youtube.com/watch?v=Xv2ar6AKvGc",
                                    "Video",
                                    35,
                                    counselor1),
                            buildContent(
                                    "The Eisenhower Matrix Method",
                                    "Learn to distinguish between what is urgent and what is truly important.",
                                    """
                                            <h1>Stop Busywork</h1><p>Being busy is not the same as being productive. Use the matrix:</p><ul><li><strong>Quadrant 1 (Urgent/Important):</strong> Do it now.</li><li><strong>Quadrant 2 (Not Urgent/Important):</strong> Schedule it (This is where growth happens!).</li><li><strong>Quadrant 3 (Urgent/Not Important):</strong> Delegate it.</li><li><strong>Quadrant 4 (Not Urgent/Not Important):</strong> Delete it.</li></ul>
                                            """,
                                    "Article",
                                    40,
                                    counselor2),
                            buildContent(
                                    "The 1% Rule for Habit Change",
                                    "Small changes lead to massive results over time. See how.",
                                    "https://www.youtube.com/watch?v=PZ7lDrwYdZ8",
                                    "Video",
                                    30,
                                    counselor3),
                            buildContent(
                                    "Identifying Your Emotions",
                                    "A guide to using the Feelings Wheel to better communicate your needs.",
                                    """
                                            <h2>Naming to Taming</h2><p>Research shows that the simple act of naming a difficult emotion can reduce the activity in the amygdala (the brain's fear center). Using a feelings wheel helps you move from "I feel bad" to "I feel neglected" or "I feel overwhelmed."</p>
                                            """,
                                    "Article",
                                    50,
                                    counselor1),
                            buildContent(
                                    "Dealing with College Loneliness",
                                    "It is normal to feel alone even in a crowd. Here is how to reconnect.",
                                    """
                                            <h1>You Are Not Alone</h1><p>Loneliness is a signal, like hunger, that a need isn't being met. Don't wait for an invitation; be the one to start a conversation after class or join a club that aligns with your hobbies.</p>
                                            """,
                                    "Article",
                                    45,
                                    counselor2),
                            buildContent(
                                    "Student Budgeting 101",
                                    "Relieve money-related anxiety by taking control of your spending.",
                                    "https://www.youtube.com/watch?v=sVKP4AI09SI",
                                    "Video",
                                    30,
                                    counselor3));

                    contents.forEach(educationalContentDAO::save);
                    System.out.println("✅ Seeded " + contents.size() + " educational content records.");
                }
            } else {
                System.out.println("✓ Educational content already exists.");
            }

            System.out.println("=== DATA INITIALIZATION COMPLETE ===");
        };
    }

    private EducationalContent buildContent(String title, String description, String body, String type, int points,
            Counselor author) {
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