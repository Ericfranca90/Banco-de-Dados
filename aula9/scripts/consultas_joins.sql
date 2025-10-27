-- Tipos de eventos ambientais
CREATE TABLE tipo_evento (
    id_tipo_evento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Locais onde ocorreram os eventos
CREATE TABLE localizacao (
    id_localizacao SERIAL PRIMARY KEY,
    cidade VARCHAR(100) NOT NULL,
    sigla_estado CHAR(2) NOT NULL
);

-- Eventos ambientais registrados
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,  -- Ex: "Queimada no Parque Estadual"
    data_evento DATE NOT NULL,
    id_tipo_evento INT REFERENCES tipo_evento(id_tipo_evento),
    id_localizacao INT REFERENCES localizacao(id_localizacao)
);

-- Tipos de eventos ambientais
INSERT INTO tipo_evento (nome) VALUES
('Queimada'),
('Enchente'),
('Deslizamento'),
('Poluição do Ar'),
('Seca Prolongada');

-- Locais
INSERT INTO localizacao (cidade, sigla_estado) VALUES
('Jacareí', 'SP'),
('São José dos Campos', 'SP'),
('Taubaté', 'SP'),
('Lorena', 'SP'),
('Guaratinguetá', 'SP');

-- Eventos ambientais
INSERT INTO evento (titulo, data_evento, id_tipo_evento, id_localizacao) VALUES
('Queimada em área rural de Jacareí', '2025-08-10', 1, 1),
('Enchente no centro de Taubaté', '2025-01-15', 2, 3),
('Deslizamento em área de risco', '2025-02-20', 3, 4),
('Alta concentração de poluentes', '2025-05-18', 4, 2),
('Seca prolongada em Guaratinguetá', '2025-09-05', 5, 5),
('Queimada em reserva florestal', '2025-09-20', 1, NULL);  -- sem local registrado

-- Consulta A [Mostrar o título do evento e o tipo de evento (INNER JOIN)]
-- Mostra todos os eventos que têm tipo definido (exclui os que estão sem tipo).
SELECT 
    e.titulo AS evento,
    te.nome AS tipo_evento
FROM evento e
INNER JOIN tipo_evento te 
    ON e.id_tipo_evento = te.id_tipo_evento;

-- Consulta B [Mostrar o título do evento, cidade e estado (INNER JOIN)]
-- Mostra apenas eventos que têm uma localização registrada.
SELECT 
    e.titulo AS evento,
    l.cidade,
    l.sigla_estado
FROM evento e
INNER JOIN localizacao l 
    ON e.id_localizacao = l.id_localizacao;

-- Consulta C [Mostrar todos os eventos (com tipo e cidade), incluindo os que não têm local registrado (LEFT JOIN)]
-- Mostra todos os eventos, mesmo os que ainda não têm local (NULL).
-- Utilizei LEFT JOIN para que os eventos que ainda NÃO têm uma localização cadastrada
-- também apareçam no resultado, com os campos de cidade e estado como NULL.
--
-- Diferença para o INNER JOIN:
--   → No INNER JOIN, só aparecem eventos que possuem correspondência nas tabelas de tipo_evento e localizacao.
--   → No LEFT JOIN, aparecem TODOS os eventos, mesmo os que ainda não têm local definido.
SELECT 
    e.titulo AS evento,
    te.nome AS tipo_evento,
    l.cidade,
    l.sigla_estado
FROM evento e
LEFT JOIN tipo_evento te 
    ON e.id_tipo_evento = te.id_tipo_evento
LEFT JOIN localizacao l 
    ON e.id_localizacao = l.id_localizacao;

--Consulta D
--Reescrever a consulta B usando RIGHT JOIN
--Mostra o mesmo resultado da consulta B, mas com a lógica invertida (RIGHT JOIN).
-- A diferença principal está na ordem das tabelas e na forma de leitura:
--   - No INNER JOIN da consulta B, a tabela 'evento' vinha primeiro (à esquerda)
--     e a 'localizacao' vinha depois, ligadas por um INNER JOIN.
--   - Agora, com RIGHT JOIN, invertemos a ordem: começamos pela 'localizacao'
--     e fazemos o JOIN à direita com 'evento'.
--
-- O resultado final é o mesmo, pois estamos unindo as mesmas tabelas com a mesma condição.
-- Mas a leitura fica menos intuitiva, já que geralmente pensamos primeiro nos eventos
-- e depois nas localizações.
SELECT 
    e.titulo AS evento,
    l.cidade,
    l.sigla_estado
FROM localizacao l
RIGHT JOIN evento e 
    ON e.id_localizacao = l.id_localizacao;

--Consulta E
--Contar quantos eventos ocorreram em cada cidade
SELECT 
    l.cidade,
    COUNT(e.id_evento) AS quantidade_eventos
FROM localizacao l
LEFT JOIN evento e 
    ON e.id_localizacao = l.id_localizacao
GROUP BY l.cidade
ORDER BY quantidade_eventos DESC;

