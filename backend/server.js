// server.js

const express = require("express");
const mysql = require("mysql");
const cors = require("cors");

const app = express();
const port = process.env.PORT || 3001;

app.use(express.json());
app.use(cors());

// Replace the following connection configuration with your MySQL database settings
const connection = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
});

// server.js
const bodyParser = require("body-parser");

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

const databaseName = "tableplus"; // Replace 'your_database_name' with your desired database name
const tableName = "users";

const createDatabaseQuery = `CREATE DATABASE IF NOT EXISTS ${databaseName}`;
const createTableQuery = `
  CREATE TABLE IF NOT EXISTS ${databaseName}.${tableName} (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    occupation VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL
  )
`;

// Connect to MySQL server and create the database and table
connection.connect((err) => {
  if (err) {
    console.error("Error connecting to MySQL:", err);
    return;
  }

  connection.query(createDatabaseQuery, (err) => {
    if (err) {
      console.error("Error creating database:", err);
      return;
    }

    connection.query(createTableQuery, (err) => {
      if (err) {
        console.error("Error creating table:", err);
        return;
      }

      console.log("Database and table are created (if not already exist)");
    });
  });
});

// REST API endpoints
app.post("/users", (req, res) => {
  const user = req.body;

  connection.query(
    `INSERT INTO ${databaseName}.${tableName} SET ?`,
    user,
    (err, result) => {
      if (err) {
        console.error("Error inserting user:", err);
        res.status(500).send("Error inserting user");
        return;
      }

      res.status(201).send("User added successfully");
    }
  );
});

app.get("/users", (req, res) => {
  connection.query(
    `SELECT * FROM ${databaseName}.${tableName}`,
    (err, rows) => {
      if (err) {
        console.error("Error fetching users:", err);
        res.status(500).send("Error fetching users");
        return;
      }

      res.status(200).json(rows);
    }
  );
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
