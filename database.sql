CREATE DATABASE IF NOT EXISTS online_exam;
USE online_exam;

-- Table: admins
CREATE TABLE IF NOT EXISTS admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL
);

-- Table: teachers
CREATE TABLE IF NOT EXISTS teachers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  profile_image VARCHAR(255) DEFAULT NULL,
  joining_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  status ENUM('pending', 'approved', 'suspended') DEFAULT 'pending'
);

-- Table: students
CREATE TABLE IF NOT EXISTS students (
  id VARCHAR(50) PRIMARY KEY, -- Student ID (e.g. STU1001)
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  profile_image VARCHAR(255) DEFAULT NULL,
  status ENUM('pending', 'approved', 'suspended') DEFAULT 'pending'
);

-- Table: courses
CREATE TABLE IF NOT EXISTS courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(50) UNIQUE NOT NULL,
  description TEXT
);

-- Table: course_assignments (Teacher to Course)
CREATE TABLE IF NOT EXISTS course_assignments (
  course_id INT,
  teacher_id INT,
  PRIMARY KEY (course_id, teacher_id),
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
);

-- Table: course_enrollments (Student to Course)
CREATE TABLE IF NOT EXISTS course_enrollments (
  course_id INT,
  student_id VARCHAR(50),
  status ENUM('pending', 'approved') DEFAULT 'pending',
  PRIMARY KEY (course_id, student_id),
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Table: exams
CREATE TABLE IF NOT EXISTS exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT,
  title VARCHAR(255) NOT NULL,
  exam_date DATETIME NOT NULL,
  duration_minutes INT NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- Table: exam_questions
CREATE TABLE IF NOT EXISTS exam_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT,
  question_text TEXT NOT NULL,
  option_a VARCHAR(255) NOT NULL,
  option_b VARCHAR(255) NOT NULL,
  option_c VARCHAR(255) NOT NULL,
  option_d VARCHAR(255) NOT NULL,
  correct_option ENUM('A', 'B', 'C', 'D') NOT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- Table: student_exams
CREATE TABLE IF NOT EXISTS student_exams (
  student_id VARCHAR(50),
  exam_id INT,
  score INT DEFAULT NULL,
  started_at DATETIME DEFAULT NULL,
  finished_at DATETIME DEFAULT NULL,
  status ENUM('started', 'completed', 'blocked') DEFAULT 'started',
  demerit_points INT DEFAULT 0,
  block_until DATETIME DEFAULT NULL,
  PRIMARY KEY (student_id, exam_id),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- Table: proctoring_logs
CREATE TABLE IF NOT EXISTS proctoring_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(50),
  exam_id INT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  activity_type VARCHAR(100) NOT NULL,
  details TEXT,
  demerit_points INT DEFAULT 0,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

-- Insert Mock Data
-- Default passwords are encrypted with bcrypt (rounds=10)
-- admin123 -> $2a$10$wR6B0s02.n5W.n8v11mK..oO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q
-- teacher123 -> $2a$10$6G1W5e0u1.9s.m8k11pK..pO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q
-- student123 -> $2a$10$7Z8YJ.DbeoP7wH6T2L52kO1r98eY3F0m9fXyvT/nC9R.E4J/lO.n6

INSERT INTO admins (email, password, name) VALUES 
('admin@exam.com', '$2a$10$wR6B0s02.n5W.n8v11mK..oO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q', 'System Administrator')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO teachers (email, password, name, status, joining_date) VALUES 
('teacher@exam.com', '$2a$10$6G1W5e0u1.9s.m8k11pK..pO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q', 'Prof. John Doe', 'approved', '2026-01-15')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO students (id, email, password, name, status) VALUES 
('STU1001', 'student@exam.com', '$2a$10$7Z8YJ.DbeoP7wH6T2L52kO1r98eY3F0m9fXyvT/nC9R.E4J/lO.n6', 'Jane Smith', 'approved')
ON DUPLICATE KEY UPDATE id=id;

-- Insert Mock Courses
INSERT INTO courses (name, code, description) VALUES
('Introduction to Computer Science', 'CS101', 'Basic concepts of programming and data structures.'),
('Database Management Systems', 'CS302', 'Relational database designs, SQL querying, and database administration.')
ON DUPLICATE KEY UPDATE id=id;

-- Assign teacher to course 1 (Intro to CS)
INSERT INTO course_assignments (course_id, teacher_id) VALUES
(1, 1)
ON DUPLICATE KEY UPDATE course_id=course_id;

-- Enroll student to course 1 (Intro to CS) - Approved
INSERT INTO course_enrollments (course_id, student_id, status) VALUES
(1, 'STU1001', 'approved')
ON DUPLICATE KEY UPDATE course_id=course_id;

-- Create default exam
INSERT INTO exams (id, course_id, title, exam_date, duration_minutes) VALUES
(1, 1, 'CS101 Midterm Exam', NOW() + INTERVAL 1 DAY, 30)
ON DUPLICATE KEY UPDATE id=id;

-- Add Questions for CS101 Midterm
INSERT INTO exam_questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'Which data structure works on the LIFO (Last In First Out) principle?', 'Queue', 'Stack', 'Linked List', 'Binary Tree', 'B'),
(1, 'What is the complexity of searching in a balanced binary search tree?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'C'),
(1, 'Which of the following is NOT a programming language?', 'Python', 'HTML', 'Java', 'C++', 'B')
ON DUPLICATE KEY UPDATE id=id;
