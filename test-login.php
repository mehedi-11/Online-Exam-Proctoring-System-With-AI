<?php
$data = array('email' => 'admin@exam.com', 'password' => 'admin123');
$ch = curl_init('http://localhost:5000/api/auth/login/admin');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json'));
$response = curl_exec($ch);
curl_close($ch);
echo "Response from API: " . $response;
?>
