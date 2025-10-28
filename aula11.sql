--1. Listar quantos livros cada autor publicou por editora (BD Biblioteca).
--Este exercício pede para agrupar por duas colunas (autor e editora) e contar os livros.
SELECT a.nome AS autor, e.nome AS editora, COUNT(l.id_livro) AS total_livros
FROM autor a
INNER JOIN livro l ON a.id_autor = l.id_autor
INNER JOIN editora e ON l.id_editora = e.id_editora
GROUP BY a.nome, e.nome
ORDER BY total_livros DESC;

--2. Listar a média de páginas dos livros por autor (BD Biblioteca).
--Este exercício pede a função AVG (média) agrupada por autor. Isso requer um JOIN entre autor e livro.
SELECT a.nome AS autor, AVG(l.num_paginas) AS media_paginas
FROM autor a
INNER JOIN livro l ON a.id_autor = l.id_autor
GROUP BY a.nome
ORDER BY media_paginas DESC;

--3. Mostrar o total de campanhas por reservatório e instituição (limnologia_db).
--contagem (COUNT) agrupada por duas colunas (reservatório e instituição).
SELECT r.nome AS reservatorio, i.nome AS instituicao, COUNT(c.id_campanha) AS total_campanhas
FROM campanha c
INNER JOIN reservatorio r ON c.id_reservatorio = r.id_reservatorio
INNER JOIN instituicao i ON c.id_instituicao = i.id_instituicao
GROUP BY r.nome, i.nome
ORDER BY total_campanhas DESC;

--4. Mostrar a média de valores de parâmetros por reservatório (limnologia_db).
--Este exercício pede a AVG (média) dos valores, agrupada por parâmetro e reservatório, exigindo múltiplos JOINs.
SELECT r.nome AS reservatorio, p.nome_parametro, AVG(s.valor) AS media_valores
FROM serie_temporal s
INNER JOIN reservatorio r ON s.id_reservatorio = r.id_reservatorio
INNER JOIN parametro p ON s.id_parametro = p.id_parametro
GROUP BY r.nome, p.nome_parametro
ORDER BY media_valores DESC;

--5. Listar as instituições que coletaram em mais de um reservatório (limnologia_db).
--este exercicio requer COUNT(DISTINCT ...) (para contar reservatórios únicos por instituição) e HAVING (para filtrar grupos, mostrando apenas os com > 1).
SELECT i.nome AS instituicao, COUNT(DISTINCT c.id_reservatorio) AS total_reservatorios
FROM instituicao i
INNER JOIN campanha c ON i.id_instituicao = c.id_instituicao
GROUP BY i.nome
HAVING COUNT(DISTINCT c.id_reservatorio) > 1
ORDER BY total_reservatorios DESC;
