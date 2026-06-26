const db = require('./src/config/db');

async function createTable() {
  try {
    console.log('Creating admin_notifications table...');
    await db.query(`
      CREATE TABLE IF NOT EXISTS admin_notifications (
        id INT AUTO_INCREMENT PRIMARY KEY,
        message TEXT NOT NULL,
        is_read BOOLEAN DEFAULT FALSE,
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('Table created successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error creating table:', error);
    process.exit(1);
  }
}

createTable();
