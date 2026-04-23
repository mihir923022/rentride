const mysql = require('mysql');

// Create connection
const db = mysql.createConnection({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'rentride'
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err);
  } else {
    console.log('Connected to MySQL database');

    // Create database if not exists
    db.query('CREATE DATABASE IF NOT EXISTS rentride', (err) => {
      if (err) console.error(err);

      db.query('USE rentride');

      // Create table if not exists
      db.query(`
        CREATE TABLE IF NOT EXISTS vehicles (
          id INT AUTO_INCREMENT PRIMARY KEY,
          name VARCHAR(100),
          type VARCHAR(50),
          price DECIMAL(10,2)
        )
      `);
    });
  }
});

module.exports = db;
