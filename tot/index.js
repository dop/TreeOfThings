const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const express = require('express');

const app = express();

const FILE_DIR = './files';

function md5(x) {
  const hash = crypto.createHash('md5');
  hash.update(x);
  return hash.digest('hex');
}

const files = {};
fs.readdirSync(FILE_DIR).forEach(filename => {
  const content = fs.readFileSync(path.join(FILE_DIR, filename), {encoding: 'utf-8'});
  const hash = md5(content);
  files[hash] = content;
});

app.get('/', (req, res) => res.send(Object.keys(files)));

app.get('/:id', (req, res) => res.send(files[req.params.id]));

app.post('/:id', (req, res) => {
  files[req.params.id] = req.
  res.sendStatus(200);
});

app.listen(8080, () => {
  console.log('ok');
  console.log(Object.keys(files));
});
