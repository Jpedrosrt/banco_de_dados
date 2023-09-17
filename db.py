import psycopg2

class MeuProgramaPG:
    def __init__(self, dbname, user, password, host, port):
        self.conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )

    def adicionar_funcionario(self):
        cursor = self.conn.cursor()
        try:
            cursor.execute("INSERT INTO RH.funcionarios DEFAULT VALUES RETURNING id;")
            id_funcionario = cursor.fetchone()[0]
            return id_funcionario
        except psycopg2.Error as e:
            print(f"Erro ao adicionar funcionário: {e}")
            self.conn.rollback()
            return None
        finally:
            cursor.close()

    def adicionar_dados(self, tabela, valores):
        cursor = self.conn.cursor()
        try:
            placeholders = ', '.join(['%s'] * len(valores))

            # Operação de inserção
            insert_sql = f"INSERT INTO RH.{tabela} (cpf, genero, estado_civil, data_de_nascimento, nome_completo, email, funcionarios_id, dependentes_id) VALUES ({placeholders}) RETURNING id;"

            cursor.execute(insert_sql, tuple(valores))
            id_dados_pessoais = cursor.fetchone()[0]
            print(id_dados_pessoais)

            return id_dados_pessoais
        except psycopg2.Error as e:
            # Em caso de erro, desfazer a transação
            self.conn.rollback()
            print(f"Erro ao inserir linha na tabela RH.{tabela}: {e}")
            return None
        finally:
            cursor.close()

    def adicionar_telefone(self, telefone, dados_pessoais_id):
        cursor = self.conn.cursor()
        try:
            cursor.execute("INSERT INTO RH.telefone (telefone, dados_pessoais_id) VALUES (%s, %s) RETURNING id;", (telefone, dados_pessoais_id))
            id_telefone = cursor.fetchone()[0]
            return id_telefone
        except psycopg2.Error as e:
            self.conn.rollback()
            print(f"Erro ao adicionar telefone: {e}")
            return None
        finally:
            cursor.close()
    
    def adicionar_endereco(self, valores):
        cursor = self.conn.cursor()
        try:
            placeholders = ', '.join(['%s'] * len(valores))

            # Operação de inserção
            insert_sql = f"INSERT INTO RH.endereco (lagradouro, cep, complemento, numero, bairro, dados_pessoais_id) VALUES ({placeholders}) RETURNING id;"
            cursor.execute(insert_sql, tuple(valores))
            id_endereco = cursor.fetchone()[0]

            return id_endereco
        except psycopg2.Error as e:
            # Em caso de erro, desfazer a transação
            self.conn.rollback()
            print(f"Erro ao inserir linha na tabela RH.endereco: {e}")
            return None
        finally:
            cursor.close()


    def consultar_funcionario(self, id_funcionario):
        cursor = self.conn.cursor()
        try:
            # Consulta para obter dados pessoais do funcionário
            cursor.execute("SELECT * FROM RH.funcionarios WHERE id = %s;", (id_funcionario,))
            funcionario = cursor.fetchone()

            if funcionario:
                # Consulta para obter dados pessoais
                cursor.execute("SELECT * FROM RH.dados_pessoais WHERE funcionarios_id = %s;", (id_funcionario,))
                dados_pessoais = cursor.fetchone()

                # Consulta para obter telefones
                cursor.execute("SELECT * FROM RH.telefone WHERE dados_pessoais_id = %s;", (dados_pessoais[0],))
                telefones = cursor.fetchall()

                # Consulta para obter endereço
                cursor.execute("SELECT * FROM RH.endereco WHERE dados_pessoais_id = %s;", (dados_pessoais[0],))
                endereco = cursor.fetchone()

                # Adicionando telefones ao resultado
                funcionario = list(funcionario) + list(dados_pessoais) + list(endereco) + telefones
                print(funcionario)
                return funcionario
            else:
                return None
        except psycopg2.Error as e:
            print(f"Erro ao consultar funcionário: {e}")
            return None
        finally:
            cursor.close()

    def fechar_conexao(self):
        self.conn.close()
