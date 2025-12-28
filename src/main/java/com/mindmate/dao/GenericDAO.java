// src/main/java/com/mindmate/dao/GenericDAO.java

package com.mindmate.dao;

import java.util.List;

/**
 * Generic DAO interface defining common CRUD operations.
 * All entity-specific DAOs should extend this interface.
 * 
 * @param <T> The entity type
 * @author Samy (A23CS0246)
 */
public interface GenericDAO<T> {
    
    /**
     * Persists a new entity to the database.
     * @param entity The entity to save
     */
    void save(T entity);
    
    /**
     * Updates an existing entity in the database.
     * @param entity The entity to update
     */
    void update(T entity);
    
    /**
     * Deletes an entity by its ID.
     * @param id The ID of the entity to delete
     */
    void delete(Long id);
    
    /**
     * Retrieves an entity by its ID.
     * @param id The ID of the entity
     * @return The entity, or null if not found
     */
    T findById(Long id);
    
    /**
     * Retrieves all entities of this type.
     * @return List of all entities
     */
    List<T> findAll();
}