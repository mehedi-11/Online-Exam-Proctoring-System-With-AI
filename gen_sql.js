const fs = require('fs');

const teacherHash = '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa';
const studentHash = '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S';
const adminHash = '$2a$10$4Xln9SmHFlwB.WPOhYIk9enzLHBYkm2qRUiGksgWVdfLVQceCDaom';

let sql = `
-- Drop tables if they exist
DROP TABLE IF EXISTS student_answers;
DROP TABLE IF EXISTS proctoring_logs;
DROP TABLE IF EXISTS student_exams;
DROP TABLE IF EXISTS exam_questions;
DROP TABLE IF EXISTS exams;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS admins;

-- Table Schemas
CREATE TABLE admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255)
);

CREATE TABLE teachers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  profile_image VARCHAR(255) DEFAULT NULL,
  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  joining_date DATE DEFAULT CURRENT_DATE,
  llm_api_key VARCHAR(255) DEFAULT NULL
);

CREATE TABLE students (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  profile_image VARCHAR(255) DEFAULT NULL,
  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending'
);

CREATE TABLE exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  exam_date DATETIME NOT NULL,
  duration_minutes INT NOT NULL,
  end_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  type ENUM('MCQ', 'Written', 'Both') DEFAULT 'MCQ',
  is_live BOOLEAN DEFAULT FALSE,
  exam_password VARCHAR(255) DEFAULT NULL,
  must_on_camera BOOLEAN DEFAULT TRUE,
  must_on_microphone BOOLEAN DEFAULT TRUE
);

CREATE TABLE exam_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT,
  question_text TEXT NOT NULL,
  type ENUM('MCQ', 'Written') DEFAULT 'MCQ',
  marks INT NOT NULL DEFAULT 1,
  option_a VARCHAR(255) DEFAULT NULL,
  option_b VARCHAR(255) DEFAULT NULL,
  option_c VARCHAR(255) DEFAULT NULL,
  option_d VARCHAR(255) DEFAULT NULL,
  correct_option ENUM('A', 'B', 'C', 'D') DEFAULT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE student_exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(50),
  exam_id INT,
  started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  status ENUM('started', 'completed', 'blocked') DEFAULT 'started',
  demerit_points INT DEFAULT 0,
  score INT DEFAULT NULL,
  ai_grading_completed BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE student_answers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(50),
  exam_id INT,
  question_id INT,
  student_answer TEXT,
  marks_awarded INT DEFAULT NULL,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES exam_questions(id) ON DELETE CASCADE
);

CREATE TABLE proctoring_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT,
  student_id VARCHAR(50),
  activity_type VARCHAR(100) NOT NULL,
  details TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Passwords for testing:
-- admin: admin123
-- teacher: teacher123
-- student: student123

INSERT INTO admins (email, password, name) VALUES 
('admin@exam.com', '${adminHash}', 'System Administrator');

`;

const firstNames = ['Amit', 'Raj', 'Priya', 'Neha', 'Vikram', 'Anjali', 'Karan', 'Sneha', 'Rohan', 'Pooja', 'Rahul', 'Anita', 'Sunil', 'Kavita', 'Sanjay', 'Geeta', 'Manoj', 'Rita', 'Ashok', 'Meena'];
const lastNames = ['Sharma', 'Verma', 'Singh', 'Patel', 'Kumar', 'Gupta', 'Das', 'Roy', 'Chowdhury', 'Jain'];

const getRand = (arr) => arr[Math.floor(Math.random() * arr.length)];

// 10 Teachers
for(let i=1; i<=10; i++) {
    const name = `Prof. ${getRand(firstNames)} ${getRand(lastNames)}`;
    sql += `INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher${i}@exam.com', '${teacherHash}', '${name}', 'approved', '2026-01-01');\n`;
}

// 100 Students
for(let i=1; i<=100; i++) {
    const name = `${getRand(firstNames)} ${getRand(lastNames)}`;
    const studentId = `STU${1000 + i}`;
    sql += `INSERT INTO students (id, email, password, name, status) VALUES ('${studentId}', 'student${i}@exam.com', '${studentHash}', '${name}', 'approved');\n`;
}

sql += `
-- Create default exam
INSERT INTO exams (id, title, exam_date, duration_minutes, end_time, type, is_live, exam_password) VALUES
(1, 'CS101 Midterm Exam', NOW() + INTERVAL 1 DAY, 30, NOW() + INTERVAL 1 DAY + INTERVAL 30 MINUTE, 'Both', FALSE, 'secret123');

-- Add Questions for CS101 Midterm
INSERT INTO exam_questions (exam_id, question_text, type, marks, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'What does HTML stand for?', 'MCQ', 1, 'Hyper Text Markup Language', 'High Text Markup Language', 'Hyper Tabular Markup Language', 'None of these', 'A'),
(1, 'Which of the following is used to style web pages?', 'MCQ', 1, 'HTML', 'JQuery', 'CSS', 'XML', 'C'),
(1, 'What is the correct syntax for referring to an external script called "app.js"?', 'MCQ', 1, '<script href="app.js">', '<script name="app.js">', '<script src="app.js">', '<script file="app.js">', 'C'),
(1, 'Which company developed JavaScript?', 'MCQ', 1, 'Microsoft', 'Netscape', 'Sun Microsystems', 'Oracle', 'B'),
(1, 'Describe the difference between absolute and relative positioning in CSS.', 'Written', 5, NULL, NULL, NULL, NULL, NULL),
(1, 'Explain how Promises work in JavaScript.', 'Written', 5, NULL, NULL, NULL, NULL, NULL);
`;

fs.writeFileSync('database.sql', sql);
console.log('database.sql generated successfully with full schema, 10 teachers, and 100 students!');
