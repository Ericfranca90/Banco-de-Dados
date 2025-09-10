-- Questão 8: Listar clientes (id, nome, cidade)
SELECT id_cliente, nome, cidade
FROM cliente;

-- Questão 9: Listar jogos lançados após 2020
SELECT titulo, ano_lancamento
FROM jogo
WHERE ano_lancamento > 2020;

-- Questão 10: Quantos jogos foram comprados no total
SELECT SUM(quantidade) AS total_jogos_comprados
FROM compra_jogo;
