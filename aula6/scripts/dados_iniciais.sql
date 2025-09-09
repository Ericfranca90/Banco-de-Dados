

-- Criação do Banco (só precisa rodar 1 vez)
CREATE DATABASE clima_alerta;

-- Conectar ao banco:
-- \c clima_alerta;

------------------------------------------------
-- TABELAS PRINCIPAIS
------------------------------------------------

CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE estado (
    sigla_estado CHAR(2) PRIMARY KEY,
    nome_estado VARCHAR(100) NOT NULL
);

CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9, 6) NOT NULL,
    longitude NUMERIC(9, 6) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL REFERENCES estado(sigla_estado)
);

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL
);

CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL UNIQUE,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

CREATE TABLE historico_evento (
    id_historico SERIAL PRIMARY KEY,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    status_anterior VARCHAR(30),
    status_novo VARCHAR(30),
    data_modificacao TIMESTAMP NOT NULL,
    modificado_por_usuario_id INT REFERENCES usuario(id_usuario)
);

------------------------------------------------
-- INSERÇÃO DE DADOS INICIAIS (Atividade anterior)
------------------------------------------------

-- Estados
INSERT INTO estado (sigla_estado, nome_estado) VALUES
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro'),
('MG', 'Minas Gerais');

-- Tipos de Evento
INSERT INTO tipo_evento (nome, descricao) VALUES
('Queimada', 'Incêndio de grandes proporções em áreas de vegetação.'),
('Inundação', 'Acúmulo excessivo de água em uma determinada área.'),
('Deslizamento', 'Movimento de terra ou rochas em encostas.');

-- Usuários
INSERT INTO usuario (nome, email, senha_hash) VALUES
('Maria Oliveira', 'maria.oliveira@email.com', 'hash_senha_maria'),
('João Silva', 'joao.silva@email.com', 'hash_senha_joao'),
('Ana Costa', 'ana.costa@email.com', 'hash_senha_ana');

-- Localizações
INSERT INTO localizacao (latitude, longitude, cidade, sigla_estado) VALUES
(-23.305000, -45.965000, 'Jacareí', 'SP'),
(-22.906800, -43.172900, 'Rio de Janeiro', 'RJ'),
(-19.916700, -43.934500, 'Belo Horizonte', 'MG');

-- Eventos iniciais
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Queimada na Serra da Mantiqueira', 'Fogo se alastrando próximo a áreas residenciais.', '2025-08-22 14:30:00', 'Ativo', 1, 1),
('Inundação no Centro do Rio', 'Fortes chuvas causam alagamentos em vias principais.', '2025-08-21 10:00:00', 'Em Monitoramento', 2, 2),
('Risco de Deslizamento em Ouro Preto', 'Solo encharcado apresenta risco para moradias.', '2025-08-22 09:15:00', 'Resolvido', 3, 3);

-- Relatos
INSERT INTO relato (texto, data_hora, id_evento, id_usuario) VALUES
('Muita fumaça visível da rodovia!', '2025-08-22 15:00:00', 1, 1),
('A rua principal está completamente alagada.', '2025-08-21 11:30:00', 2, 2);

-- Alertas
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento) VALUES
('Alerta Crítico: Evacuem a área próxima à serra imediatamente.', '2025-08-22 15:10:00', 'Crítico', 1),
('Alerta Médio: Evitem o centro da cidade devido a alagamentos.', '2025-08-21 10:30:00', 'Médio', 2);

------------------------------------------------
-- NOVOS INSERIDOS (Atividade atual)
------------------------------------------------

-- Evento extra 1: Deslizamento em MG
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
    'Deslizamento em encosta urbana',
    'Casas próximas apresentam rachaduras após fortes chuvas.',
    '2025-08-18 07:45:00',
    'Ativo',
    (SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Deslizamento'),
    (SELECT id_localizacao FROM localizacao WHERE cidade = 'Belo Horizonte' AND sigla_estado = 'MG')
);

-- Evento extra 2: Enchente em SP
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao)
VALUES (
    'Enchente na Marginal Tietê',
    'Água invadiu vias expressas, causando congestionamento severo.',
    '2025-08-19 08:20:00',
    'Em Monitoramento',
    (SELECT id_tipo_evento FROM tipo_evento WHERE nome = 'Inundação'),
    (SELECT id_localizacao FROM localizacao WHERE cidade = 'Jacareí' AND sigla_estado = 'SP')
);

------------------------------------------------
-- CONSULTAS (Atividade anterior + atualizadas)
------------------------------------------------

-- Listar usuários
SELECT nome, email FROM usuario;

-- Listar eventos com título e status
SELECT titulo, status FROM evento;

-- Mostrar eventos ativos
SELECT titulo, descricao, data_hora FROM evento
WHERE status = 'Ativo';

-- Localização específica
SELECT * FROM localizacao
WHERE cidade = 'Jacareí';

-- Eventos não resolvidos, mais recentes primeiro
SELECT titulo, status, data_hora FROM evento
WHERE status <> 'Resolvido'
ORDER BY data_hora DESC;

-- NOVAS CONSULTAS ORDENADAS

-- Listar todos os eventos em ordem cronológica (antigos primeiro)
SELECT id_evento, titulo, data_hora, status
FROM evento
ORDER BY data_hora ASC;

-- Mostrar os 3 eventos mais recentes
SELECT titulo, status, data_hora
FROM evento
ORDER BY data_hora DESC
LIMIT 3;
