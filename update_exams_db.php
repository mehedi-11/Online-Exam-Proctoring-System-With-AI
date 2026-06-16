<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Ignore errors if columns already exist
$conn->query("ALTER TABLE exams ADD COLUMN must_on_camera BOOLEAN DEFAULT TRUE;");
$conn->query("ALTER TABLE exams ADD COLUMN must_on_microphone BOOLEAN DEFAULT TRUE;");

echo "Database updated successfully!";
?>
