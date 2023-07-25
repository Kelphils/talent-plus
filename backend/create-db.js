const mysql = require("mysql");

// MySQL local connection configuration
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
});

// MySQL private rds connection configuration
// const connection = mysql.createConnection({
//   host: "afex-stack-db.co7jbcdo5usr.eu-north-1.rds.amazonaws.com",
//   user: "master",
//   password: "master123",
// });

// Name of the database to be created
const databaseName = "tplus";

// SQL queries to create the database and tables
const createDatabaseQuery = `CREATE DATABASE IF NOT EXISTS ${databaseName}`;
const createTableQuery = `
  CREATE TABLE IF NOT EXISTS ${databaseName}.users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    occupation VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL
  )
`;

// Connect to MySQL server
connection.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL server:", err);
    return;
  }

  console.log("Connected to MySQL server");

  // Create the database
  connection.query(createDatabaseQuery, (err) => {
    if (err) {
      console.error("Error creating database:", err);
      connection.end();
      return;
    }

    console.log(`Database '${databaseName}' created or already exists`);

    // Select the database
    connection.query(`USE ${databaseName}`, (err) => {
      if (err) {
        console.error("Error selecting database:", err);
        connection.end();
        return;
      }

      console.log(`Using database '${databaseName}'`);

      // Create the table
      connection.query(createTableQuery, (err) => {
        if (err) {
          console.error("Error creating table:", err);
        } else {
          console.log("Table created or already exists");
        }

        // Close the connection
        connection.end();
      });
    });
  });
});
