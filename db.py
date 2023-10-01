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
    
    def adicionar_dependente(self):
        cursor = self.conn.cursor()
        try:
            cursor.execute("INSERT INTO RH.dependentes DEFAULT VALUES RETURNING id;")
            id_dependente = cursor.fetchone()[0]
            return id_dependente
        except psycopg2.Error as e:
            print(f"Erro ao adicionar dependente: {e}")
            self.conn.rollback()
            return None
        finally:
            cursor.close()
    
    def associar_dependente_funcionario(self, id_funcionario, id_dependente):
        cursor = self.conn.cursor()
        try:
            cursor.execute("INSERT INTO RH.funcionarios_dependentes (funcionarios_id, dependentes_id) VALUES (%s, %s);", (id_funcionario, id_dependente))
            self.conn.commit()
            return True
        except psycopg2.Error as e:
            print(f"Erro ao associar dependente ao funcionário: {e}")
            self.conn.rollback()
            return False
        finally:
            cursor.close()

    def adicionar_dados(self, tabela, valores):
        cursor = self.conn.cursor()
        try:
            placeholders = ', '.join(['%s'] * len(valores))
            
            insert_sql = f"INSERT INTO RH.{tabela} (cpf, genero, estado_civil, data_de_nascimento, nome_completo, email, funcionarios_id, dependentes_id) VALUES ({placeholders}) RETURNING id;"

            cursor.execute(insert_sql, tuple(valores))
            id_dados_pessoais = cursor.fetchone()[0]
            print(id_dados_pessoais)

            return id_dados_pessoais
        except psycopg2.Error as e:
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

            insert_sql = f"INSERT INTO RH.endereco (lagradouro, cep, complemento, numero, bairro, dados_pessoais_id) VALUES ({placeholders}) RETURNING id;"
            cursor.execute(insert_sql, tuple(valores))
            id_endereco = cursor.fetchone()[0]

            return id_endereco
        except psycopg2.Error as e:
            self.conn.rollback()
            print(f"Erro ao inserir linha na tabela RH.endereco: {e}")
            return None
        finally:
            cursor.close()


    def consultar_funcionario(self, id_funcionario):
        cursor = self.conn.cursor()
        try:
            cursor.execute("SELECT * FROM RH.funcionarios WHERE id = %s;", (id_funcionario,))
            funcionario = cursor.fetchone()

            if funcionario:
                cursor.execute("SELECT * FROM RH.dados_pessoais WHERE funcionarios_id = %s;", (id_funcionario,))
                dados_pessoais = cursor.fetchone()

                cursor.execute("SELECT * FROM RH.telefone WHERE dados_pessoais_id = %s;", (dados_pessoais[0],))
                telefones = cursor.fetchall()

                cursor.execute("SELECT * FROM RH.endereco WHERE dados_pessoais_id = %s;", (dados_pessoais[0],))
                endereco = cursor.fetchone()

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

    def excluir_funcionario(self, id_funcionario):
        cursor = self.conn.cursor()
        try:
            cursor.execute("DELETE FROM RH.funcionarios WHERE id = %s;", (id_funcionario,))
            self.conn.commit()
            return True
        except psycopg2.Error as e:
            print(f"Erro ao excluir funcionário: {e}")
            self.conn.rollback()
            return False
        finally:
            cursor.close()
        
    def atualizar_dados(self, tabela, id, valores):
        cursor = self.conn.cursor()
        try:
            if tabela == 'dados_pessoais':
                query = f"UPDATE RH.{tabela} SET cpf = '{valores[0]}', genero = '{valores[1]}', estado_civil = '{valores[2]}', data_de_nascimento = '{valores[3]}', nome_completo = '{valores[4]}', email = '{valores[5]}' WHERE funcionarios_id = {id}"
                cursor.execute(query)
            elif tabela == 'telefone':
                query = f"UPDATE RH.telefone SET telefone = '{valores}' WHERE id = {id}"
                cursor.execute(query)

            elif tabela == 'endereco':
                print(valores)
                query = f"UPDATE RH.{tabela} SET lagradouro = '{valores[0]}', cep = '{valores[1]}', complemento = '{valores[2]}', numero = '{valores[3]}', bairro = '{valores[4]}' WHERE dados_pessoais_id = {id}"
                cursor.execute(query)

            self.conn.commit()

            return True
        except Exception as e:
            print(f"Erro ao atualizar dados: {e}")
            self.conn.rollback()
            return False
        finally:

            cursor.close()

    def obter_id_funcionario(self, id_dados_pessoais):
        cursor = self.conn.cursor()
        query = "SELECT funcionarios_id FROM RH.dados_pessoais WHERE id = %s"
        cursor.execute(query, (id_dados_pessoais,))
        id_funcionario = cursor.fetchone()

        if id_funcionario:
            return id_funcionario[0]

        return None
    
    def obter_id_dados_pessoais(self, id_funcionario):
        cursor = self.conn.cursor()
        query = "SELECT id FROM RH.dados_pessoais WHERE funcionarios_id = %s"
        cursor.execute(query, (id_funcionario,))
        id_dados_pessoais = cursor.fetchone()

        if id_dados_pessoais:
            return id_dados_pessoais[0]

        return None

    def contar_itens_por_id(self, tabela, typeid, id):
        cursor = self.conn.cursor()

        cursor.execute(f"SELECT COUNT(*) FROM RH.{tabela} WHERE {typeid} = {id}")
        quantidade = cursor.fetchone()[0]

        cursor.close()

        return quantidade
    
    def obter_ids_telefones(self, dados_pessoais_id):
        cursor = self.conn.cursor()
        try:
            query = "SELECT id FROM RH.telefone WHERE dados_pessoais_id = %s"
            cursor.execute(query, (dados_pessoais_id,))
            ids_telefones = [row[0] for row in cursor.fetchall()]
            return ids_telefones

        except Exception as e:
            print(f"Erro ao obter IDs dos telefones: {e}")
            return None

        finally:
            cursor.close()
    
    def consultar_telefones_like(self, id_funcionario, ddd):
        cursor = self.conn.cursor()

        try:
            cursor.execute("SELECT id FROM RH.dados_pessoais WHERE funcionarios_id = %s;", (id_funcionario,))
            id_dados_pessoais = cursor.fetchone()[0]
            
            cursor.execute("SELECT telefone FROM RH.telefone WHERE dados_pessoais_id = %s AND telefone LIKE %s;", (id_dados_pessoais, f'{ddd}%'))
            telefones = cursor.fetchall()

            return telefones

        except psycopg2.Error as e:
            print(f"Erro ao consultar telefones com LIKE: {e}")
            return None

        finally:
            cursor.close()




    def fechar_conexao(self):
        self.conn.close()
