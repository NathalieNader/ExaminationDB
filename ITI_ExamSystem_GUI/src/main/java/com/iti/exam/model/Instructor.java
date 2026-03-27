package com.iti.exam.model;

public class Instructor {
    private int instructorId;
    private String instructorName;
    private String email;
    private int departmentNo;

    public Instructor() {}
    public int getInstructorId() { return instructorId; }
    public void setInstructorId(int instructorId) { this.instructorId = instructorId; }
    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public int getDepartmentNo() { return departmentNo; }
    public void setDepartmentNo(int departmentNo) { this.departmentNo = departmentNo; }
}
