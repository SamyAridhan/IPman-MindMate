// src/main/java/com/mindmate/dao/CounselorDAO.java
package com.mindmate.dao;

import com.mindmate.model.Counselor;
import java.util.List;
import java.util.Optional;

public interface CounselorDAO extends GenericDAO<Counselor> {
    
    Optional<Counselor> findByEmail(String email);
    List<Counselor> findByAvailability(String availability);
    List<Counselor> findBySpecialization(String specialization);
    List<Counselor> findAllOrderByRatingDesc();

    /**
     * Counts total number of counselors.
     * @return Total count
     */
    long count(); // ✅ Added this method
}