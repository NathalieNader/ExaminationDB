package com.iti.exam.model;

import java.util.Date;

public class StudentExam {
    private int studentExamId;
    private int studentId;
    private String studentName;
    private int examId;
    private String examName;
    private Date startTime;
    private Date endTime;
    private Integer totalGrade;
    private String courseName;
    private Integer maxDegree;
    private Double percentage;

    public StudentExam() {}
    public int getStudentExamId() { return studentExamId; }
    public void setStudentExamId(int studentExamId) { this.studentExamId = studentExamId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    public int getExamId() { return examId; }
    public void setExamId(int examId) { this.examId = examId; }
    public String getExamName() { return examName; }
    public void setExamName(String examName) { this.examName = examName; }
    public Date getStartTime() { return startTime; }
    public void setStartTime(Date startTime) { this.startTime = startTime; }
    public Date getEndTime() { return endTime; }
    public void setEndTime(Date endTime) { this.endTime = endTime; }
    public Integer getTotalGrade() { return totalGrade; }
    public void setTotalGrade(Integer totalGrade) { this.totalGrade = totalGrade; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public Integer getMaxDegree() { return maxDegree; }
    public void setMaxDegree(Integer maxDegree) { this.maxDegree = maxDegree; }
    public Double getPercentage() { return percentage; }
    public void setPercentage(Double percentage) { this.percentage = percentage; }
}
