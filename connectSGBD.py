import psycopg2

print("Conexão bem Sucedida")


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
            print(placeholders)
            insert_sql = f"INSERT INTO {tabela} VALUES ({placeholders});"
            cursor.execute(insert_sql, valores)
            self.conn.commit()
            print(f"Linha inserida com sucesso na tabela {tabela}.")
        except psycopg2.Error as e:
            print(f"Erro ao inserir linha na tabela {tabela}: {e}")
        finally:
            cursor.close()

    def consultar_tabela(self, tabela):
        cursor = self.conn.cursor()
        try:
            consulta_sql = f"SELECT * FROM {tabela};"
            cursor.execute(consulta_sql)
            resultados = cursor.fetchall()
            if resultados:
                print(f"Resultados da tabela {tabela}:")
                for row in resultados:
                    print(row)
            else:
                print(f"A tabela {tabela} está vazia.")
        except psycopg2.Error as e:
            print(f"Erro ao consultar a tabela {tabela}: {e}")
        finally:
            cursor.close()

    def fechar_conexao(self):
        self.conn.close()


programa = MeuProgramaPG(
    host="localhost",
    dbname="postgres",
    user="postgres",
    password="postgres",
    port="5432"
)

programa.inserir_linha("RH.funcionarios", ('',))

programa.consultar_tabela("RH.funcionarios")
"""
id_funcionario = 3

dados_pessoais = (
    None,  # Deixe o banco de dados gerar um ID automaticamente
    '12345678901',  # CPF do funcionário
    'M',  # Gênero do funcionário
    'Casado',  # Estado civil do funcionário
    '1985-07-10',  # Data de nascimento do funcionário
    'João da Silva',  # Nome completo do funcionário
    'joao.silva@email.com',  # Email do funcionário
    id_funcionario  # ID do funcionário da tabela 'funcionarios'
)

programa.inserir_linha("RH.dados_pessoais", dados_pessoais)

programa.consultar_tabela("RH.funcionarios")
"""
programa.fechar_conexao()
