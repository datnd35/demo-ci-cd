const express = require('express');
const path = require('path');
const app = express();

const PORT = process.env.PORT || 8080;

// Health check endpoint for Kubernetes
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.use(express.static(path.join(__dirname, '..', 'frontend', 'dist', 'frontend')));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'frontend', 'dist', 'frontend', 'index.html'));
});

app.listen(PORT, () => console.log(`Server running on ${PORT}`));
