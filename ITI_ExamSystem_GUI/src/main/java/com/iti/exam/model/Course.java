package com.iti.exam.model;

public class Course {
    private int courseId;
    private String courseName;
    private int minDegree;
    private int maxDegree;

    public Course() {}
    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }
    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }
    public int getMinDegree() { return minDegree; }
    public void setMinDegree(int minDegree) { this.minDegree = minDegree; }
    public int getMaxDegree() { return maxDegree; }
    public void setMaxDegree(int maxDegree) { this.maxDegree = maxDegree; }
}
