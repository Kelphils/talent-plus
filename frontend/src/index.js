// src/index.js

import React from "react";
import ReactDOM from "react-dom";
import App from "./App";
import "./styles.css"; // Import the CSS file

ReactDOM.render(
  <React.StrictMode>
    <div className="main-container">
      {" "}
      {/* Add a class name for styling */}
      <App />
    </div>
  </React.StrictMode>,
  document.getElementById("root")
);
