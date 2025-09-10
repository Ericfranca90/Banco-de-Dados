-- Questão 1: Criar o banco de dados
CREATE DATABASE rede_games;

-- Usar o banco
\c rede_games;

-- Questão 2: Criação das tabelas

CREATE TABLE loja (
    id_loja SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL
);

CREATE TABLE jogo (
    id_jogo SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    ano_lancamento INT,
    genero VARCHAR(100)
);

CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    cidade VARCHAR(100)
);

CREATE TABLE compra (
    id_compra SERIAL PRIMARY KEY,
    data_compra DATE DEFAULT CURRENT_DATE,
    id_cliente INT REFERENCES cliente(id_cliente),
    id_loja INT REFERENCES loja(id_loja)
);

-- Tabela associativa N:M
CREATE TABLE compra_jogo (
    id_compra INT REFERENCES compra(id_compra),
    id_jogo INT REFERENCES jogo(id_jogo),
    quantidade INT NOT NULL,
    PRIMARY KEY (id_compra, id_jogo)
);
