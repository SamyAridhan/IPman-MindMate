package com.mindmate.dao;

import com.mindmate.model.Assessment;
import com.mindmate.model.Student;
import java.util.List;

public interface AssessmentDAO extends GenericDAO<Assessment> {
    /**
     * Finds all assessments taken by a specific student.
     * Useful for showing "My History" on the dashboard.
     */
    List<Assessment> findByStudent(Student student);
}