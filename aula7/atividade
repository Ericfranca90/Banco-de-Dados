
-- 1) Criar o banco
CREATE DATABASE sistema_bancario;

-- Conectar ao banco antes de rodar as tabelas:
-- \c sistema_bancario;

-- 2) Criar tabelas principais

-- Clientes do banco
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL, -- formato 000.000.000-00
    email VARCHAR(200),
    telefone VARCHAR(20),
    data_nascimento DATE
);

-- Contas bancárias
CREATE TABLE contas (
    conta_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL REFERENCES clientes(cliente_id) ON DELETE CASCADE,
    agencia VARCHAR(10) NOT NULL,
    numero VARCHAR(20) NOT NULL,
    tipo_conta VARCHAR(20) NOT NULL, -- exemplo: corrente, poupanca
    saldo NUMERIC(14,2) NOT NULL DEFAULT 0.00,
    UNIQUE (agencia, numero)
);

-- Transações bancárias
CREATE TABLE transacoes (
    transacao_id SERIAL PRIMARY KEY,
    conta_id INT NOT NULL REFERENCES contas(conta_id) ON DELETE CASCADE,
    tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('deposito', 'saque', 'transferencia')),
    valor NUMERIC(14,2) NOT NULL CHECK (valor > 0),
    data_hora TIMESTAMP DEFAULT NOW(),
    descricao TEXT
);

-- 3) Inserir dados de exemplo

-- Clientes
INSERT INTO clientes (nome, cpf, email, telefone, data_nascimento) VALUES
('Ana Silva', '123.456.789-00', 'ana.silva@email.com', '(11) 91234-0001', '1985-04-12'),
('Bruno Costa', '234.567.890-11', 'bruno.costa@email.com', '(11) 91234-0002', '1990-09-30'),
('Carla Souza', '345.678.901-22', 'carla.souza@email.com', '(11) 91234-0003', '1978-02-05');

-- Contas
INSERT INTO contas (cliente_id, agencia, numero, tipo_conta, saldo) VALUES
(1, '0001', '10001-0', 'corrente', 3500.00),   -- Ana
(2, '0001', '10002-8', 'corrente', 1250.50),   -- Bruno
(3, '0002', '20001-5', 'poupanca', 9876.75);   -- Carla

-- Transações
INSERT INTO transacoes (conta_id, tipo, valor, data_hora, descricao) VALUES
(1, 'deposito', 2000.00, '2025-08-20 10:15:00', 'Depósito inicial Ana'),
(1, 'saque',    150.00, '2025-08-21 09:30:00', 'Saque em caixa eletrônico'),
(2, 'deposito', 1000.00, '2025-08-10 08:00:00', 'Depósito salário Bruno'),
(2, 'saque',    100.00, '2025-08-15 17:45:00', 'Saque rápido Bruno'),
(3, 'deposito', 5000.00, '2025-07-30 11:20:00', 'Depósito Carla'),
(3, 'saque',    300.00, '2025-08-05 14:10:00', 'Saque Carla');

-- 4) Consultas da atividade

-- 1. Quantos clientes estão cadastrados no banco?
SELECT COUNT(*) AS quantidade_clientes
FROM clientes;

-- 2. Qual o saldo total armazenado no banco?
SELECT SUM(saldo) AS saldo_total
FROM contas;

-- 3. Qual a média dos valores de saque realizados?
SELECT AVG(valor) AS media_saques
FROM transacoes
WHERE tipo = 'saque';
