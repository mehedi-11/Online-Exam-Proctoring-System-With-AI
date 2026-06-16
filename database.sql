-- teacher123 -> $2a$10$6G1W5e0u1.9s.m8k11pK..pO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q
-- student123 -> $2a$10$7Z8YJ.DbeoP7wH6T2L52kO1r98eY3F0m9fXyvT/nC9R.E4J/lO.n6

INSERT INTO admins (email, password, name) VALUES 
('admin@exam.com', '$2a$10$4Xln9SmHFlwB.WPOhYIk9enzLHBYkm2qRUiGksgWVdfLVQceCDaom', 'System Administrator')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO teachers (email, password, name, status, joining_date) VALUES 
('teacher@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. John Doe', 'approved', '2026-01-15')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO students (id, email, password, name, status) VALUES 
('STU1001', 'student@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Jane Smith', 'approved')
ON DUPLICATE KEY UPDATE id=id;


-- Create default exam
INSERT INTO exams (id, title, exam_date, duration_minutes) VALUES
(1, 'CS101 Midterm Exam', NOW() + INTERVAL 1 DAY, 30)
-- teacher123 -> $2a$10$6G1W5e0u1.9s.m8k11pK..pO7vQ6iZ3o4y9pA2U9qE0h.F2e13s8q
-- student123 -> $2a$10$7Z8YJ.DbeoP7wH6T2L52kO1r98eY3F0m9fXyvT/nC9R.E4J/lO.n6

INSERT INTO admins (email, password, name) VALUES 
('admin@exam.com', '$2a$10$4Xln9SmHFlwB.WPOhYIk9enzLHBYkm2qRUiGksgWVdfLVQceCDaom', 'System Administrator')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO teachers (email, password, name, status, joining_date) VALUES 
('teacher@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', 'Prof. John Doe', 'approved', '2026-01-15')
ON DUPLICATE KEY UPDATE id=id;

INSERT INTO students (id, email, password, name, status) VALUES 
('STU1001', 'student@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Jane Smith', 'approved')
ON DUPLICATE KEY UPDATE id=id;


