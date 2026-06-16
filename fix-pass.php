<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function updatePassword($conn, $table, $emailField, $email, $plainPassword) {
    $hash = password_hash($plainPassword, PASSWORD_BCRYPT);
    $hash = str_replace('$2y$', '$2a$', $hash); // Fix for NodeJS bcryptjs
    $stmt = $conn->prepare("UPDATE $table SET password = ? WHERE $emailField = ?");
    $stmt->bind_param("ss", $hash, $email);
    $stmt->execute();
    echo "Updated $table $email: " . $stmt->affected_rows . " rows affected.<br>";
}

updatePassword($conn, 'admins', 'email', 'admin@exam.com', 'admin123');
updatePassword($conn, 'teachers', 'email', 'teacher@exam.com', 'teacher123');
updatePassword($conn, 'students', 'id', 'STU1001', 'student123');

echo "All mock data passwords have been re-hashed with NodeJS-compatible hashes!";
?>
