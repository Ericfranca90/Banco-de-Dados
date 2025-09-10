-- ====================================================
-- 1) Criar o banco de dados
-- ====================================================
CREATE DATABASE sistema_bancario;

-- Usar o banco criado
\c sistema_bancario;

-- ====================================================
-- 2) Criar tabelas
-- ====================================================

-- Tabela de clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(11) UNIQUE NOT NULL,
    endereco TEXT,
    telefone VARCHAR(15)
);

-- Tabela de contas
CREATE TABLE contas (
    id_conta SERIAL PRIMARY KEY,
    numero_conta VARCHAR(10) UNIQUE NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0,
    id_cliente INT REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabela de transações
CREATE TABLE transacoes (
    id_transacao SERIAL PRIMARY KEY,
    id_conta INT REFERENCES contas(id_conta) ON DELETE CASCADE,
    tipo VARCHAR(15) CHECK (tipo IN ('Depósito', 'Saque', 'Transferência')),
    valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destino_transferencia INT REFERENCES contas(id_conta)
);

-- ====================================================
-- 3) Inserir dados iniciais (clientes + contas)
-- ====================================================
INSERT INTO clientes (nome, cpf, endereco, telefone) VALUES
('João Silva', '12345678900', 'Rua A, 123', '11999990000'),
('Maria Oliveira', '98765432100', 'Rua B, 456', '11988887777');

INSERT INTO contas (numero_conta, saldo, id_cliente) VALUES
('000123', 1500.00, 1),
('000456', 2300.00, 2);

-- ====================================================
-- 4) Registrar algumas transações iniciais
-- ====================================================
INSERT INTO transacoes (id_conta, tipo, valor) VALUES
(1, 'Depósito', 500.00),
(2, 'Saque', 200.00);

-- ====================================================
-- 5) ATIVIDADE PRÁTICA (Individual)
-- ====================================================

-- a) Inserir novo cliente
INSERT INTO clientes (nome, cpf, endereco, telefone)
VALUES ('Ricardo Sousa', '12987654321', 'Rua Z, 321', '11999994444');

-- b) Criar conta para o novo cliente
INSERT INTO contas (numero_conta, saldo, id_cliente)
VALUES ('000789', 2458.00, 3);

-- c) Registrar transferência da conta 000123 para 000789
INSERT INTO transacoes (id_conta, tipo, valor, destino_transferencia)
VALUES (1, 'Transferência', 100.00, 3);

-- Atualizar saldos das contas envolvidas
UPDATE contas SET saldo = saldo - 100.00 WHERE numero_conta = '000123';
UPDATE contas SET saldo = saldo + 100.00 WHERE numero_conta = '000789';

-- d) Listar todas as contas com saldos atualizados
SELECT contas.numero_conta, clientes.nome, contas.saldo
FROM contas
INNER JOIN clientes ON contas.id_cliente = clientes.id_cliente;
