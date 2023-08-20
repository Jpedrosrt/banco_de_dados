from flask import Flask, jsonify, request

app = Flask(__name__)

usuarios = []

@app.route('/usuarios', methods=['GET'])
def obter_usuarios():
    return jsonify(usuarios)

@app.route('/usuarios/<int:cpf>', methods=['GET'])
def obter_usuario(cpf):
    for usuario in usuarios:
        if usuario['cpf'] == cpf:
            return jsonify(usuario)
    
    return jsonify({'mensagem': 'Usuário não encontrado'}), 404

@app.route('/usuarios', methods=['POST'])
def criar_usuario():
    dados = request.get_json()

    cpf = dados['cpf']
    nome = dados['nome']
    data_nascimento = dados['data_nascimento']

    novo_usuario = {
        'cpf': cpf,
        'nome': nome,
        'data_nascimento': data_nascimento
    }

    usuarios.append(novo_usuario)

    return jsonify({'mensagem': 'Usuário criado com sucesso'}), 201

app.run(port=5000,host='localhost',debug=True)
