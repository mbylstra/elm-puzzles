'use strict';

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const tmp = require('tmp');
const { compileToString } = require('node-elm-compiler');

// Constants
const PORT = 8080;
const HOST = '0.0.0.0';

// App
const app = express();

// cors
app.use(cors());
app.options('*', cors());

app.use(bodyParser.json());

app.post('/compile', (req, res) => {
  var tmpFile = tmp.file(
    { postfix: '.elm', keep: true },
    function _tempFileCreated(err, path, fd, cleanupCallback) {
      console.log(path);

      fs.writeFile(path, req.body.source, function(err) {
        console.log(req);
        if (err) {
          return console.log(err);
        } else {
          compileToString([path], { yes: true }).then(function(data) {
            console.log('Text', data.toString());
            res.send(data.toString());
          });
        }
      });

      // const exec = require('child_process').exec;
      // const outputFilePath = path;
      // const command = `elm make --yes --output ${path}`;
      // const child = exec(command, (error, stdout, stderr) => {
      //   console.log(`stdout: ${stdout}`);
      //   console.log(`stderr: ${stderr}`);
      //   if (error !== null) {
      //     console.log(`exec error: ${error}`);
      //     res.send(error);
      //   } else {
      //     const jsContents = fs.readFileSync(path, 'utf8');
      //     console.log('jsContents', jsContents);
      //     // cleanupCallback();
      //     res.send(jsContents);
      //   }
      // });
    }
  );
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);
