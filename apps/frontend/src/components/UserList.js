// src/components/UserList.js

import React, { useEffect, useState } from "react";
import axios from "axios";

const UserList = () => {
  const [users, setUsers] = useState([]);
  const [showUsers, setShowUsers] = useState(false);

  useEffect(() => {
    if (showUsers) {
      axios
        .get("http://localhost:3001/users")
        .then((response) => {
          setUsers(response.data);
        })
        .catch((error) => {
          console.error(error.response.data);
        });
    }
  }, [showUsers]);

  const handleViewUsers = () => {
    setShowUsers(true);
  };

  return (
    <div>
      <h2>User List</h2>
      <button onClick={handleViewUsers}>View Users</button>
      {showUsers && (
        <ul>
          {users.map((user) => (
            <li key={user.id}>
              <strong>Name:</strong> {user.name}, <strong>Age:</strong>{" "}
              {user.age}, <strong>Email:</strong> {user.email},{" "}
              <strong>Occupation:</strong> {user.occupation},{" "}
              <strong>Gender:</strong> {user.gender}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default UserList;
