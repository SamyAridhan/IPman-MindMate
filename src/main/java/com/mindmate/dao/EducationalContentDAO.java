package com.mindmate.dao;

import com.mindmate.model.EducationalContent;
import java.util.List;

public interface EducationalContentDAO {
    void save(EducationalContent content);
    void update(EducationalContent content);
    void delete(Long id);
    EducationalContent findById(Long id);
    List<EducationalContent> findAll();
    List<EducationalContent> findByType(String type); // To filter Articles or Videos
    List<EducationalContent> searchByKeyword(String keyword);
}