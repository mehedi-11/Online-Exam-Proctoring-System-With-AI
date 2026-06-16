<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Add teacher_id column
$conn->query("ALTER TABLE exams ADD COLUMN teacher_id INT DEFAULT NULL;");

// Optional: You could update existing exams to belong to a specific teacher if there's any.
$conn->query("UPDATE exams SET teacher_id = (SELECT id FROM teachers LIMIT 1) WHERE teacher_id IS NULL;");

echo "Database updated: teacher_id added to exams!";
?>
