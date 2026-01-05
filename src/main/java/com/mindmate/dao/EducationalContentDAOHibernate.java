package com.mindmate.dao;

import com.mindmate.dao.EducationalContentDAO;
import com.mindmate.model.EducationalContent;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public class EducationalContentDAOHibernate implements EducationalContentDAO {

    private final SessionFactory sessionFactory;

    public EducationalContentDAOHibernate(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    @Override
    public void save(EducationalContent content) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(content);
            tx.commit();
        }
    }

    @Override
    public void update(EducationalContent content) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            session.merge(content);
            tx.commit();
        }
    }

    @Override
    public void delete(Long id) {
        try (Session session = sessionFactory.openSession()) {
            Transaction tx = session.beginTransaction();
            EducationalContent content = session.get(EducationalContent.class, id);
            if (content != null) {
                session.remove(content);
            }
            tx.commit();
        }
    }

    @Override
    public EducationalContent findById(Long id) {
        try (Session session = sessionFactory.openSession()) {
            // Fetch join to initialize lazy author before session closes
            Query<EducationalContent> query = session.createQuery(
                    "SELECT c FROM EducationalContent c " +
                            "LEFT JOIN FETCH c.author " +
                            "WHERE c.id = :id",
                    EducationalContent.class);
            query.setParameter("id", id);
            return query.uniqueResult();
        }
    }

    @Override
    public List<EducationalContent> findAll() {
        try (Session session = sessionFactory.openSession()) {
            return session.createQuery("FROM EducationalContent ORDER BY createdAt DESC", EducationalContent.class)
                    .list();
        }
    }

    @Override
    public List<EducationalContent> findByType(String type) {
        try (Session session = sessionFactory.openSession()) {
            Query<EducationalContent> query = session.createQuery("FROM EducationalContent WHERE contentType = :type",
                    EducationalContent.class);
            query.setParameter("type", type);
            return query.list();
        }
    }
}