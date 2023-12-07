const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('Hello, World! jenkins test CICD non compile check');
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
