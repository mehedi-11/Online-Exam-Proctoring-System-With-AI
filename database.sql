
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
  must_on_microphone BOOLEAN DEFAULT TRUE,
  teacher_id INT,
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE
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
  finished_at DATETIME DEFAULT NULL,
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
('admin@exam.com', '$2a$10$4Xln9SmHFlwB.WPOhYIk9enzLHBYkm2qRUiGksgWVdfLVQceCDaom', 'System Administrator');

INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher1@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Raj Patel', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher2@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Sunil Das', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher3@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Rohan Kumar', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher4@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Karan Patel', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher5@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Pooja Verma', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher6@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Priya Verma', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher7@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Karan Patel', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher8@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Pooja Patel', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher9@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Rohan Kumar', 'approved', '2026-01-01');
INSERT INTO teachers (email, password, name, status, joining_date) VALUES ('teacher10@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. Meena Gupta', 'approved', '2026-01-01');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1001', 'student1@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1002', 'student2@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1003', 'student3@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1004', 'student4@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashok Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1005', 'student5@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1006', 'student6@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1007', 'student7@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1008', 'student8@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meena Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1009', 'student9@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1010', 'student10@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Geeta Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1011', 'student11@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Geeta Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1012', 'student12@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1013', 'student13@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1014', 'student14@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1015', 'student15@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1016', 'student16@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1017', 'student17@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1018', 'student18@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1019', 'student19@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1020', 'student20@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manoj Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1021', 'student21@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anjali Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1022', 'student22@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1023', 'student23@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Geeta Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1024', 'student24@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1025', 'student25@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1026', 'student26@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1027', 'student27@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meena Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1028', 'student28@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1029', 'student29@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1030', 'student30@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1031', 'student31@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1032', 'student32@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashok Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1033', 'student33@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pooja Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1034', 'student34@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Geeta Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1035', 'student35@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1036', 'student36@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Geeta Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1037', 'student37@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1038', 'student38@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1039', 'student39@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1040', 'student40@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1041', 'student41@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pooja Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1042', 'student42@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1043', 'student43@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1044', 'student44@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashok Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1045', 'student45@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meena Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1046', 'student46@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1047', 'student47@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1048', 'student48@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1049', 'student49@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1050', 'student50@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1051', 'student51@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meena Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1052', 'student52@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1053', 'student53@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pooja Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1054', 'student54@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sneha Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1055', 'student55@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashok Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1056', 'student56@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1057', 'student57@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1058', 'student58@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1059', 'student59@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1060', 'student60@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pooja Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1061', 'student61@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1062', 'student62@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1063', 'student63@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sneha Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1064', 'student64@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manoj Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1065', 'student65@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manoj Verma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1066', 'student66@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1067', 'student67@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1068', 'student68@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pooja Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1069', 'student69@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1070', 'student70@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sanjay Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1071', 'student71@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1072', 'student72@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1073', 'student73@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manoj Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1074', 'student74@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sneha Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1075', 'student75@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sanjay Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1076', 'student76@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1077', 'student77@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1078', 'student78@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1079', 'student79@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1080', 'student80@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1081', 'student81@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1082', 'student82@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meena Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1083', 'student83@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1084', 'student84@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1085', 'student85@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1086', 'student86@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1087', 'student87@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1088', 'student88@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kavita Jain', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1089', 'student89@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Gupta', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1090', 'student90@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1091', 'student91@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Kumar', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1092', 'student92@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Singh', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1093', 'student93@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Anita Roy', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1094', 'student94@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1095', 'student95@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Chowdhury', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1096', 'student96@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1097', 'student97@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rita Das', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1098', 'student98@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Priya Patel', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1099', 'student99@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Sharma', 'approved');
INSERT INTO students (id, email, password, name, status) VALUES ('STU1100', 'student100@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manoj Verma', 'approved');

-- Create default exam
INSERT INTO exams (id, title, exam_date, duration_minutes, end_time, type, is_live, exam_password, teacher_id) VALUES
(1, 'CS101 Midterm Exam', NOW() + INTERVAL 1 DAY, 30, NOW() + INTERVAL 1 DAY + INTERVAL 30 MINUTE, 'Both', FALSE, 'secret123', 1);

-- Add Questions for CS101 Midterm
INSERT INTO exam_questions (exam_id, question_text, type, marks, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'What does HTML stand for?', 'MCQ', 1, 'Hyper Text Markup Language', 'High Text Markup Language', 'Hyper Tabular Markup Language', 'None of these', 'A'),
(1, 'Which of the following is used to style web pages?', 'MCQ', 1, 'HTML', 'JQuery', 'CSS', 'XML', 'C'),
(1, 'What is the correct syntax for referring to an external script called "app.js"?', 'MCQ', 1, '<script href="app.js">', '<script name="app.js">', '<script src="app.js">', '<script file="app.js">', 'C'),
(1, 'Which company developed JavaScript?', 'MCQ', 1, 'Microsoft', 'Netscape', 'Sun Microsystems', 'Oracle', 'B'),
(1, 'Describe the difference between absolute and relative positioning in CSS.', 'Written', 5, NULL, NULL, NULL, NULL, NULL),
(1, 'Explain how Promises work in JavaScript.', 'Written', 5, NULL, NULL, NULL, NULL, NULL);
