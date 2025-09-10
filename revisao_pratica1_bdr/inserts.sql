-- Questão 3: Inserir 3 lojas
INSERT INTO loja (nome, cidade) VALUES
('GameMania', 'São Paulo'),
('eSports World', 'Rio de Janeiro'),
('Pixel House', 'Curitiba');

-- Questão 4: Inserir 3 clientes
INSERT INTO cliente (nome, email, cidade) VALUES
('João Silva', 'joao@email.com', 'São Paulo'),
('Maria Souza', 'maria@email.com', 'Rio de Janeiro'),
('Carlos Lima', 'carlos@email.com', 'Belo Horizonte');

-- Questão 5: Inserir 3 jogos
INSERT INTO jogo (titulo, ano_lancamento, genero) VALUES
('FIFA 23', 2023, 'Esporte'),
('League of Legends', 2009, 'MOBA'),
('Elden Ring', 2022, 'RPG');

-- Questão 6: Inserir 2 compras
INSERT INTO compra (id_cliente, id_loja) VALUES
(1, 1), -- João comprou na GameMania
(2, 2); -- Maria comprou na eSports World

-- Questão 7: Relacionar jogos nas compras
-- Compra 1 (João)
INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(1, 1, 1),  -- FIFA 23
(1, 3, 1);  -- Elden Ring

-- Compra 2 (Maria)
INSERT INTO compra_jogo (id_compra, id_jogo, quantidade) VALUES
(2, 2, 1),  -- League of Legends
(2, 3, 2);  -- Elden Ring
