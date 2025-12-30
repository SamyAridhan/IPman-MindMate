package com.mindmate.dao;
import com.mindmate.dao.StudentProgressDAO;
import com.mindmate.model.StudentProgress;
import com.mindmate.model.Student;
import com.mindmate.model.EducationalContent;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public class StudentProgressDAOHibernate implements StudentProgressDAO {
    private final SessionFactory sessionFactory;

    public StudentProgressDAOHibernate(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
    public void markAsComplete(Long studentId, Long contentId) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            
            // Check if record already exists to avoid duplicates
            Query<StudentProgress> query = session.createQuery(
                "FROM StudentProgress WHERE student.id = :sid AND content.id = :cid", StudentProgress.class);
            query.setParameter("sid", studentId);
            query.setParameter("cid", contentId);
            StudentProgress progress = query.uniqueResult();

            if (progress == null) {
                progress = new StudentProgress();
                progress.setStudent(session.get(Student.class, studentId));
                progress.setContent(session.get(EducationalContent.class, contentId));
                progress.setCompleted(true);
                progress.setCompletionDate(LocalDateTime.now());
                session.persist(progress);
            } else if (!progress.isCompleted()) {
                progress.setCompleted(true);
                progress.setCompletionDate(LocalDateTime.now());
                session.merge(progress);
            }
            
            tx.commit();
        }
    }

    @Override
    public List<StudentProgress> getProgressByStudent(Long studentId) {
        try (Session session = sessionFactory.openSession()) {
            Query<StudentProgress> query = session.createQuery(
                "FROM StudentProgress WHERE student.id = :sid", StudentProgress.class);
            query.setParameter("sid", studentId);
            return query.list();
        }
    }

    @Override
    public boolean isModuleCompleted(Long studentId, Long contentId) {
        try (Session session = sessionFactory.openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT count(id) FROM StudentProgress WHERE student.id = :sid AND content.id = :cid AND isCompleted = true", Long.class);
            query.setParameter("sid", studentId);
            query.setParameter("cid", contentId);
            return query.uniqueResult() > 0;
        }
    }
}
