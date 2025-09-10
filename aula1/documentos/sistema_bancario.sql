CREATE DATABASE sistema_bancario;

CREATE TABLE cliente(
id INT PRIMARY KEY,
	nome_cliente VARCHAR (150),
	cidade_cliente VARCHAR(100),
	endereco_cliente VARCHAR(100)
);

CREATE TABLE agencia(
id INT PRIMARY KEY,
	nome_agencia VARCHAR(100),
	cidade_agencia VARCHAR(100),
	depositos INT
);

CREATE TABLE emprestimo(
id INT 	PRIMARY KEY,
	numero_emprestimo INT,
	valor INT,
	nome_agencia INT REFERENCES agencia(id)
);

CREATE TABLE conta(
id INT PRIMARY KEY,
	numero_conta INT,
	saldo INT,
	nome_agencia INT REFERENCES agencia(id)
);
