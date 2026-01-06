package com.mindmate.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.Set;
import java.util.HashSet;
import java.util.LinkedHashSet;

@Entity
@Table(name = "moderation_stats")

public class ModerationStats {
    @Id
    private String id = "global_stats"; // Only one row exists
    private int approvedCount = 0;
    private int deletedCount = 0;
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public int getApprovedCount() {
        return approvedCount;
    }
    public void setApprovedCount(int approvedCount) {
        this.approvedCount = approvedCount;
    }
    public int getDeletedCount() {
        return deletedCount;
    }
    public void setDeletedCount(int deletedCount) {
        this.deletedCount = deletedCount;
    }


}
