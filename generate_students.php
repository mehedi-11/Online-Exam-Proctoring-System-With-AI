<?php
$conn = new mysqli('localhost', 'root', '', 'online_exam');
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$hash = '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S';

$firstNames = ['Aarav', 'Vivaan', 'Aditya', 'Vihaan', 'Arjun', 'Sai', 'Reyansh', 'Ayaan', 'Krishna', 'Ishaan', 'Shaurya', 'Atharv', 'Advik', 'Pranav', 'Kabir', 'Ritvik', 'Aaryan', 'Dhruv', 'Darsh', 'Rudra', 'Ananya', 'Aadhya', 'Saanvi', 'Diya', 'Pari', 'Anika', 'Navya', 'Avni', 'Ahaana', 'Myra', 'Ira', 'Aarohi', 'Fatima', 'Aisha', 'Zara', 'Sara', 'Zoya', 'Maryam', 'Meher', 'Samira', 'Riya', 'Ishita', 'Sneha', 'Pooja', 'Neha', 'Rohan', 'Rahul', 'Amit', 'Vikram', 'Raj', 'Siddharth', 'Karan', 'Tarun', 'Varun', 'Nitin', 'Nikhil', 'Manish', 'Suresh', 'Ramesh', 'Ravi', 'Prakash', 'Ajay', 'Vijay', 'Surya', 'Akash', 'Gaurav', 'Saurabh', 'Alok', 'Mohit', 'Rohit', 'Sumit', 'Ankit', 'Vishal', 'Sunil', 'Anil', 'Deepak', 'Sandeep', 'Naveen', 'Praveen', 'Sanjay', 'Santosh', 'Ashish', 'Manish', 'Arun', 'Pankaj', 'Dinesh', 'Mukesh', 'Harish', 'Girish', 'Satish', 'Kamlesh', 'Yogesh', 'Rupesh', 'Mahesh', 'Umesh', 'Naresh', 'Lokesh', 'Jitesh', 'Bhavesh', 'Hitesh', 'Ritesh', 'Mitesh', 'Nilesh'];
$lastNames = ['Sharma', 'Verma', 'Gupta', 'Kumar', 'Singh', 'Das', 'Roy', 'Chowdhury', 'Patel', 'Shah', 'Mehta', 'Desai', 'Joshi', 'Bhatt', 'Trivedi', 'Vyas', 'Pandey', 'Mishra', 'Tiwari', 'Dubey', 'Yadav', 'Ahir', 'Jat', 'Gurjar', 'Reddy', 'Rao', 'Naidu', 'Choudhary', 'Mahajan', 'Kapoor', 'Malhotra', 'Chopra', 'Khanna', 'Ahuja', 'Bansal', 'Agarwal', 'Garg', 'Jain', 'Goyal', 'Mittal', 'Singhal', 'Kansal', 'Bindal', 'Jindal', 'Tayal', 'Sayal'];

$sql_inserts = [];

for ($i = 1; $i <= 100; $i++) {
    $id = 'STU' . (1001 + $i);
    $name = $firstNames[array_rand($firstNames)] . ' ' . $lastNames[array_rand($lastNames)];
    $email = strtolower(str_replace(' ', '.', $name)) . $i . '@exam.com';
    
    $sql = "INSERT INTO students (id, email, password, name, status) VALUES ('$id', '$email', '$hash', '$name', 'approved') ON DUPLICATE KEY UPDATE id=id;";
    $sql_inserts[] = $sql;
    
    $conn->query($sql);
}

$file = 'database.sql';
$current_content = file_get_contents($file);
$current_content .= "\n\n-- 100 Generated Students\n" . implode("\n", $sql_inserts);
file_put_contents($file, $current_content);

echo "Successfully added 100 students to the database and updated database.sql";
?>
