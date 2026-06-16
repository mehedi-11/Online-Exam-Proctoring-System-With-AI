<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
$result = $conn->query("SELECT * FROM admins");
if (!$result) {
    echo "Error querying admins: " . $conn->error . "<br>";
} else {
    while($row = $result->fetch_assoc()) {
        echo "Admin: " . $row['email'] . " | Hash: " . $row['password'] . "<br>";
    }
}
$result = $conn->query("SHOW TABLES");
if ($result) {
    while($row = $result->fetch_array()) {
        echo "Table: " . $row[0] . "<br>";
    }
}
?>
