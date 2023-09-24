from flask import Flask, render_template, request, redirect
import json

from db import MeuProgramaPG

app = Flask(__name__, template_folder='templates')

programa = MeuProgramaPG(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="postgres",
    port="5432"
)
    
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/adicionar_funcionario')
def adicionar_funcionario():

    id_funcionario = programa.adicionar_funcionario()
    
    if id_funcionario is not None:
        return redirect(f'/adicionar_dados_pessoais/{id_funcionario}')
    else:
        return "Erro ao adicionar funcionário. Por favor, tente novamente."


@app.route('/adicionar_dados_pessoais/<int:id_funcionario>', methods=['GET', 'POST'])
def adicionar_dados(id_funcionario):

    if request.method == 'POST':
        valores = (
            request.form['cpf'],
            request.form['genero'],
            request.form['estado_civil'],
            request.form['data_de_nascimento'],
            request.form['nome_completo'],
            request.form['email'],
            id_funcionario,
            None
        )

        id_dados_pessoais = programa.adicionar_dados('dados_pessoais', valores)
        if id_dados_pessoais is not None:
            print(id_dados_pessoais)
            return redirect(f'/adicionar_telefones/{id_dados_pessoais}')
        else:
            return "Erro ao adicionar dados. Por favor, tente novamente."
        
    return render_template('adicionar_dados_pessoais.html', id_funcionario=id_funcionario)

@app.route('/adicionar_telefones/<int:id_dados_pessoais>', methods=['GET', 'POST'])
def adicionar_telefones(id_dados_pessoais):
    if request.method == 'POST':
        num_telefones = len(request.form)
        telefones = [request.form[f'telefone{i}'] for i in range(num_telefones)]

        for telefone in telefones:
            print(telefone)
            id_telefone = programa.adicionar_telefone(telefone, id_dados_pessoais)
            if id_telefone is None:
                return "Erro ao adicionar telefone. Por favor, tente novamente."

        return redirect(f'/adicionar_enderecos/{id_dados_pessoais}')
    return render_template('adicionar_telefones.html', id_dados_pessoais=id_dados_pessoais, num_telefones=1)

@app.route('/adicionar_enderecos/<int:id_dados_pessoais>', methods=['GET', 'POST'])
def adicionar_enderecos(id_dados_pessoais):
    if request.method == 'POST':
        valores_endereco = (
            request.form['lagradouro'],
            request.form['cep'],
            request.form['complemento'],
            request.form['numero'],
            request.form['bairro'],
            id_dados_pessoais
        )

        id_endereco = programa.adicionar_endereco(valores_endereco)
        if id_endereco is not None:
            programa.conn.commit()
            return redirect('/')
        else:
            return "Erro ao adicionar endereço. Por favor, tente novamente."

    return render_template('adicionar_enderecos.html', id_dados_pessoais=id_dados_pessoais)

@app.route('/consultar_funcionarios', methods=['GET', 'POST'])
def consultar_funcionarios():
    if request.method == 'POST':
        id_funcionario = request.form.get('id_funcionario')
        funcionario = programa.consultar_funcionario(id_funcionario)
        if funcionario is not None:
            return render_template('mostrar_funcionario.html', funcionario=funcionario)
        else:
            return "Funcionário não encontrado."
    return render_template('consultar_funcionarios.html')

@app.route('/excluir_funcionario', methods=['GET', 'POST'])
def excluir_funcionarios():
    if request.method == 'POST':
        id_funcionario = request.form.get('id_funcionario')
        funcionario = programa.excluir_funcionario(id_funcionario)
        if funcionario:
            return redirect('/')
        else:
            return "Funcionário não encontrado."
    return render_template('excluir_funcionario.html')

@app.route('/alterar_dados', methods=['GET', 'POST'])
def alterar_dados():
    if request.method == 'POST':
        id_funcionario = request.form.get('id_funcionario')
        table = request.form.get('table_choice')
        
        if id_funcionario is not None:
            if table is not None:
                if table == 'dados_pessoais':
                    return redirect(f'/alterar_dados_dados_pessoais/{id_funcionario}')
                elif table == 'telefone':
                    id_dados_pessoais = programa.obter_id_dados_pessoais(id_funcionario)
                    return redirect(f"/alterar_dados_telefone/{id_dados_pessoais}")
                elif table == 'endereco':
                    id_dados_pessoais = programa.obter_id_dados_pessoais(id_funcionario)
                    return redirect(f"/alterar_dados_endereco/{id_dados_pessoais}")
                else:
                    return "Tabela inválida."
        else:
            return "Funcionário não encontrado."
    return render_template('alterar_dados.html')

@app.route('/alterar_dados_dados_pessoais/<int:id_funcionario>', methods=['GET', 'POST'])
def alterar_dados_dados_pessoais(id_funcionario):
    if request.method == 'POST':
        valores = (
            request.form['cpf'],
            request.form['genero'],
            request.form['estado_civil'],
            request.form['data_de_nascimento'],
            request.form['nome_completo'],
            request.form['email'],
        )

        sucesso = programa.atualizar_dados('dados_pessoais', id_funcionario, valores)

        if sucesso:
            return redirect('/')

        else:
            return "Erro ao atualizar dados. Por favor, tente novamente."

    return render_template('alterar_dados_dados_pessoais.html', id_funcionario=id_funcionario)


@app.route('/alterar_dados_telefone/<int:id_dados_pessoais>', methods=['GET', 'POST'])
def alterar_dados_telefone(id_dados_pessoais):
    num = programa.contar_itens_por_id('telefone', 'dados_pessoais_id', id_dados_pessoais)
    tel_id = programa.obter_ids_telefones(id_dados_pessoais)
    count = 0
    if request.method == 'POST':
        
        
        num_telefones = len(request.form)
        telefones = [request.form[f'telefone{i}'] for i in range(num_telefones)]

        for telefone in telefones:
            print(telefone)
            print(tel_id)
            id_telefone = programa.atualizar_dados('telefone',tel_id[count], telefone)
            count = count + 1
            if id_telefone is None:
                return "Erro ao adicionar telefone. Por favor, tente novamente."

        return redirect(f'/')

    return render_template('alterar_dados_telefone.html', id_dados_pessoais=id_dados_pessoais, num_telefones=num)

@app.route('/alterar_dados_endereco/<int:id_dados_pessoais>', methods=['GET', 'POST'])
def alterar_dados_endereco(id_dados_pessoais):
    if request.method == 'POST':
        valores = (
            request.form['lagradouro'],
            request.form['cep'],
            request.form['complemento'],
            request.form['numero'],
            request.form['bairro'],
        )

        id_endereco = programa.atualizar_dados('endereco', id_dados_pessoais, valores)
        if id_endereco is not None:
            return redirect('/')
        else:
            return "Erro ao adicionar endereço. Por favor, tente novamente."

    return render_template('alterar_dados_edereco.html', id_dados_pessoais=id_dados_pessoais)


if __name__ == '__main__':
    app.run(debug=True)
