//src/main/java/com/mindmate/dao/CounselorAvailabilityDAO.java
package com.mindmate.dao;

import com.mindmate.model.Counselor;
import com.mindmate.model.CounselorAvailability;
import java.time.DayOfWeek;
import java.util.List;

/**
 * DAO interface for CounselorAvailability entity operations.
 * 
 * @author Samy (A23CS0246)
 */
public interface CounselorAvailabilityDAO extends GenericDAO<CounselorAvailability> {
    
    /**
     * Finds all active availability slots for a counselor.
     * @param counselor The counselor entity
     * @return List of availability slots
     */
    List<CounselorAvailability> findByCounselor(Counselor counselor);
    
    /**
     * Finds availability for a counselor on a specific day.
     * @param counselor The counselor entity
     * @param dayOfWeek The day to check
     * @return List of time slots for that day
     */
    List<CounselorAvailability> findByCounselorAndDayOfWeek(Counselor counselor, DayOfWeek dayOfWeek);
}