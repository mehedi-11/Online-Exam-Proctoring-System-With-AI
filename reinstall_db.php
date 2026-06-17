<?php
// Connect to MySQL (without selecting a specific database yet)
$conn = new mysqli('localhost', 'root', '');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// 1. Drop the existing corrupted database and recreate it
$conn->query("DROP DATABASE IF EXISTS online_exam");
$conn->query("CREATE DATABASE online_exam");
$conn->select_db('online_exam');

// 2. Create the core tables that might be missing from database.sql
$core_tables = "
CREATE TABLE IF NOT EXISTS admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS teachers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  profile_image VARCHAR(255) DEFAULT NULL,
  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
  joining_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS students (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  profile_image VARCHAR(255) DEFAULT NULL,
  status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending'
);

CREATE TABLE IF NOT EXISTS exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  exam_date DATETIME NOT NULL,
  duration_minutes INT NOT NULL,
  must_on_camera BOOLEAN DEFAULT TRUE,
  must_on_microphone BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS exam_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT,
  question_text TEXT NOT NULL,
  option_a VARCHAR(255) DEFAULT NULL,
  option_b VARCHAR(255) DEFAULT NULL,
  option_c VARCHAR(255) DEFAULT NULL,
  option_d VARCHAR(255) DEFAULT NULL,
  correct_option ENUM('A', 'B', 'C', 'D') DEFAULT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS student_exams (
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

CREATE TABLE IF NOT EXISTS proctoring_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT,
  student_id VARCHAR(50),
  activity_type VARCHAR(100) NOT NULL,
  details TEXT,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);
";

if ($conn->multi_query($core_tables)) {
    do {
        if ($result = $conn->store_result()) {
            $result->free();
        }
    } while ($conn->more_results() && $conn->next_result());
} else {
    die("Error creating tables: " . $conn->error);
}

// 3. Read the database.sql file
$sqlFile = file_get_contents(__DIR__ . '/database.sql');
if (!$sqlFile) {
    die("Error: Could not read database.sql file.");
}

// 3. Execute all queries from database.sql
if ($conn->multi_query($sqlFile)) {
    do {
        // Free result sets to move to the next query
        if ($result = $conn->store_result()) {
            $result->free();
        }
    } while ($conn->more_results() && $conn->next_result());
} else {
    die("Error importing database.sql: " . $conn->error);
}

// 4. Run the update_db.php logic to apply all recent schema changes
$conn->query("ALTER TABLE teachers ADD COLUMN llm_api_key VARCHAR(255) DEFAULT NULL;");
$conn->query("ALTER TABLE exams ADD COLUMN end_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;");
$conn->query("ALTER TABLE exams ADD COLUMN type ENUM('MCQ', 'Written', 'Both') DEFAULT 'MCQ';");
$conn->query("ALTER TABLE exams ADD COLUMN is_live BOOLEAN DEFAULT FALSE;");
$conn->query("ALTER TABLE exams ADD COLUMN exam_password VARCHAR(255) DEFAULT NULL;");
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

echo "<h2>✅ Database has been successfully dropped, cleaned, and re-imported!</h2>";
echo "<p>All recent schema updates have also been applied automatically.</p>";
echo "<p>Please restart your Node.js backend (npm start) and try logging in again.</p>";
?>
