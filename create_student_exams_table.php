<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "CREATE TABLE IF NOT EXISTS student_exams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    exam_id INT NOT NULL,
    started_at DATETIME NOT NULL,
    status ENUM('started', 'completed', 'blocked') DEFAULT 'started',
    demerit_points INT DEFAULT 0,
    block_until DATETIME DEFAULT NULL,
    score INT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (exam_id) REFERENCES exams(id)
)";

if ($conn->query($sql) === TRUE) {
    echo "Table student_exams created successfully";
} else {
    echo "Error creating table: " . $conn->error;
}
$conn->close();
?>
