﻿--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 15.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: rh; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA rh;


ALTER SCHEMA rh OWNER TO postgres;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: calcula_idade(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calcula_idade(data_nascimento date) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN EXTRACT(YEAR FROM age(data_nascimento));
END;
$$;


ALTER FUNCTION public.calcula_idade(data_nascimento date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acesso; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.acesso (
    idacesso integer NOT NULL,
    data date NOT NULL,
    hora time without time zone NOT NULL,
    descricao character varying(45) NOT NULL,
    controle_de_acesso_id integer NOT NULL
);


ALTER TABLE rh.acesso OWNER TO postgres;

--
-- Name: acesso_idacesso_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.acesso_idacesso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.acesso_idacesso_seq OWNER TO postgres;

--
-- Name: acesso_idacesso_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.acesso_idacesso_seq OWNED BY rh.acesso.idacesso;


--
-- Name: beneficio; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.beneficio (
    id integer NOT NULL,
    descricao character varying(45) NOT NULL,
    valor_bonificacao numeric(2,0) NOT NULL
);


ALTER TABLE rh.beneficio OWNER TO postgres;

--
-- Name: beneficio_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.beneficio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.beneficio_id_seq OWNER TO postgres;

--
-- Name: beneficio_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.beneficio_id_seq OWNED BY rh.beneficio.id;


--
-- Name: cargo; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.cargo (
    id integer NOT NULL,
    nome_do_cargo character varying(45) NOT NULL
);


ALTER TABLE rh.cargo OWNER TO postgres;

--
-- Name: cargo_beneficio; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.cargo_beneficio (
    cargo_id integer NOT NULL,
    beneficio_id integer NOT NULL
);


ALTER TABLE rh.cargo_beneficio OWNER TO postgres;

--
-- Name: cargo_departamento; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.cargo_departamento (
    cargo_id integer NOT NULL,
    departamento_id integer NOT NULL
);


ALTER TABLE rh.cargo_departamento OWNER TO postgres;

--
-- Name: cargo_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.cargo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.cargo_id_seq OWNER TO postgres;

--
-- Name: cargo_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.cargo_id_seq OWNED BY rh.cargo.id;


--
-- Name: controle_de_acesso; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.controle_de_acesso (
    id integer NOT NULL,
    nivel_de_acesso integer NOT NULL,
    funcionarios_id integer NOT NULL
);


ALTER TABLE rh.controle_de_acesso OWNER TO postgres;

--
-- Name: controle_de_acesso_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.controle_de_acesso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.controle_de_acesso_id_seq OWNER TO postgres;

--
-- Name: controle_de_acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.controle_de_acesso_id_seq OWNED BY rh.controle_de_acesso.id;


--
-- Name: dados_pessoais; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.dados_pessoais (
    id integer NOT NULL,
    cpf character varying(11) NOT NULL,
    genero character varying(45) NOT NULL,
    estado_civil character varying(45) NOT NULL,
    data_de_nascimento date NOT NULL,
    nome_completo character varying(100) NOT NULL,
    idade integer GENERATED ALWAYS AS (public.calcula_idade(data_de_nascimento)) STORED,
    email character varying(45) NOT NULL,
    funcionarios_id integer,
    dependentes_id integer
);


ALTER TABLE rh.dados_pessoais OWNER TO postgres;

--
-- Name: dados_pessoais_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.dados_pessoais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.dados_pessoais_id_seq OWNER TO postgres;

--
-- Name: dados_pessoais_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.dados_pessoais_id_seq OWNED BY rh.dados_pessoais.id;


--
-- Name: departamento; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.departamento (
    id integer NOT NULL,
    nome_do_departamento character varying(45) NOT NULL,
    setor character varying(45) NOT NULL
);


ALTER TABLE rh.departamento OWNER TO postgres;

--
-- Name: departamento_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.departamento_id_seq OWNER TO postgres;

--
-- Name: departamento_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.departamento_id_seq OWNED BY rh.departamento.id;


--
-- Name: dependentes; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.dependentes (
    id integer NOT NULL
);


ALTER TABLE rh.dependentes OWNER TO postgres;

--
-- Name: dependentes_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.dependentes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.dependentes_id_seq OWNER TO postgres;

--
-- Name: dependentes_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.dependentes_id_seq OWNED BY rh.dependentes.id;


--
-- Name: endereco; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.endereco (
    id integer NOT NULL,
    lagradouro character varying(50) NOT NULL,
    cep character varying(15) NOT NULL,
    complemento character varying(45) NOT NULL,
    numero integer NOT NULL,
    bairro character varying(45) NOT NULL,
    dados_pessoais_id integer NOT NULL
);


ALTER TABLE rh.endereco OWNER TO postgres;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.endereco_idendereco_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.endereco_idendereco_seq OWNER TO postgres;

--
-- Name: endereco_idendereco_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.endereco_idendereco_seq OWNED BY rh.endereco.id;


--
-- Name: ferias; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.ferias (
    data_inicio date,
    data_fim date,
    beneficio_id integer NOT NULL
);


ALTER TABLE rh.ferias OWNER TO postgres;

--
-- Name: funcionarios; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.funcionarios (
    id integer NOT NULL
);


ALTER TABLE rh.funcionarios OWNER TO postgres;

--
-- Name: funcionarios_cargo; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.funcionarios_cargo (
    funcionarios_id integer NOT NULL,
    cargo_id integer NOT NULL
);


ALTER TABLE rh.funcionarios_cargo OWNER TO postgres;

--
-- Name: funcionarios_departamento; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.funcionarios_departamento (
    funcionarios_id integer NOT NULL,
    departamento_id integer NOT NULL,
    chefe boolean NOT NULL
);


ALTER TABLE rh.funcionarios_departamento OWNER TO postgres;

--
-- Name: funcionarios_dependentes; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.funcionarios_dependentes (
    funcionarios_id integer NOT NULL,
    dependentes_id integer NOT NULL
);


ALTER TABLE rh.funcionarios_dependentes OWNER TO postgres;

--
-- Name: funcionarios_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.funcionarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.funcionarios_id_seq OWNER TO postgres;

--
-- Name: funcionarios_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.funcionarios_id_seq OWNED BY rh.funcionarios.id;


--
-- Name: historico_de_cargo; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.historico_de_cargo (
    id integer NOT NULL,
    data_inicio date NOT NULL,
    data_fim date NOT NULL
);


ALTER TABLE rh.historico_de_cargo OWNER TO postgres;

--
-- Name: historico_de_cargo_cargo; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.historico_de_cargo_cargo (
    historico_de_cargo_id integer NOT NULL,
    cargo_id integer NOT NULL
);


ALTER TABLE rh.historico_de_cargo_cargo OWNER TO postgres;

--
-- Name: historico_de_cargo_funcionarios; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.historico_de_cargo_funcionarios (
    historico_de_cargo_id integer NOT NULL,
    funcionarios_id integer NOT NULL
);


ALTER TABLE rh.historico_de_cargo_funcionarios OWNER TO postgres;

--
-- Name: historico_de_cargo_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.historico_de_cargo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.historico_de_cargo_id_seq OWNER TO postgres;

--
-- Name: historico_de_cargo_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.historico_de_cargo_id_seq OWNED BY rh.historico_de_cargo.id;


--
-- Name: historico_de_pagamentos; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.historico_de_pagamentos (
    id integer NOT NULL,
    descontos numeric(2,0) NOT NULL,
    data_do_pagamento date NOT NULL,
    valor_bruto numeric(2,0) NOT NULL,
    valor_liquido numeric(2,0) GENERATED ALWAYS AS ((valor_bruto - descontos)) STORED,
    funcionarios_id integer NOT NULL
);


ALTER TABLE rh.historico_de_pagamentos OWNER TO postgres;

--
-- Name: historico_de_pagamentos_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.historico_de_pagamentos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.historico_de_pagamentos_id_seq OWNER TO postgres;

--
-- Name: historico_de_pagamentos_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.historico_de_pagamentos_id_seq OWNED BY rh.historico_de_pagamentos.id;


--
-- Name: plano_de_saude; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.plano_de_saude (
    tipo_de_plano character varying(45),
    beneficio_id integer NOT NULL
);


ALTER TABLE rh.plano_de_saude OWNER TO postgres;

--
-- Name: telefone; Type: TABLE; Schema: rh; Owner: postgres
--

CREATE TABLE rh.telefone (
    id integer NOT NULL,
    telefone character varying(20) NOT NULL,
    dados_pessoais_id integer NOT NULL
);


ALTER TABLE rh.telefone OWNER TO postgres;

--
-- Name: telefone_id_seq; Type: SEQUENCE; Schema: rh; Owner: postgres
--

CREATE SEQUENCE rh.telefone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rh.telefone_id_seq OWNER TO postgres;

--
-- Name: telefone_id_seq; Type: SEQUENCE OWNED BY; Schema: rh; Owner: postgres
--

ALTER SEQUENCE rh.telefone_id_seq OWNED BY rh.telefone.id;


--
-- Name: acesso idacesso; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.acesso ALTER COLUMN idacesso SET DEFAULT nextval('rh.acesso_idacesso_seq'::regclass);


--
-- Name: beneficio id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.beneficio ALTER COLUMN id SET DEFAULT nextval('rh.beneficio_id_seq'::regclass);


--
-- Name: cargo id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo ALTER COLUMN id SET DEFAULT nextval('rh.cargo_id_seq'::regclass);


--
-- Name: controle_de_acesso id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.controle_de_acesso ALTER COLUMN id SET DEFAULT nextval('rh.controle_de_acesso_id_seq'::regclass);


--
-- Name: dados_pessoais id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais ALTER COLUMN id SET DEFAULT nextval('rh.dados_pessoais_id_seq'::regclass);


--
-- Name: departamento id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.departamento ALTER COLUMN id SET DEFAULT nextval('rh.departamento_id_seq'::regclass);


--
-- Name: dependentes id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dependentes ALTER COLUMN id SET DEFAULT nextval('rh.dependentes_id_seq'::regclass);


--
-- Name: endereco id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.endereco ALTER COLUMN id SET DEFAULT nextval('rh.endereco_idendereco_seq'::regclass);


--
-- Name: funcionarios id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios ALTER COLUMN id SET DEFAULT nextval('rh.funcionarios_id_seq'::regclass);


--
-- Name: historico_de_cargo id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo ALTER COLUMN id SET DEFAULT nextval('rh.historico_de_cargo_id_seq'::regclass);


--
-- Name: historico_de_pagamentos id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_pagamentos ALTER COLUMN id SET DEFAULT nextval('rh.historico_de_pagamentos_id_seq'::regclass);


--
-- Name: telefone id; Type: DEFAULT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.telefone ALTER COLUMN id SET DEFAULT nextval('rh.telefone_id_seq'::regclass);


--
-- Name: acesso acesso_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.acesso
    ADD CONSTRAINT acesso_pkey PRIMARY KEY (idacesso);


--
-- Name: beneficio beneficio_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.beneficio
    ADD CONSTRAINT beneficio_pkey PRIMARY KEY (id);


--
-- Name: cargo_beneficio cargo_beneficio_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_beneficio
    ADD CONSTRAINT cargo_beneficio_pkey PRIMARY KEY (cargo_id, beneficio_id);


--
-- Name: cargo_departamento cargo_departamento_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_departamento
    ADD CONSTRAINT cargo_departamento_pkey PRIMARY KEY (cargo_id, departamento_id);


--
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (id);


--
-- Name: controle_de_acesso controle_de_acesso_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.controle_de_acesso
    ADD CONSTRAINT controle_de_acesso_pkey PRIMARY KEY (id);


--
-- Name: dados_pessoais dados_pessoais_cpf_key; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais
    ADD CONSTRAINT dados_pessoais_cpf_key UNIQUE (cpf);


--
-- Name: dados_pessoais dados_pessoais_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais
    ADD CONSTRAINT dados_pessoais_pkey PRIMARY KEY (id);


--
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- Name: dependentes dependentes_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dependentes
    ADD CONSTRAINT dependentes_pkey PRIMARY KEY (id);


--
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- Name: ferias ferias_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.ferias
    ADD CONSTRAINT ferias_pkey PRIMARY KEY (beneficio_id);


--
-- Name: funcionarios_cargo funcionarios_cargo_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_cargo
    ADD CONSTRAINT funcionarios_cargo_pkey PRIMARY KEY (funcionarios_id, cargo_id);


--
-- Name: funcionarios_departamento funcionarios_departamento_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_departamento
    ADD CONSTRAINT funcionarios_departamento_pkey PRIMARY KEY (funcionarios_id, departamento_id, chefe);


--
-- Name: funcionarios_dependentes funcionarios_dependentes_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_dependentes
    ADD CONSTRAINT funcionarios_dependentes_pkey PRIMARY KEY (funcionarios_id, dependentes_id);


--
-- Name: funcionarios funcionarios_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios
    ADD CONSTRAINT funcionarios_pkey PRIMARY KEY (id);


--
-- Name: historico_de_cargo_cargo historico_de_cargo_cargo_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_cargo
    ADD CONSTRAINT historico_de_cargo_cargo_pkey PRIMARY KEY (historico_de_cargo_id, cargo_id);


--
-- Name: historico_de_cargo_funcionarios historico_de_cargo_funcionarios_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_funcionarios
    ADD CONSTRAINT historico_de_cargo_funcionarios_pkey PRIMARY KEY (historico_de_cargo_id, funcionarios_id);


--
-- Name: historico_de_cargo historico_de_cargo_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo
    ADD CONSTRAINT historico_de_cargo_pkey PRIMARY KEY (id);


--
-- Name: historico_de_pagamentos historico_de_pagamentos_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_pagamentos
    ADD CONSTRAINT historico_de_pagamentos_pkey PRIMARY KEY (id);


--
-- Name: plano_de_saude plano_de_saude_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.plano_de_saude
    ADD CONSTRAINT plano_de_saude_pkey PRIMARY KEY (beneficio_id);


--
-- Name: telefone telefone_pkey; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.telefone
    ADD CONSTRAINT telefone_pkey PRIMARY KEY (id);


--
-- Name: telefone telefone_telefone_key; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.telefone
    ADD CONSTRAINT telefone_telefone_key UNIQUE (telefone);


--
-- Name: dados_pessoais uq_cpf; Type: CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais
    ADD CONSTRAINT uq_cpf UNIQUE (cpf);


--
-- Name: acesso fk_acesso_controle_de_acesso1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.acesso
    ADD CONSTRAINT fk_acesso_controle_de_acesso1 FOREIGN KEY (controle_de_acesso_id) REFERENCES rh.controle_de_acesso(id);


--
-- Name: cargo_beneficio fk_cargo_beneficio_beneficio1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_beneficio
    ADD CONSTRAINT fk_cargo_beneficio_beneficio1 FOREIGN KEY (beneficio_id) REFERENCES rh.beneficio(id);


--
-- Name: cargo_beneficio fk_cargo_beneficio_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_beneficio
    ADD CONSTRAINT fk_cargo_beneficio_cargo1 FOREIGN KEY (cargo_id) REFERENCES rh.cargo(id) ON DELETE CASCADE;


--
-- Name: cargo_departamento fk_cargo_departamento_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_departamento
    ADD CONSTRAINT fk_cargo_departamento_cargo1 FOREIGN KEY (cargo_id) REFERENCES rh.cargo(id);


--
-- Name: cargo_departamento fk_cargo_departamento_departamento1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.cargo_departamento
    ADD CONSTRAINT fk_cargo_departamento_departamento1 FOREIGN KEY (departamento_id) REFERENCES rh.departamento(id);


--
-- Name: controle_de_acesso fk_controle_de_acesso_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.controle_de_acesso
    ADD CONSTRAINT fk_controle_de_acesso_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id);


--
-- Name: dados_pessoais fk_dados_pessoais_dependentes1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais
    ADD CONSTRAINT fk_dados_pessoais_dependentes1 FOREIGN KEY (dependentes_id) REFERENCES rh.dependentes(id) ON DELETE CASCADE;


--
-- Name: dados_pessoais fk_dados_pessoais_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.dados_pessoais
    ADD CONSTRAINT fk_dados_pessoais_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: endereco fk_endereco_dados_pessoais; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.endereco
    ADD CONSTRAINT fk_endereco_dados_pessoais FOREIGN KEY (dados_pessoais_id) REFERENCES rh.dados_pessoais(id) ON DELETE CASCADE;


--
-- Name: ferias fk_ferias_beneficio1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.ferias
    ADD CONSTRAINT fk_ferias_beneficio1 FOREIGN KEY (beneficio_id) REFERENCES rh.beneficio(id) ON DELETE CASCADE;


--
-- Name: funcionarios_cargo fk_funcionarios_cargo_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_cargo
    ADD CONSTRAINT fk_funcionarios_cargo_cargo1 FOREIGN KEY (cargo_id) REFERENCES rh.cargo(id);


--
-- Name: funcionarios_cargo fk_funcionarios_cargo_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_cargo
    ADD CONSTRAINT fk_funcionarios_cargo_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: funcionarios_departamento fk_funcionarios_departamento_departamento1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_departamento
    ADD CONSTRAINT fk_funcionarios_departamento_departamento1 FOREIGN KEY (departamento_id) REFERENCES rh.departamento(id);


--
-- Name: funcionarios_departamento fk_funcionarios_departamento_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_departamento
    ADD CONSTRAINT fk_funcionarios_departamento_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: funcionarios_dependentes fk_funcionarios_dependentes_dependentes1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_dependentes
    ADD CONSTRAINT fk_funcionarios_dependentes_dependentes1 FOREIGN KEY (dependentes_id) REFERENCES rh.dependentes(id);


--
-- Name: funcionarios_dependentes fk_funcionarios_dependentes_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.funcionarios_dependentes
    ADD CONSTRAINT fk_funcionarios_dependentes_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: historico_de_cargo_cargo fk_historico_de_cargo_cargo_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_cargo
    ADD CONSTRAINT fk_historico_de_cargo_cargo_cargo1 FOREIGN KEY (cargo_id) REFERENCES rh.cargo(id);


--
-- Name: historico_de_cargo_cargo fk_historico_de_cargo_cargo_historico_de_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_cargo
    ADD CONSTRAINT fk_historico_de_cargo_cargo_historico_de_cargo1 FOREIGN KEY (historico_de_cargo_id) REFERENCES rh.historico_de_cargo(id);


--
-- Name: historico_de_cargo_funcionarios fk_historico_de_cargo_funcionarios_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_funcionarios
    ADD CONSTRAINT fk_historico_de_cargo_funcionarios_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: historico_de_cargo_funcionarios fk_historico_de_cargo_funcionarios_historico_de_cargo1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_cargo_funcionarios
    ADD CONSTRAINT fk_historico_de_cargo_funcionarios_historico_de_cargo1 FOREIGN KEY (historico_de_cargo_id) REFERENCES rh.historico_de_cargo(id);


--
-- Name: historico_de_pagamentos fk_historico_de_pagamentos_funcionarios1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.historico_de_pagamentos
    ADD CONSTRAINT fk_historico_de_pagamentos_funcionarios1 FOREIGN KEY (funcionarios_id) REFERENCES rh.funcionarios(id) ON DELETE CASCADE;


--
-- Name: plano_de_saude fk_plano_de_saude_beneficio1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.plano_de_saude
    ADD CONSTRAINT fk_plano_de_saude_beneficio1 FOREIGN KEY (beneficio_id) REFERENCES rh.beneficio(id) ON DELETE CASCADE;


--
-- Name: telefone fk_telefone_dados_pessoais1; Type: FK CONSTRAINT; Schema: rh; Owner: postgres
--

ALTER TABLE ONLY rh.telefone
    ADD CONSTRAINT fk_telefone_dados_pessoais1 FOREIGN KEY (dados_pessoais_id) REFERENCES rh.dados_pessoais(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

