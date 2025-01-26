const express = require('express');
const app = express();

app.get('/api/service-b', (req, res) => {
  res.json({ message: 'Hello from Service B' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Service B running on port ${PORT}`);
});