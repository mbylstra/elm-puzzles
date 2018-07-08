'use strict';

const express = require('express');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();
app.get('/', (req, res) => {
  const exec = require('child_process').exec;
  const child = exec('elm make --yes',
      (error, stdout, stderr) => {
          console.log(`stdout: ${stdout}`);
          console.log(`stderr: ${stderr}`);
          if (error !== null) {
              console.log(`exec error: ${error}`);
          }
          res.send('Hello world\n');
  });

});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

