const db = require('./src/config/db');

async function alterTable() {
  try {
    console.log('Adding course and university fields to exams table...');
    await db.query(`
      ALTER TABLE exams 
      ADD COLUMN course_name VARCHAR(255) DEFAULT NULL,
      ADD COLUMN course_code VARCHAR(100) DEFAULT NULL,
      ADD COLUMN university_name VARCHAR(255) DEFAULT NULL;
    `);
    console.log('Columns added successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error altering table:', error);
    process.exit(1);
  }
}

alterTable();
