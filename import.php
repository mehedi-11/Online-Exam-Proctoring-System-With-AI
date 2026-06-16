<?php
$conn = new mysqli('localhost', 'root', '');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$conn->query("DROP DATABASE IF EXISTS online_exam");
$conn->query("CREATE DATABASE online_exam");
$conn->query("USE online_exam");

$sql = file_get_contents('database.sql');
if ($conn->multi_query($sql)) {
    do {
        // consume all results
    } while ($conn->more_results() && $conn->next_result());
    echo "Database imported successfully.";
} else {
    echo "Error importing database: " . $conn->error;
}
?>
