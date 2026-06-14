const db = require('./config/db');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const path = require('path');

const firstNames = [
  'Liam', 'Noah', 'Oliver', 'Elijah', 'William', 'James', 'Benjamin', 'Lucas', 'Henry', 'Alexander',
  'Mason', 'Michael', 'Ethan', 'Daniel', 'Jacob', 'Logan', 'Jackson', 'Levi', 'Sebastian', 'Mateo',
  'Jack', 'Owen', 'Theodore', 'Aiden', 'Samuel', 'Joseph', 'John', 'David', 'Wyatt', 'Carter',
  'Julian', 'Hudson', 'Grayson', 'Matthew', 'Ezra', 'Gabriel', 'Waylon', 'Isaac', 'Lincoln', 'Lincoln',
  'Olivia', 'Emma', 'Charlotte', 'Amelia', 'Ava', 'Sophia', 'Isabella', 'Mia', 'Evelyn', 'Harper',
  'Camila', 'Gianna', 'Abigail', 'Luna', 'Ella', 'Elizabeth', 'Sofia', 'Emily', 'Avery', 'Mila',
  'Scarlett', 'Eleanor', 'Madison', 'Layla', 'Penelope', 'Aria', 'Chloe', 'Grace', 'Ellie', 'Nora',
  'Hazel', 'Zoey', 'Riley', 'Victoria', 'Lily', 'Aurora', 'Violet', 'Nova', 'Hannah', 'Emilia'
];

const lastNames = [
  'Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez',
  'Hernandez', 'Lopez', 'Gonzalez', 'Wilson', 'Anderson', 'Thomas', 'Taylor', 'Moore', 'Jackson', 'Martin',
  'Lee', 'Perez', 'Thompson', 'White', 'Harris', 'Sanchez', 'Clark', 'Ramirez', 'Lewis', 'Robinson',
  'Walker', 'Young', 'Allen', 'King', 'Wright', 'Scott', 'Torres', 'Nguyen', 'Hill', 'Flores',
  'Green', 'Adams', 'Nelson', 'Baker', 'Hall', 'Rivera', 'Campbell', 'Mitchell', 'Carter', 'Roberts'
];

async function seed() {
  console.log('Starting student seeding process...');
  const studentsList = [];
  const csvRows = ['StudentID,Name,Email,Password'];

  // Generate 100 students
  for (let i = 1; i <= 100; i++) {
    const studentNum = 2000 + i; // STU2001 to STU2100
    const studentId = `STU${studentNum}`;
    
    // Create semi-random names based on lists
    const firstName = firstNames[(i - 1) % firstNames.length];
    const lastName = lastNames[(i - 1) % lastNames.length];
    const name = `${firstName} ${lastName}`;
    
    const email = `stu${studentNum}@exam.com`;
    const plainPassword = `pass${studentNum}`; // e.g. pass2001

    studentsList.push({
      id: studentId,
      name,
      email,
      plainPassword
    });

    csvRows.push(`${studentId},"${name}",${email},${plainPassword}`);
  }

  // Write Excel-compatible CSV file
  const csvPath = path.join(__dirname, '..', 'student_logins.csv');
  try {
    fs.writeFileSync(csvPath, csvRows.join('\n'), 'utf8');
    console.log(`Excel credentials sheet successfully created at: ${csvPath}`);
  } catch (err) {
    console.error('Failed to write CSV file:', err);
  }

  // Insert into DB
  try {
    console.log('Hashing passwords and saving to MySQL database...');
    
    const connection = await db.getConnection();
    try {
      await connection.beginTransaction();
      
      for (const student of studentsList) {
        const hashedPassword = await bcrypt.hash(student.plainPassword, 10);
        
        await connection.query(
          `INSERT INTO students (id, name, email, password, status) 
           VALUES (?, ?, ?, ?, 'approved') 
           ON DUPLICATE KEY UPDATE name=VALUES(name), email=VALUES(email), password=VALUES(password), status='approved'`,
          [student.id, student.name, student.email, hashedPassword]
        );
      }
      
      await connection.commit();
      console.log('100 students successfully loaded/updated in database.');
    } catch (dbErr) {
      await connection.rollback();
      throw dbErr;
    } finally {
      connection.release();
    }
  } catch (err) {
    console.error('Database seeding failed:', err.message);
  } finally {
    // End the process
    console.log('Seeding completed.');
    process.exit(0);
  }
}

seed();