-- Create default exam
CREATE TABLE IF NOT EXISTS exams (
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

-- Add Questions for CS101 Midterm
INSERT INTO exam_questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'Which data structure works on the LIFO (Last In First Out) principle?', 'Queue', 'Stack', 'Linked List', 'Binary Tree', 'B'),
(1, 'What is the complexity of searching in a balanced binary search tree?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'C'),
(1, 'Which of the following is NOT a programming language?', 'Python', 'HTML', 'Java', 'C++', 'B')
ON DUPLICATE KEY UPDATE id=id;


-- 100 Generated Students
INSERT INTO students (id, email, password, name, status) VALUES ('STU1002', 'deepak.trivedi1@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Deepak Trivedi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1003', 'ananya.kansal2@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ananya Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1004', 'santosh.sayal3@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Santosh Sayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1005', 'hitesh.mishra4@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Hitesh Mishra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1006', 'vijay.joshi5@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vijay Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1007', 'ashish.naidu6@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashish Naidu', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1008', 'naveen.joshi7@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Naveen Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1009', 'harish.sharma8@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Harish Sharma', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1010', 'praveen.trivedi9@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Praveen Trivedi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1011', 'reyansh.roy10@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Reyansh Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1012', 'aarohi.mahajan11@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aarohi Mahajan', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1013', 'darsh.singh12@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Darsh Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1014', 'kamlesh.shah13@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kamlesh Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1015', 'ankit.pandey14@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ankit Pandey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1016', 'rohit.sayal15@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohit Sayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1017', 'ritvik.malhotra16@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ritvik Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1018', 'hitesh.jain17@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Hitesh Jain', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1019', 'kamlesh.mehta18@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kamlesh Mehta', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1020', 'aisha.agarwal19@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Agarwal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1021', 'meher.reddy20@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meher Reddy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1022', 'pari.choudhary21@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pari Choudhary', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1023', 'zara.verma22@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Zara Verma', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1024', 'mahesh.kansal23@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mahesh Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1025', 'amit.roy24@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1026', 'jitesh.joshi25@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Jitesh Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1027', 'akash.bansal26@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Akash Bansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1028', 'ishaan.shah27@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ishaan Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1029', 'aaryan.tiwari28@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aaryan Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1030', 'umesh.roy29@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Umesh Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1031', 'girish.gupta30@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Girish Gupta', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1032', 'rupesh.gurjar31@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rupesh Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1033', 'surya.kansal32@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Surya Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1034', 'nitin.singhal33@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nitin Singhal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1035', 'suresh.tayal34@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Suresh Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1036', 'riya.joshi35@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Riya Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1037', 'santosh.malhotra36@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Santosh Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1038', 'myra.jain37@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Myra Jain', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1039', 'maryam.garg38@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Maryam Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1040', 'shaurya.malhotra39@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Shaurya Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1041', 'arjun.yadav40@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Arjun Yadav', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1042', 'naresh.kansal41@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Naresh Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1043', 'sumit.patel42@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sumit Patel', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1044', 'varun.bansal43@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Varun Bansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1045', 'rupesh.choudhary44@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rupesh Choudhary', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1046', 'krishna.ahir45@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Krishna Ahir', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1047', 'amit.roy46@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1048', 'amit.bansal47@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Bansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1049', 'navya.ahuja48@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Navya Ahuja', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1050', 'ishita.garg49@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ishita Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1051', 'kabir.naidu50@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kabir Naidu', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1052', 'arjun.malhotra51@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Arjun Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1053', 'advik.vyas52@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Advik Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1054', 'aadhya.roy53@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aadhya Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1055', 'suresh.singh54@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Suresh Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1056', 'aaryan.gurjar55@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aaryan Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1057', 'aisha.patel56@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Patel', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1058', 'rahul.trivedi57@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Trivedi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1059', 'sandeep.yadav58@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sandeep Yadav', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1060', 'prakash.malhotra59@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Prakash Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1061', 'satish.garg60@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Satish Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1062', 'vihaan.sayal61@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vihaan Sayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1063', 'pari.mittal62@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pari Mittal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1064', 'ravi.das63@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ravi Das', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1065', 'reyansh.choudhary64@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Reyansh Choudhary', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1066', 'maryam.khanna65@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Maryam Khanna', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1067', 'vikram.tiwari66@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1068', 'myra.yadav67@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Myra Yadav', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1069', 'kamlesh.mahajan68@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kamlesh Mahajan', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1070', 'saanvi.khanna69@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Saanvi Khanna', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1071', 'sumit.patel70@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sumit Patel', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1072', 'fatima.yadav71@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Fatima Yadav', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1073', 'shaurya.roy72@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Shaurya Roy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1074', 'praveen.tayal73@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Praveen Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1075', 'sumit.malhotra74@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sumit Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1076', 'vikram.pandey75@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Pandey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1077', 'ankit.mishra76@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ankit Mishra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1078', 'ashish.gurjar77@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashish Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1079', 'sneha.pandey78@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sneha Pandey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1080', 'santosh.singhal79@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Santosh Singhal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1081', 'praveen.kumar80@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Praveen Kumar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1082', 'lokesh.choudhary81@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Lokesh Choudhary', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1083', 'ritvik.singhal82@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ritvik Singhal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1084', 'ayaan.gupta83@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ayaan Gupta', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1085', 'darsh.bansal84@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Darsh Bansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1086', 'amit.das85@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Amit Das', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1087', 'nikhil.kumar86@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nikhil Kumar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1088', 'aisha.gurjar87@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1089', 'manish.tayal88@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manish Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1090', 'tarun.garg89@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Tarun Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1091', 'lokesh.chowdhury90@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Lokesh Chowdhury', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1092', 'samira.gurjar91@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Samira Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1093', 'zara.garg92@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Zara Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1094', 'sai.dubey93@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sai Dubey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1095', 'mitesh.rao94@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mitesh Rao', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1096', 'myra.malhotra95@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Myra Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1097', 'vivaan.mishra96@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vivaan Mishra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1098', 'vikram.trivedi97@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Trivedi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1099', 'rohit.rao98@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohit Rao', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1100', 'mohit.bansal99@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mohit Bansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1101', 'aisha.sayal100@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Sayal', 'approved') ON DUPLICATE KEY UPDATE id=id;

-- 100 Generated Students
INSERT INTO students (id, email, password, name, status) VALUES ('STU1002', 'dhruv.singhal1@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Dhruv Singhal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1003', 'sanjay.jat2@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sanjay Jat', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1004', 'girish.singh3@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Girish Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1005', 'atharv.trivedi4@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Atharv Trivedi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1006', 'vijay.bindal5@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vijay Bindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1007', 'varun.chowdhury6@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Varun Chowdhury', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1008', 'ashish.chowdhury7@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ashish Chowdhury', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1009', 'rohan.verma8@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rohan Verma', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1010', 'atharv.ahuja9@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Atharv Ahuja', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1011', 'jitesh.khanna10@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Jitesh Khanna', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1012', 'shaurya.ahir11@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Shaurya Ahir', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1013', 'ayaan.singh12@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ayaan Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1014', 'mitesh.shah13@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mitesh Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1015', 'maryam.tayal14@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Maryam Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1016', 'ishita.shah15@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ishita Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1017', 'meher.gurjar16@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Meher Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1018', 'suresh.bindal17@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Suresh Bindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1019', 'deepak.gupta18@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Deepak Gupta', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1020', 'varun.jindal19@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Varun Jindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1021', 'aarav.gurjar20@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aarav Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1022', 'aisha.vyas21@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1023', 'sara.tiwari22@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sara Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1024', 'vivaan.ahuja23@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vivaan Ahuja', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1025', 'ishaan.mishra24@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ishaan Mishra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1026', 'sunil.vyas25@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1027', 'deepak.dubey26@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Deepak Dubey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1028', 'ritesh.vyas27@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ritesh Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1029', 'prakash.bhatt28@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Prakash Bhatt', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1030', 'praveen.naidu29@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Praveen Naidu', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1031', 'manish.rao30@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Manish Rao', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1032', 'pankaj.patel31@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pankaj Patel', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1033', 'ira.ahuja32@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ira Ahuja', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1034', 'sai.pandey33@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sai Pandey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1035', 'naveen.gurjar34@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Naveen Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1036', 'raj.das35@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Raj Das', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1037', 'aisha.joshi36@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aisha Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1038', 'reyansh.bhatt37@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Reyansh Bhatt', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1039', 'pankaj.mittal38@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pankaj Mittal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1040', 'pari.tayal39@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pari Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1041', 'darsh.ahir40@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Darsh Ahir', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1042', 'darsh.kapoor41@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Darsh Kapoor', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1043', 'pankaj.singh42@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pankaj Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1044', 'umesh.desai43@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Umesh Desai', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1045', 'arjun.goyal44@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Arjun Goyal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1046', 'nikhil.ahir45@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nikhil Ahir', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1047', 'ajay.sharma46@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ajay Sharma', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1048', 'nitin.mishra47@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nitin Mishra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1049', 'nilesh.shah48@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nilesh Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1050', 'vijay.joshi49@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vijay Joshi', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1051', 'pranav.reddy50@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pranav Reddy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1052', 'aditya.mahajan51@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aditya Mahajan', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1053', 'ahaana.tayal52@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ahaana Tayal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1054', 'avni.singhal53@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Avni Singhal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1055', 'vishal.kapoor54@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vishal Kapoor', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1056', 'ayaan.garg55@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ayaan Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1057', 'sumit.shah56@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sumit Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1058', 'pankaj.das57@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pankaj Das', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1059', 'aditya.singh58@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aditya Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1060', 'myra.tiwari59@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Myra Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1061', 'ravi.jindal60@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ravi Jindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1062', 'pari.bhatt61@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Pari Bhatt', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1063', 'satish.tiwari62@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Satish Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1064', 'sandeep.chowdhury63@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sandeep Chowdhury', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1065', 'advik.sharma64@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Advik Sharma', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1066', 'ritvik.chowdhury65@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ritvik Chowdhury', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1067', 'sunil.dubey66@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sunil Dubey', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1068', 'kabir.garg67@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kabir Garg', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1069', 'ayaan.naidu68@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ayaan Naidu', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1070', 'sai.chopra69@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sai Chopra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1071', 'rahul.kumar70@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Kumar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1072', 'neha.patel71@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Neha Patel', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1073', 'rudra.vyas72@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rudra Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1074', 'sara.kansal73@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sara Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1075', 'ramesh.yadav74@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ramesh Yadav', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1076', 'aarohi.shah75@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aarohi Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1077', 'atharv.jain76@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Atharv Jain', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1078', 'vikram.kansal77@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Vikram Kansal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1079', 'advik.desai78@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Advik Desai', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1080', 'sanjay.reddy79@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sanjay Reddy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1081', 'girish.vyas80@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Girish Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1082', 'rahul.singh81@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Singh', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1083', 'dhruv.khanna82@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Dhruv Khanna', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1084', 'karan.jindal83@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Karan Jindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1085', 'zara.gupta84@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Zara Gupta', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1086', 'mohit.shah85@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mohit Shah', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1087', 'aarohi.bindal86@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aarohi Bindal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1088', 'maryam.vyas87@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Maryam Vyas', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1089', 'deepak.agarwal88@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Deepak Agarwal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1090', 'rahul.mittal89@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Rahul Mittal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1091', 'mahesh.bhatt90@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mahesh Bhatt', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1092', 'mitesh.choudhary91@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Mitesh Choudhary', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1093', 'ayaan.malhotra92@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Ayaan Malhotra', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1094', 'kamlesh.ahuja93@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kamlesh Ahuja', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1095', 'aarohi.rao94@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Aarohi Rao', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1096', 'diya.goyal95@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Diya Goyal', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1097', 'suresh.gurjar96@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Suresh Gurjar', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1098', 'sneha.bhatt97@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Sneha Bhatt', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1099', 'kamlesh.reddy98@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Kamlesh Reddy', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1100', 'atharv.tiwari99@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Atharv Tiwari', 'approved') ON DUPLICATE KEY UPDATE id=id;
INSERT INTO students (id, email, password, name, status) VALUES ('STU1101', 'nitin.kapoor100@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', 'Nitin Kapoor', 'approved') ON DUPLICATE KEY UPDATE id=id;