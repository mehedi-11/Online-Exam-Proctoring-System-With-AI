<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
$result = $conn->query("SELECT email, password FROM admins UNION SELECT email, password FROM teachers UNION SELECT id, password FROM students");
while($row = $result->fetch_array()) {
    echo $row[0] . " | " . $row[1] . "<br>";
}
?>
