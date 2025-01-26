const express = require('express');
const app = express();

app.get('/api/service-a', (req, res) => {
  res.json({ message: 'Hello from Service A' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Service A running on port ${PORT}`);
});
