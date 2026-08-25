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

--Total de vendas duranteos 7 períodos: 
SELECT a.nome_autor, SUM(v.quantidade_de_vendas) AS total_vendas
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY total_vendas DESC;

