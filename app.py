from flask import Flask, render_template, request, redirect

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

@app.route('/adicionar_dados_dependente/<int:id_dependente>', methods=['GET', 'POST'])
def adicionar_dados_dependente(id_dependente):

    if request.method == 'POST':
        valores = (
            request.form['cpf'],
            request.form['genero'],
            request.form['estado_civil'],
            request.form['data_de_nascimento'],
            request.form['nome_completo'],
            request.form['email'],
            None,  
            id_dependente 
        )

        id_dados_pessoais = programa.adicionar_dados('dados_pessoais', valores)
        if id_dados_pessoais is not None:
            print(id_dados_pessoais)
            return redirect(f'/adicionar_telefones/{id_dados_pessoais}')
        else:
            return "Erro ao adicionar dados. Por favor, tente novamente."
        
    return render_template('adicionar_dados_dependente.html', id_dependente=id_dependente)


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
        id_funcionario = programa.obter_id_funcionario(id_dados_pessoais)
        if id_endereco is not None and id_funcionario is not None:
            return redirect(f'/pergunta_dependente/{id_funcionario}')
        else:
            programa.conn.commit()
            return redirect('/')

    return render_template('adicionar_enderecos.html', id_dados_pessoais=id_dados_pessoais)

@app.route('/pergunta_dependente/<int:id_funcionario>')
def pergunta_dependente(id_funcionario):
    return render_template('pergunta_dependente.html', id_funcionario=id_funcionario)

@app.route('/processar_dependente/<int:id_funcionario>', methods=['POST'])
def processar_dependente(id_funcionario):
    tem_dependente = request.form.get('tem_dependente')
    
    if tem_dependente == 'sim':
        return redirect(f'/adicionar_dependente/{id_funcionario}')
    elif tem_dependente == 'nao':
        programa.conn.commit()
        return redirect('/')
    else:
        return "Resposta inválida."

@app.route('/adicionar_dependente/<int:id_funcionario>')
def adicionar_dependente(id_funcionario):
    id_dependente = programa.adicionar_dependente()
    print(id_dependente)
    if id_dependente is not None:
        sucesso = programa.associar_dependente_funcionario(id_funcionario, id_dependente)
        if sucesso:
            programa.conn.commit()
            return redirect(f'/adicionar_dados_dependente/{id_dependente}')
        else:
            return "Erro ao associar dependente ao funcionário. Por favor, tente novamente."
    else:
        return "Erro ao adicionar dependente. Por favor, tente novamente."




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

@app.route('/consultas')
def consultas():
    return render_template('consultas.html')

@app.route('/executar_consulta', methods=['POST'])
def executar_consulta():
    consulta_selecionada = request.form.get('consulta')
    
    if consulta_selecionada == 'consulta_like':
        return redirect('/consulta_like')
    elif consulta_selecionada == 'consulta_conjuntos':
        return redirect('/consulta_conjuntos')
    elif consulta_selecionada == 'consulta_join':
        return redirect('/consulta_join')
    elif consulta_selecionada == 'consulta_multi_join':
        return redirect('/consulta_multi_join')
    elif consulta_selecionada == 'consulta_outer_join':
        return redirect('/consulta_outer_join')
    elif consulta_selecionada == 'consulta_agregacao':
        return redirect('/consulta_agregacao')
    elif consulta_selecionada == 'consulta_group_by':
        return redirect('/consulta_group_by')
    elif consulta_selecionada == 'consulta_group_by_having':
        return redirect('/consulta_group_by_having')
    elif consulta_selecionada == 'consulta_in':
        return redirect('/consulta_in')
    elif consulta_selecionada == 'consulta_exists':
        return redirect('/consulta_exists')
    elif consulta_selecionada == 'consulta_some':
        return redirect('/consulta_some')
    elif consulta_selecionada == 'consulta_all':
        return redirect('/consulta_all')
    elif consulta_selecionada == 'consulta_aninhada':
        return redirect('/consulta_aninhada')

    return "Consulta não encontrada"

@app.route('/consulta_like', methods=['POST', 'GET'])
def consulta_like():
    if request.method == 'POST':
        id_funcionario = request.form['id_funcionario']
        ddd = request.form['ddd']

        telefones = programa.consultar_telefones_like(id_funcionario, ddd)

        if telefones is not None:
            return render_template('resultados_consulta_like.html', telefones=telefones)
        else:
            return "Erro ao consultar telefones com LIKE. Por favor, tente novamente."
    return render_template('consulta_like.html')


if __name__ == '__main__':
    app.run(debug=True)
