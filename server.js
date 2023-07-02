const express = require("express")
const app = express()
const path = require('path')
const bodyParser = require('body-parser')
const cookieParser = require('cookie-parser')

// CONFIG
// COOKIE
app.use(cookieParser());
// ARQUIVOS
app.use(express.static(path.join(__dirname, 'arquivos')));
const dataFilePath = path.join(__dirname, 'arquivos', 'usuarios.txt');
// BODY PARSER
app.use(bodyParser.urlencoded({extended: false}))
app.use(bodyParser.json())
// ROTAS

let userData = {}

app.post('/usuario', (req, res) => {
    const { cpf, nome, data_nascimento } = req.body
  
    const dataNascimento = new Date(data_nascimento)
    const dia = dataNascimento.getDate()
    const mes = dataNascimento.getMonth() + 1
    const ano = dataNascimento.getFullYear()
  
    const userData = {
      cpf: parseInt(cpf),
      nome,
      data_nascimento: dia + "/" + mes + "/" + ano,
    }
  
    let dadosUsuarios = [];
    if (typeof req.cookies.dadosUsuarios === 'string') {
        dadosUsuarios = JSON.parse(req.cookies.dadosUsuarios);
    }
    dadosUsuarios.push(userData);
  
    res.cookie('dadosUsuarios', JSON.stringify(dadosUsuarios), { maxAge: 86400000 }) // Define o cookie 'dadosUsuarios' com o array de dados de usuários
  
    res.send('Dados do usuário armazenados com sucesso!')
})  

app.get('/usuario', (req, res) => {
    res.sendFile(path.join(__dirname, 'html', 'index.html'))
})

app.get('/dados-usuario', (req, res) => {
    let dadosUsuarios = [];
    if (typeof req.cookies.dadosUsuarios === 'string') {
        dadosUsuarios = JSON.parse(req.cookies.dadosUsuarios);
    }
  
    res.json(dadosUsuarios);
});
  

app.listen(8081, function(){
    console.log("Servidor Rodando na porta 8081")
})
