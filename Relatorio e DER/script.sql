-- Schema RH
CREATE SCHEMA IF NOT EXISTS RH;

-- Table RH.funcionarios
CREATE TABLE IF NOT EXISTS RH.funcionarios (
  id SERIAL PRIMARY KEY
);

-- Table RH.cargo
CREATE TABLE IF NOT EXISTS RH.cargo (
  id SERIAL PRIMARY KEY,
  nome_do_cargo VARCHAR(45) NOT NULL
);

-- Table RH.beneficio
CREATE TABLE IF NOT EXISTS RH.beneficio (
  id SERIAL PRIMARY KEY,
  descricao VARCHAR(45) NOT NULL,
  valor_bonificacao DECIMAL(2) NOT NULL
);

-- Table RH.plano_de_saude
CREATE TABLE IF NOT EXISTS RH.plano_de_saude (
  tipo_de_plano VARCHAR(45),
  beneficio_id INT NOT NULL,
  PRIMARY KEY (beneficio_id),
  CONSTRAINT fk_plano_de_saude_beneficio1
    FOREIGN KEY (beneficio_id)
    REFERENCES RH.beneficio (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

-- Table RH.ferias
CREATE TABLE IF NOT EXISTS RH.ferias (
  data_inicio DATE,
  data_fim DATE,
  beneficio_id INT NOT NULL,
  PRIMARY KEY (beneficio_id),
  CONSTRAINT fk_ferias_beneficio1
    FOREIGN KEY (beneficio_id)
    REFERENCES RH.beneficio (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

-- Table RH.funcionarios_cargo
CREATE TABLE IF NOT EXISTS RH.funcionarios_cargo (
  funcionarios_id INT NOT NULL,
  cargo_id INT NOT NULL,
  PRIMARY KEY (funcionarios_id, cargo_id),
  CONSTRAINT fk_funcionarios_cargo_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_funcionarios_cargo_cargo1
    FOREIGN KEY (cargo_id)
    REFERENCES RH.cargo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.cargo_beneficio
CREATE TABLE IF NOT EXISTS RH.cargo_beneficio (
  cargo_id INT,
  beneficio_id INT NOT NULL,
  PRIMARY KEY (cargo_id, beneficio_id),
  CONSTRAINT fk_cargo_beneficio_cargo1
    FOREIGN KEY (cargo_id)
    REFERENCES RH.cargo (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_cargo_beneficio_beneficio1
    FOREIGN KEY (beneficio_id)
    REFERENCES RH.beneficio (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.departamento
CREATE TABLE IF NOT EXISTS RH.departamento (
  id SERIAL PRIMARY KEY,
  nome_do_departamento VARCHAR(45) NOT NULL,
  setor VARCHAR(45) NOT NULL
);

-- Table RH.funcionarios_departamento
CREATE TABLE IF NOT EXISTS RH.funcionarios_departamento (
  funcionarios_id INT NOT NULL,
  departamento_id INT NOT NULL,
  chefe BOOLEAN NOT NULL,
  PRIMARY KEY (funcionarios_id, departamento_id, chefe),
  CONSTRAINT fk_funcionarios_departamento_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_funcionarios_departamento_departamento1
    FOREIGN KEY (departamento_id)
    REFERENCES RH.departamento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.cargo_departamento
CREATE TABLE IF NOT EXISTS RH.cargo_departamento (
  cargo_id INT NOT NULL,
  departamento_id INT NOT NULL,
  PRIMARY KEY (cargo_id, departamento_id),
  CONSTRAINT fk_cargo_departamento_cargo1
    FOREIGN KEY (cargo_id)
    REFERENCES RH.cargo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_cargo_departamento_departamento1
    FOREIGN KEY (departamento_id)
    REFERENCES RH.departamento (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.historico_de_cargo
CREATE TABLE IF NOT EXISTS RH.historico_de_cargo (
  id SERIAL PRIMARY KEY,
  data_inicio DATE NOT NULL,
  data_fim DATE NOT NULL
);

-- Table RH.historico_de_cargo_funcionarios
CREATE TABLE IF NOT EXISTS RH.historico_de_cargo_funcionarios (
  historico_de_cargo_id INT NOT NULL,
  funcionarios_id INT NOT NULL,
  PRIMARY KEY (historico_de_cargo_id, funcionarios_id),
  CONSTRAINT fk_historico_de_cargo_funcionarios_historico_de_cargo1
    FOREIGN KEY (historico_de_cargo_id)
    REFERENCES RH.historico_de_cargo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_historico_de_cargo_funcionarios_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

-- Table RH.historico_de_cargo_cargo
CREATE TABLE IF NOT EXISTS RH.historico_de_cargo_cargo (
  historico_de_cargo_id INT NOT NULL,
  cargo_id INT NOT NULL,
  PRIMARY KEY (historico_de_cargo_id, cargo_id),
  CONSTRAINT fk_historico_de_cargo_cargo_historico_de_cargo1
    FOREIGN KEY (historico_de_cargo_id)
    REFERENCES RH.historico_de_cargo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_historico_de_cargo_cargo_cargo1
    FOREIGN KEY (cargo_id)
    REFERENCES RH.cargo (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.controle_de_acesso
CREATE TABLE IF NOT EXISTS RH.controle_de_acesso (
  id SERIAL PRIMARY KEY,
  nivel_de_acesso INT NOT NULL,
  funcionarios_id INT NOT NULL,
  UNIQUE (id),
  CONSTRAINT fk_controle_de_acesso_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.acesso
CREATE TABLE IF NOT EXISTS RH.acesso (
  idacesso SERIAL PRIMARY KEY,
  data DATE NOT NULL,
  hora TIME NOT NULL,
  descricao VARCHAR(45) NOT NULL,
  controle_de_acesso_id INT NOT NULL,
  UNIQUE (idacesso),
  CONSTRAINT fk_acesso_controle_de_acesso1
    FOREIGN KEY (controle_de_acesso_id)
    REFERENCES RH.controle_de_acesso (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.historico_de_pagamentos
CREATE TABLE IF NOT EXISTS RH.historico_de_pagamentos (
  id SERIAL PRIMARY KEY,
  descontos DECIMAL(2) NOT NULL,
  data_do_pagamento DATE NOT NULL,
  valor_bruto DECIMAL(2) NOT NULL,
  valor_liquido DECIMAL(2) GENERATED ALWAYS AS (valor_bruto - descontos) STORED,
  funcionarios_id INT NOT NULL,
  UNIQUE (id),
  CONSTRAINT fk_historico_de_pagamentos_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

-- Table RH.dependentes
CREATE TABLE IF NOT EXISTS RH.dependentes (
  id SERIAL PRIMARY KEY,
  UNIQUE (id)
);

CREATE FUNCTION calcula_idade(data_nascimento DATE) RETURNS INT AS $$
BEGIN
  RETURN EXTRACT(YEAR FROM age(data_nascimento));
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Table RH.dados_pessoais
CREATE TABLE IF NOT EXISTS RH.dados_pessoais (
  id SERIAL PRIMARY KEY,
  cpf BIGINT NOT NULL,
  genero VARCHAR(45) NOT NULL,
  estado_civil VARCHAR(45) NOT NULL,
  data_de_nascimento DATE NOT NULL,
  nome_completo VARCHAR(100) NOT NULL,
  idade INT GENERATED ALWAYS AS (calcula_idade(data_de_nascimento)) STORED,
  email VARCHAR(45) NOT NULL,
  funcionarios_id INT NOT NULL,
  dependentes_id INT NOT NULL,
  UNIQUE (id),
  UNIQUE (cpf),
  CONSTRAINT fk_dados_pessoais_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_dados_pessoais_dependentes1
    FOREIGN KEY (dependentes_id)
    REFERENCES RH.dependentes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.telefone
CREATE TABLE IF NOT EXISTS RH.telefone (
  id SERIAL PRIMARY KEY,
  telefone VARCHAR(20) NOT NULL,
  dados_pessoais_id INT NOT NULL,
  UNIQUE (id),
  UNIQUE (telefone),
  CONSTRAINT fk_telefone_dados_pessoais1
    FOREIGN KEY (dados_pessoais_id)
    REFERENCES RH.dados_pessoais (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.endereco
CREATE TABLE IF NOT EXISTS RH.endereco (
  idendereco SERIAL PRIMARY KEY,
  lagradouro VARCHAR(50) NOT NULL,
  cep VARCHAR(15) NOT NULL,
  complemento VARCHAR(45) NOT NULL,
  numero INT NOT NULL,
  bairro VARCHAR(45) NOT NULL,
  dados_pessoais_id INT NOT NULL,
  UNIQUE (idendereco),
  CONSTRAINT fk_endereco_dados_pessoais1
    FOREIGN KEY (dados_pessoais_id)
    REFERENCES RH.dados_pessoais (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Table RH.funcionarios_dependentes
CREATE TABLE IF NOT EXISTS RH.funcionarios_dependentes (
  funcionarios_id INT,
  dependentes_id INT NOT NULL,
  PRIMARY KEY (funcionarios_id, dependentes_id),
  CONSTRAINT fk_funcionarios_dependentes_funcionarios1
    FOREIGN KEY (funcionarios_id)
    REFERENCES RH.funcionarios (id)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT fk_funcionarios_dependentes_dependentes1
    FOREIGN KEY (dependentes_id)
    REFERENCES RH.dependentes (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
