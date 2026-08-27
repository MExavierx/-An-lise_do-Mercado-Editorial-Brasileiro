-- 1. Quais autores aparecem com maior frequência nos rankings?
--Quantos livros publicados esse autor tem: 
SELECT a.nome_autor, COUNT(DISTINCT l.id_livro) AS quantidade_livros
FROM livros l
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY quantidade_livros DESC; 

--------------

--Quantas vezes esse autor aparece nos rankins durante os 7 períodos: 
SELECT  a.nome_autor, COUNT(*) AS vezes_no_ranking
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY vezes_no_ranking DESC; 

------

--Total de vendas durante os 7 períodos: 
SELECT a.nome_autor, SUM(v.quantidade_de_vendas) AS total_vendas
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY total_vendas DESC;


-- 2. Quais editoras têm maior presença entre os livros mais vendidos?
SELECT nome_editora, SUM(quantidade_de_vendas) AS total_editoras
FROM vendas 
join livros on livros.id_livro = vendas.id_livro
JOIN editoras on editoras.id_editora = livros.id_editora
GROUP by nome_editora 
ORDER BY total_editoras DESC; 

-- 3. Quais categorias aparecem mais?
SELECT nome_categoria, COUNT(nome_categoria) as categoria_mais_presente 
FROM livros 
JOIN categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER by categoria_mais_presente DESC; 

-- 4. Existem autores que permanecem no ranking por várias semanas?
SELECT nome_autor, COUNT(*) as autor_mais_aparecido
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
JOIN autores on autores.id_autor = livros.id_autor
GROUP by nome_autor 
ORDER by autor_mais_aparecido DESC;

-- 5. Quais livros tiveram maior presença no ranking?
SELECT nome_livro, COUNT(*) AS semanas_no_ranking
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY semanas_no_ranking DESC;

-- 6. Há diferenças entre os períodos analisados?
SELECT periodo_inicio, periodo_final, SUM(quantidade_de_vendas) as vendas_periodo_analisado 
FROM vendas 
GROUP BY periodo_inicio
ORDER BY vendas_periodo_analisado  DESC; 

-- 7. Quais editoras concentram mais livros entre os cinco primeiros colocados?
SELECT nome_editora, COUNT(*) AS livros_no_top_5
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN editoras ON livros.id_editora = editoras.id_editora
WHERE posicao_ranking <= 5
GROUP BY nome_editora
ORDER BY livros_no_top_5 DESC;

-- 8. Como o mercado se distribui entre categorias?
SELECT nome_categoria, SUM(quantidade_de_vendas) AS vendas_por_categorias
FROM vendas 
JOIN livros on livros.id_livro = vendas.id_livro
join categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER by vendas_por_categorias DESC;

-- 9. Quais livros apresentaram maior variação de posição ao longo dos períodos?
SELECT livros.nome_livro, MIN(vendas.posicao_ranking) AS melhor_posicao, MAX(vendas.posicao_ranking) AS pior_posicao
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY livros.nome_livro
ORDER BY pior_posicao - melhor_posicao DESC;

-- 10. Quanto foi vendido, no total, em cada posição do ranking?
SELECT posicao_ranking, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
GROUP BY posicao_ranking
ORDER BY posicao_ranking;



