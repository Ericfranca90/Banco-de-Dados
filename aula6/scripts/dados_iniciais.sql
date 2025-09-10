

-- Criação do Banco (só precisa rodar uma vez)
CREATE DATABASE clima_alerta;

-- Conectar ao banco:
-- \c clima_alerta;

------------------------------------------------
-- TABELAS
------------------------------------------------

-- Tipos de Evento
CREATE TABLE tipo_evento(
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Estados
CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

-- Localização
CREATE TABLE localizacao(
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

-- Usuários
CREATE TABLE usuario(
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

-- Telefones
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Eventos
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo','EmMonitoramento','Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Relatos
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Alertas
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo','Médio','Alto','Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

------------------------------------------------
-- INSERÇÃO DE DADOS INICIAIS
------------------------------------------------

-- Estados
INSERT INTO estado (sigla_estado, nome_estado) VALUES
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais');

-- Tipos de Evento
INSERT INTO tipo_evento(nome, descricao) VALUES
('Queimada', 'Incêndio em área de vegetação ou urbana'),
('Enchente', 'Alagamentos por chuvas intensas ou transbordo'),
('Deslizamento', 'Movimento de massa em encostas');

-- Usuários
INSERT INTO usuario(nome, email, senha_hash) VALUES
('Maria Oliveira', 'maria.oliveira@email.com', 'hash$1'),
('João Souza', 'joao.souza@email.com', 'hash$2'),
('Ana Lima', 'ana.lima@email.com', 'hash$3');

-- Localizações
INSERT INTO localizacao(latitude, longitude, cidade, sigla_estado) VALUES
(-23.305000, -45.965000, 'Jacareí', 'SP'),
(-22.785000, -43.304000, 'Duque de Caxias', 'RJ'),
(-19.924500, -43.935200, 'Belo Horizonte', 'MG');

------------------------------------------------
-- EVENTOS (com chaves estrangeiras)
------------------------------------------------

-- Evento 1: Queimada em Jacareí (SP)
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
'Queimada em área de preservação',
'Foco de incêndio próximo à represa municipal.',
'2025-08-15 14:35:00',
'Ativo',
(SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Queimada'),
(SELECT id_localizacao FROM localizacao WHERE cidade = 'Jacareí' AND sigla_estado= 'SP')
);

-- Evento 2: Enchente em Duque de Caxias (RJ)
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
'Enchente em bairro central',
'Rua principal alagada; trânsito interrompido.',
'2025-08-16 09:10:00',
'EmMonitoramento',
(SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Enchente'),
(SELECT id_localizacao FROM localizacao WHERE cidade = 'Duque de Caxias' AND sigla_estado= 'RJ')
);

-- Evento 3: Deslizamento em Belo Horizonte (MG)
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
'Deslizamento em encosta',
'Queda de barreira após chuva intensa.',
'2025-08-17 07:50:00',
'Resolvido',
(SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Deslizamento'),
(SELECT id_localizacao FROM localizacao WHERE cidade = 'Belo Horizonte' AND sigla_estado= 'MG')
);

-- Evento extra 4: Enchente em São Paulo (SP)
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
'Enchente na Marginal Tietê',
'Água invadiu vias expressas, causando congestionamento severo.',
'2025-08-19 08:20:00',
'EmMonitoramento',
(SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Enchente'),
(SELECT id_localizacao FROM localizacao WHERE cidade = 'Jacareí' AND sigla_estado= 'SP')
);

------------------------------------------------
-- CONSULTAS
------------------------------------------------

-- 2.1 Listar usuários
SELECT id_usuario, nome, email
FROM usuario;

-- 2.2 Listar tipos de evento
SELECT id_tipo_evento, nome, descricao
FROM tipo_evento;

-- 3.1 Eventos filtrados por status
SELECT id_evento, titulo, status, data_hora
FROM evento
WHERE status = 'Ativo';

-- 3.2 Localizações apenas do estado de SP
SELECT id_localizacao, cidade, sigla_estado
FROM localizacao
WHERE sigla_estado= 'SP';

-- Contagens
SELECT COUNT(*) FROM estado;
SELECT COUNT(*) FROM tipo_evento;
SELECT COUNT(*) FROM usuario;
SELECT COUNT(*) FROM localizacao;
SELECT COUNT(*) FROM evento;

-- Ordenação por data (mais recentes primeiro)
SELECT titulo, data_hora
FROM evento
ORDER BY data_hora DESC;

-- Top 3 eventos mais recentes
SELECT titulo, status
FROM evento
ORDER BY data_hora DESC
LIMIT 3;
