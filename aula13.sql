-- Tabela 1: reservatorio
CREATE TABLE reservatorio (
  id_reservatorio SERIAL PRIMARY KEY,
  nome VARCHAR(100) NOT NULL
);

-- Tabela 2: parametro
CREATE TABLE parametro (
  id_parametro SERIAL PRIMARY KEY,
  nome_parametro VARCHAR(50) NOT NULL
);

-- Tabela 3: serie_temporal
CREATE TABLE serie_temporal (
  id_serie SERIAL PRIMARY KEY,
  id_reservatorio INT NOT NULL,
  id_parametro INT NOT NULL,
  valor NUMERIC(5,2) NOT NULL,
  data_hora TIMESTAMP NOT NULL,
  FOREIGN KEY (id_reservatorio) REFERENCES reservatorio(id_reservatorio),
  FOREIGN KEY (id_parametro) REFERENCES parametro(id_parametro)
);

-- Inserir Reservatórios (IDs 1-4)
INSERT INTO reservatorio (nome) VALUES
('Jaguari'),
('Paraibuna'),
('Cachoeira do França'),
('Santa Branca');

-- Inserir Parâmetros (IDs 1-3)
INSERT INTO parametro (nome_parametro) VALUES
('pH'),
('Oxigênio Dissolvido'),
('Temperatura');

-- Inserir medições 
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora) VALUES
(1, 1, 7.2, '2024-10-22 08:00:00'), -- Jaguari, pH
(1, 2, 8.5, '2024-10-22 09:00:00'), -- Jaguari, Oxigênio Dissolvido
(2, 1, 6.9, '2024-10-22 08:00:00'), -- Paraibuna, pH
(3, 3, 24.0, '2024-10-22 08:00:00'), -- Cachoeira, Temperatura
(4, 2, 9.1, '2024-10-22 10:00:00'); -- Santa Branca, Oxigênio Dissolvido

-- Passo 1: Conferir os parâmetros disponíveis
SELECT * FROM parametro;

-- Passo 2: Rodar a subconsulta isolada
--a lista de IDs: 1 (Jaguari) e 4 (Santa Branca)
SELECT DISTINCT s.id_reservatorio
FROM serie_temporal s
INNER JOIN parametro p ON s.id_parametro = p.id_parametro
WHERE p.nome_parametro = 'Oxigênio Dissolvido';

-- Passo 3: Rodar a query completa com IN
--Agora vamos usar a consulta do "Passo 2" como um filtro dentro da consulta principal . 
--A consulta externa (SELECT nome FROM reservatorio) será filtrada pela lista [1, 4] que encontramos.
SELECT nome
FROM reservatorio
WHERE id_reservatorio IN (
    -- Esta é a subconsulta do Passo 2
    SELECT DISTINCT st.id_reservatorio
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE p.nome_parametro = 'Oxigênio Dissolvido'
);

-- Passo 4: Reescrever usando EXISTS
SELECT r.nome
FROM reservatorio r
WHERE EXISTS (
    SELECT 1 
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio -- A "correlação"
      AND p.nome_parametro = 'Oxigênio Dissolvido'
);

-- Passo 5.1: Analisando o plano do IN
EXPLAIN ANALYZE
SELECT nome
FROM reservatorio
WHERE id_reservatorio IN (
    SELECT DISTINCT st.id_reservatorio
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE p.nome_parametro = 'Oxigênio Dissolvido'
);

-- Passo 5.2: Analisando o plano do EXISTS
EXPLAIN ANALYZE
SELECT r.nome
FROM reservatorio r
WHERE EXISTS (
    SELECT 1 
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'Oxigênio Dissolvido'
);
