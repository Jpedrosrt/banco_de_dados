from flask import Flask, render_template, request, redirect

# Importe sua classe MeuProgramaPG do arquivo db.py
from db import MeuProgramaPG

app = Flask(__name__, template_folder='templates')

# Conexão com o banco de dados
programa = MeuProgramaPG(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="postgres",
    port="5432"
)

# Rota para a página inicial
@app.route('/')
def index():
    return render_template('index.html')

# ...

@app.route('/inserir_dados_pessoais', methods=['GET', 'POST'])
def inserir_dados_pessoais():
    if request.method == 'POST':
        if request.form['dependentes_id']:
            dependentes_id = int(request.form['dependentes_id'])
        else:
            dependentes_id = None
        valores = (
            request.form['cpf'],
            request.form['genero'],
            request.form['estado_civil'],
            request.form['data_de_nascimento'],
            request.form['nome_completo'],
            request.form['email'],
            request.form['funcionarios_id'],
            dependentes_id
        )
        programa.inserir_linha('dados_pessoais', valores)  # Não é necessário colocar RH.dados_pessoais
        return redirect('/')
    return render_template('inserir_dados_pessoais.html')


# Rota para a página de inserção de cargos
@app.route('/inserir_cargo', methods=['GET', 'POST'])
def inserir_cargo():
    if request.method == 'POST':
        valores = (
            request.form['nome_do_cargo']
        )
        programa.inserir_linha('cargo', valores)
        return redirect('/')
    return render_template('inserir_cargo.html')

# Rota para a página de associação de funcionários a cargos
@app.route('/associar_funcionario_cargo', methods=['GET', 'POST'])
def associar_funcionario_cargo():
    if request.method == 'POST':
        valores = (
            request.form['funcionario_id'],
            request.form['cargo_id']
        )
        programa.inserir_linha('funcionarios_cargo', valores)
        return redirect('/')
    return render_template('associar_funcionario_cargo.html')

# Rota para a página de consulta de funcionários
@app.route('/consultar_funcionarios')
def consultar_funcionarios():
    resultados = programa.consultar_tabela('dados_pessoais')
    return render_template('consultar_funcionarios.html', resultados=resultados)

# Rota para a página de consulta de cargos
@app.route('/consultar_cargos')
def consultar_cargos():
    resultados = programa.consultar_tabela('cargo')
    return render_template('consultar_cargos.html', resultados=resultados)

# Rota para a página de consulta de associações
@app.route('/consultar_associacoes')
def consultar_associacoes():
    resultados = programa.consultar_tabela('funcionarios_cargo')
    return render_template('consultar_associacoes.html', resultados=resultados)

if __name__ == '__main__':
    app.run(debug=True)
