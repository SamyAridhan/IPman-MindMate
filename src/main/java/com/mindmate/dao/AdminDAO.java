// src/main/java/com/mindmate/dao/AdminDAO.java

package com.mindmate.dao;

import com.mindmate.model.Admin;
import java.util.Optional;

/**
 * DAO interface for Admin entity operations.
 * 
 * @author Samy (A23CS0246)
 */
public interface AdminDAO extends GenericDAO<Admin> {
    
    /**
     * Finds an admin by email address.
     * @param email The admin's email
     * @return Optional containing admin if found
     */
    Optional<Admin> findByEmail(String email);
    
    /**
     * Counts total number of admins.
     * @return Total admin count
     */
    long count();
}