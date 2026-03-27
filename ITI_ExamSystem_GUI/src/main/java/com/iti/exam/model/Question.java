package com.iti.exam.model;

import java.util.List;

public class Question {
    private int questionId;
    private int courseId;
    private String courseName;
    private String questionText;
    private String questionType; // MCQ or TF
    private int points;
    private List<Option> options;
    private int modelAnswerOptionId;

    public Question() {}
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    public String getQuestionType() { return questionType; }
    public void setQuestionType(String questionType) { this.questionType = questionType; }
    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }
    public List<Option> getOptions() { return options; }
    public void setOptions(List<Option> options) { this.options = options; }
    public int getModelAnswerOptionId() { return modelAnswerOptionId; }
    public void setModelAnswerOptionId(int modelAnswerOptionId) { this.modelAnswerOptionId = modelAnswerOptionId; }
}
