//src/main/java/com/mindmate/dao/CounselorAvailabilityDAOHibernate.java
package com.mindmate.dao;

import com.mindmate.model.Counselor;
import com.mindmate.model.CounselorAvailability;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.DayOfWeek;
import java.util.List;

/**
 * Hibernate implementation of CounselorAvailabilityDAO.
 * 
 * @author Samy (A23CS0246)
 */
@Repository
@Transactional
public class CounselorAvailabilityDAOHibernate implements CounselorAvailabilityDAO {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    public void save(CounselorAvailability availability) {
        entityManager.persist(availability);
    }

    @Override
    public void update(CounselorAvailability availability) {
        entityManager.merge(availability);
    }

    @Override
    public void delete(Long id) {
        CounselorAvailability availability = findById(id);
        if (availability != null) {
            entityManager.remove(availability);
        }
    }

    @Override
    public CounselorAvailability findById(Long id) {
        return entityManager.find(CounselorAvailability.class, id);
    }

    @Override
    public List<CounselorAvailability> findAll() {
        TypedQuery<CounselorAvailability> query = entityManager.createQuery(
            "SELECT ca FROM CounselorAvailability ca", CounselorAvailability.class);
        return query.getResultList();
    }

    @Override
    public List<CounselorAvailability> findByCounselor(Counselor counselor) {
        TypedQuery<CounselorAvailability> query = entityManager.createQuery(
            "SELECT ca FROM CounselorAvailability ca WHERE ca.counselor = :counselor " +
            "AND ca.isActive = true ORDER BY ca.dayOfWeek, ca.startTime", 
            CounselorAvailability.class);
        query.setParameter("counselor", counselor);
        return query.getResultList();
    }

    @Override
    public List<CounselorAvailability> findByCounselorAndDayOfWeek(Counselor counselor, DayOfWeek dayOfWeek) {
        TypedQuery<CounselorAvailability> query = entityManager.createQuery(
            "SELECT ca FROM CounselorAvailability ca WHERE ca.counselor = :counselor " +
            "AND ca.dayOfWeek = :dayOfWeek AND ca.isActive = true ORDER BY ca.startTime", 
            CounselorAvailability.class);
        query.setParameter("counselor", counselor);
        query.setParameter("dayOfWeek", dayOfWeek);
        return query.getResultList();
    }
}