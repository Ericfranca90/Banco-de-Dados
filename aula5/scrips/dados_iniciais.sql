
-- Criação do Banco 
CREATE DATABASE clima_alerta;

-- Conectar ao banco antes de rodar o restante:
-- \c clima_alerta;

------------------------------------------------
-- TABELAS PRINCIPAIS
------------------------------------------------

-- Tipos de evento (ex: Queimada, Enchente, etc.)
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

-- Estados (usando sigla como chave primária)
CREATE TABLE estado (
    sigla CHAR(2) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Localizações (ligadas a um estado)
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    cidade VARCHAR(120) NOT NULL,
    sigla CHAR(2) NOT NULL REFERENCES estado(sigla)
);

-- Usuários
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL
);

-- Telefones
CREATE TABLE telefone (
    id_telefone SERIAL PRIMARY KEY,
    numero VARCHAR(20) UNIQUE NOT NULL,
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Eventos (cada evento tem um tipo e localização)
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT,
    data_hora TIMESTAMP NOT NULL,
    status VARCHAR(30) CHECK (status IN ('Ativo', 'Em Monitoramento', 'Resolvido')),
    id_tipo_evento INT NOT NULL REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT NOT NULL REFERENCES localizacao(id_localizacao)
);

-- Relatos feitos pelos usuários
CREATE TABLE relato (
    id_relato SERIAL PRIMARY KEY,
    texto TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    id_evento INT NOT NULL REFERENCES evento(id_evento),
    id_usuario INT NOT NULL REFERENCES usuario(id_usuario)
);

-- Alertas gerados
CREATE TABLE alerta (
    id_alerta SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP NOT NULL,
    nivel VARCHAR(20) CHECK (nivel IN ('Baixo', 'Médio', 'Alto', 'Crítico')),
    id_evento INT NOT NULL REFERENCES evento(id_evento)
);

------------------------------------------------
-- INSERÇÃO DE DADOS INICIAIS
------------------------------------------------

-- 1) Estados
INSERT INTO estado (sigla, nome) VALUES
('MG', 'Minas Gerais'),
('SP', 'São Paulo'),
('RJ', 'Rio de Janeiro');

-- 2) Tipos de Evento
INSERT INTO tipo_evento (nome, descricao) VALUES
('Inundação', 'Acúmulo de água em áreas urbanas ou rurais.'),
('Deslizamento', 'Queda de terra em regiões íngremes.'),
('Queimada', 'Incêndio de grande porte em área de vegetação.');

-- 3) Usuários
INSERT INTO usuario (nome, email, senha) VALUES
('Lucas Almeida', 'lucas.almeida@email.com', 'senha_hash_lucas'),
('Fernanda Souza', 'fernanda.souza@email.com', 'senha_hash_fernanda'),
('Carlos Pereira', 'carlos.pereira@email.com', 'senha_hash_carlos');

-- 4) Localizações
INSERT INTO localizacao (latitude, longitude, cidade, sigla) VALUES
(-22.906800, -43.172900, 'Rio de Janeiro', 'RJ'),
(-19.916700, -43.934500, 'Belo Horizonte', 'MG'),
(-23.305000, -45.965000, 'Jacareí', 'SP');

-- 5) Eventos
INSERT INTO evento (titulo, descricao, data_hora, status, id_tipo_evento, id_localizacao) VALUES
('Enchente no Centro', 'Alagamento em vias principais após forte chuva.', '2025-08-21 09:30:00', 'Em Monitoramento', 1, 1),
('Deslizamento em Ouro Preto', 'Encosta instável próxima a residências.', '2025-08-22 08:45:00', 'Ativo', 2, 2),
('Queimada em Serra Paulista', 'Fumaça intensa visível de vários bairros.', '2025-08-22 15:00:00', 'Resolvido', 3, 3);

-- 6) Relatos
INSERT INTO relato (texto, data_hora, id_evento, id_usuario) VALUES
('A água já entrou em algumas casas.', '2025-08-21 10:00:00', 1, 1),
('Terreno deslizando, moradores assustados.', '2025-08-22 09:15:00', 2, 2);

-- 7) Alertas
INSERT INTO alerta (mensagem, data_hora, nivel, id_evento) VALUES
('Alerta Médio: Evite circular pelo centro da cidade.', '2025-08-21 10:15:00', 'Médio', 1),
('Alerta Crítico: Evacuação urgente na área afetada.', '2025-08-22 09:30:00', 'Crítico', 2);

------------------------------------------------
-- CONSULTAS
------------------------------------------------

-- Consulta simples 1: Listar nomes e e-mails de usuários
SELECT nome, email FROM usuario;

-- Consulta simples 2: Mostrar títulos e status dos eventos
SELECT titulo, status FROM evento;

-- Consulta filtrada 1: Eventos ativos
SELECT titulo, descricao FROM evento
WHERE status = 'Ativo';

-- Consulta filtrada 2: Localizações no estado de MG
SELECT cidade, latitude, longitude FROM localizacao
WHERE sigla = 'MG';
