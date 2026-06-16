const bcrypt = require('bcryptjs');
const db = require('./src/config/db');

async function fixPassword() {
  const hash = await bcrypt.hash('admin123', 10);
  await db.query("UPDATE admins SET password = ? WHERE email = 'admin@exam.com'", [hash]);
  console.log("Updated password for admin@exam.com to admin123");
  process.exit(0);
}

fixPassword();
