// src/components/UserForm.js

import React, { useState } from "react";
import axios from "axios";

const UserForm = () => {
  const [name, setName] = useState("");
  const [age, setAge] = useState("");
  const [email, setEmail] = useState("");
  const [occupation, setOccupation] = useState("");
  const [gender, setGender] = useState(""); // State to hold the selected gender

  const handleSubmit = (e) => {
    e.preventDefault();
    const newUser = { name, age, email, occupation, gender }; // Include gender in the newUser object

    axios
      .post("http://localhost:3001/users", newUser)
      .then((response) => {
        console.log(response.data);
        setName("");
        setAge("");
        setEmail("");
        setOccupation("");
        setGender(""); // Clear the gender state after submitting the form
      })
      .catch((error) => {
        console.error(error.response.data);
      });
  };

  return (
    <div>
      <h2>Add User</h2>
      <form onSubmit={handleSubmit}>
        <div>
          <label htmlFor="name">Name:</label>
          <input
            type="text"
            id="name"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="age">Age:</label>
          <input
            type="number"
            id="age"
            value={age}
            onChange={(e) => setAge(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="email">Email:</label>
          <input
            type="email"
            id="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="occupation">Occupation:</label>
          <input
            type="text"
            id="occupation"
            value={occupation}
            onChange={(e) => setOccupation(e.target.value)}
            required
          />
        </div>
        <div>
          <label htmlFor="gender">Gender:</label>
          <select
            id="gender"
            value={gender}
            onChange={(e) => setGender(e.target.value)}
            required
          >
            <option value="">Select Gender</option>
            <option value="Male">Male</option>
            <option value="Female">Female</option>
          </select>
        </div>
        <button type="submit">Submit</button>
      </form>
    </div>
  );
};

export default UserForm;
