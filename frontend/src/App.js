// src/App.js
import React, { useState, useEffect } from "react";

function App() {
  const [serviceAData, setServiceAData] = useState("");
  const [serviceBData, setServiceBData] = useState("");

  useEffect(() => {
    // Fetch data from Service A
    fetch("/api/service-a")
      .then((response) => response.json())
      .then((data) => setServiceAData(data.message))
      .catch((error) => console.error("Error fetching Service A:", error));

    // Fetch data from Service B
    fetch("/api/service-b")
      .then((response) => response.json())
      .then((data) => setServiceBData(data.message))
      .catch((error) => console.error("Error fetching Service B:", error));
  }, []);

  return (
    <div>
      <h1>Frontend</h1>
      <h2>Data from Service A:</h2>
      <p>{serviceAData}</p>
      <h2>Data from Service B:</h2>
      <p>{serviceBData}</p>
    </div>
  );
}

export default App;
