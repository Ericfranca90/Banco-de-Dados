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

-- Inserir Reservatórios (IDs 1, 2, 3)
INSERT INTO reservatorio (nome) VALUES
('Jaguari'),
('Paraibuna'),
('Cachoeira do França');

-- Inserir Parâmetros (IDs 1, 2)
INSERT INTO parametro (nome_parametro) VALUES
('pH'),
('Temperatura');

-- Inserir medições de pH (para IDs 1, 2, 3)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora) VALUES
-- Jaguari (ID 1), pH (ID 1)
(1, 1, 7.1, '2024-10-21 08:00:00'),
(1, 1, 7.3, '2024-10-21 12:00:00'),

-- Paraibuna (ID 2), pH (ID 1)
(2, 1, 6.9, '2024-10-21 08:00:00'),

-- Cachoeira do França (ID 3), pH (ID 1)
(3, 1, 7.5, '2024-10-21 09:00:00'),
(3, 1, 7.7, '2024-10-21 15:00:00');

-- Inserir medições de "ruído" (Temperatura, ID 2)
INSERT INTO serie_temporal (id_reservatorio, id_parametro, valor, data_hora) VALUES
(1, 2, 25.4, '2024-10-21 08:00:00'), -- Temperatura Jaguari
(2, 2, 24.8, '2024-10-21 08:00:00'), -- Temperatura Paraibuna
(3, 2, 26.1, '2024-10-21 09:00:00'); -- Temperatura Cachoeira

SELECT 
  r.nome AS reservatorio,
  
  -- Subconsulta para calcular a média do pH
  (
    SELECT AVG(st.valor)
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'pH'
  ) AS media_ph,
  
  -- Subconsulta para calcular o menor valor de pH
  (
    SELECT MIN(st.valor)
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'pH'
  ) AS minimo_ph,
  
  -- Subconsulta para calcular o maior valor de pH
  (
    SELECT MAX(st.valor)
    FROM serie_temporal st
    JOIN parametro p ON st.id_parametro = p.id_parametro
    WHERE st.id_reservatorio = r.id_reservatorio
      AND p.nome_parametro = 'pH'
  ) AS maximo_ph

FROM reservatorio r
ORDER BY r.id_reservatorio; -- Adicionei um ORDER BY para ficar organizado
