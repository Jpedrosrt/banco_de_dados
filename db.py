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

    def inserir_linha(self, tabela, valores):
        cursor = self.conn.cursor()
        try:
            placeholders = ', '.join(['%s'] * len(valores))

            print(valores)
            insert_sql = f"INSERT INTO RH.{tabela} (cpf, genero, estado_civil, data_de_nascimento, nome_completo, email, funcionarios_id, dependentes_id) VALUES ({placeholders});"

            cursor.execute(insert_sql, tuple(valores))  # Convertendo de volta para uma tupla
            self.conn.commit()
            print(f"Linha inserida com sucesso na tabela RH.{tabela}.")
        except psycopg2.Error as e:
            self.conn.rollback()  # Tente fazer um rollback explicitamente
            print(f"Erro ao inserir linha na tabela RH.{tabela}: {e}")
        finally:
            cursor.close()


    def consultar_tabela(self, tabela):
        cursor = self.conn.cursor()
        try:
            consulta_sql = f"SELECT * FROM RH.{tabela};"
            cursor.execute(consulta_sql)
            resultados = cursor.fetchall()
            if resultados:
                print(f"Resultados da tabela RH.{tabela}:")
                for row in resultados:
                    print(row)
            else:
                print(f"A tabela RH.{tabela} está vazia.")
        except psycopg2.Error as e:
            print(f"Erro ao consultar a tabela RH.{tabela}: {e}")
        finally:
            cursor.close()

    """def realizar_transacao(self, tabela):
        cursor = self.conn.cursor()
        try:
            # Inicie a transação
            self.conn.begin()

            # Operação de consulta
            consulta_sql = f"SELECT * FROM RH.{tabela};"
            cursor.execute(consulta_sql)
            resultados = cursor.fetchall()

            # Operação de inserção/atualização
            insert_sql = f"INSERT INTO RH.{tabela} (coluna) VALUES (%s);"
            cursor.execute(insert_sql, ('valor',))

            # Finalize a transação
            self.conn.commit()

            print("Transação bem-sucedida.")

        except psycopg2.Error as e:
            # Em caso de erro, faça rollback na transação
            self.conn.rollback()
            print(f"Erro durante a transação: {e}")
        finally:
            cursor.close()"""


    def fechar_conexao(self):
        self.conn.close()
