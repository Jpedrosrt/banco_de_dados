const express = require("express");
const app = express();
const path = require('path');
const bodyParser = require('body-parser')
const fs = require('fs');

// CONFIG
// ARQUIVOS
    app.use(express.static(path.join(__dirname, 'arquivos')));
    const dataFilePath = path.join(__dirname, 'arquivos', 'usuarios.txt');
// BODY PARSER
    app.use(bodyParser.urlencoded({extended: false}))
    app.use(bodyParser.json())
// ROTAS

let userData = {};

app.post('/usuario', (req, res) => {
    const { cpf, nome, data_nascimento } = req.body;

    const dataNascimento = new Date(data_nascimento)
    const dia = dataNascimento.getDate();
    const mes = dataNascimento.getMonth() + 1;
    const ano = dataNascimento.getFullYear();

    const userData = {
      cpf: parseInt(cpf),
      nome,
      data_nascimento: dia+"/"+mes+"/"+ano
    };

    let dadosUsuarios = [];
    if (fs.existsSync(dataFilePath)) {
        const data = fs.readFileSync(dataFilePath, 'utf8');
        dadosUsuarios = JSON.parse(data);
    }

    dadosUsuarios.push(userData);

    fs.writeFileSync(dataFilePath, JSON.stringify(dadosUsuarios));

    res.send('Dados do usuário armazenados com sucesso!');
});

app.get('/usuario', (req, res) => {
    res.sendFile(path.join(__dirname, 'html', 'index.html'));
});

app.get('/dados-usuario', (req, res) => {
    if (fs.existsSync(dataFilePath)) {
        const data = fs.readFileSync(dataFilePath, 'utf8');
        const dadosUsuarios = JSON.parse(data);
        res.json(dadosUsuarios);
      } else {
        res.json([]);
      }
});

app.listen(8081, function(){
    console.log("Servidor Rodando na porta 8081");
});