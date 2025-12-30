package com.mindmate.dao;

import com.mindmate.model.StudentProgress;
import java.util.List;

public interface StudentProgressDAO {
    /**
     * Marks a module as completed for a specific student.
     */
    void markAsComplete(Long studentId, Long contentId);

    /**
     * Gets all progress records for a student to check which ones are done.
     */
    List<StudentProgress> getProgressByStudent(Long studentId);

    /**
     * Checks if a specific module is completed by a student.
     */
    boolean isModuleCompleted(Long studentId, Long contentId);

    /**
     * Deletes all progress records for a specific content.
     */
    void deleteByContentId(Long contentId);
}