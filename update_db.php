<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Update teachers table
$conn->query("ALTER TABLE teachers ADD COLUMN llm_api_key VARCHAR(255) DEFAULT NULL;");

// Update exams table
$conn->query("ALTER TABLE exams ADD COLUMN end_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;");
$conn->query("ALTER TABLE exams ADD COLUMN type ENUM('MCQ', 'Written', 'Both') DEFAULT 'MCQ';");
$conn->query("ALTER TABLE exams ADD COLUMN is_live BOOLEAN DEFAULT FALSE;");
$conn->query("ALTER TABLE exams ADD COLUMN exam_password VARCHAR(255) DEFAULT NULL;");

// Update exam_questions table
$conn->query("ALTER TABLE exam_questions ADD COLUMN type ENUM('MCQ', 'Written') DEFAULT 'MCQ';");
$conn->query("ALTER TABLE exam_questions ADD COLUMN marks INT NOT NULL DEFAULT 1;");
$conn->query("ALTER TABLE exam_questions MODIFY option_a VARCHAR(255) DEFAULT NULL;");
$conn->query("ALTER TABLE exam_questions MODIFY option_b VARCHAR(255) DEFAULT NULL;");
$conn->query("ALTER TABLE exam_questions MODIFY option_c VARCHAR(255) DEFAULT NULL;");
$conn->query("ALTER TABLE exam_questions MODIFY option_d VARCHAR(255) DEFAULT NULL;");
$conn->query("ALTER TABLE exam_questions MODIFY correct_option ENUM('A', 'B', 'C', 'D') DEFAULT NULL;");

// Create student_answers table
$conn->query("CREATE TABLE IF NOT EXISTS student_answers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id VARCHAR(50),
  exam_id INT,
  question_id INT,
  student_answer TEXT,
  marks_awarded INT DEFAULT NULL,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
  FOREIGN KEY (question_id) REFERENCES exam_questions(id) ON DELETE CASCADE
);");

echo "Database updated successfully!";
?>
