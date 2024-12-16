package com.terraViva.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "mcq_questions")
public class MCQQuestion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String questionText;

    @ElementCollection
    @CollectionTable(name = "mcq_options", joinColumns = @JoinColumn(name = "question_id"))
    @MapKeyColumn(name = "option_key")
    @Column(name = "option_value")
    private Map<String, String> options;

    private String correctAnswer;
    @Column(columnDefinition = "TEXT")
    private String explanation;

    @ManyToOne
    @JoinColumn(name = "quiz_id", nullable = false)
    @JsonIgnore
    private Quiz quiz;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
