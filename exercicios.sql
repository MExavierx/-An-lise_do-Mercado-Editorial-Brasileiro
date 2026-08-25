--Quero descobrir quais livros existem na minha base e visualizar o nome de cada um.
SELECT nome_livro 
FROM livros; 
---
--Quero listar todos os livros em ordem alfabética pelo nome.
SELECT nome_livro
FROM livros
ORDER BY nome_livro;
---
--Quero listar somente os livros cujo id_categoria seja igual a 1.
SELECT nome_livro 
FROM livros
WHERE id_categoria = 1; 
---------
--- Liste os livros da categoria 1 em ordem alfabética.
SELECT nome_livro 
FROM livros 
WHERE id_categoria = 1
ORDER by nome_livro; 
--------------
--Liste os livros que pertencem à categoria 1 E à editora 2.
SELECT nome_livro 
FROM livros 
WHERE id_categoria = 1 
AND id_editora =2; 
--------------
---Liste os livros que pertencem à categoria 1 OU à categoria 4.
SELECT nome_livro
FROM livros 
WHERE id_categoria = 1
OR id_categoria = 4; 
----------------
---- Liste os livros que são da categoria 1 OU da editora 4.
 SELECT nome_livro 
 FROM livros
 WHERE id_categoria = 1
 or id_editora = 4;
 ----------------------
 ---- Quantos livros existem na tabela livros
SELECT COUNT(*) AS quantidade_livros
FROM livros;
---------------------
----Quantos livros cada editora possui?
SELECT  id_editora, COUNT(*) AS total_livros
FROM livros
GROUP BY id_editora;
----------------------
--Quantos livros existem para cada id_autor na tabela livros?
SELECT id_autor, COUNT(*) AS total_livros 
FROM livros
GROUP BY id_autor;
-----------
--- FIXANDO GROUP BY 

------ Quantos livros existem em cada categoria?
SELECT id_categoria, COUNT(*) as total_livros_na_categoria
FROM livros 
GROUP BY id_categoria;

--------Quantos livros existem em cada editora?
SELECT id_editora, COUNT(*) AS total_livros_nas_editoras
FROM livros
GROUP by id_editora; 

------Quantos livros cada autor possui, mostrando primeiro os autores que possuem mais livros.
SELECT id_autor, COUNT(*) AS total_livros 
FROM livros
GROUP BY id_autor
ORDER by total_livros DESC;

-----
--SUM + GROUP BY + ORDER BY
--Quanto cada livro vendeu no total, considerando todos os períodos disponíveis na tabela vendas?
SELECT id_livro, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
GROUP BY id_livro
ORDER BY total_vendas DESC;
-------
----Qual foi a maior quantidade de vendas registrada na tabela vendas?
SELECT MAX(quantidade_de_vendas) AS maior_quantidade_vendas
FROM vendas;

-----Qual foi a menor quantidade de vendas registrada na tabela vendas?
SELECT MIN(quantidade_de_vendas) as menor_quantidade_vendas
FROM vendas; 

-----------------
-- UTILIZANDO JOIN
----Mostre o nome de cada livro e o nome do autor responsável por ele.
SELECT nome_livro, nome_autor
from livros
JOIN autores
on livros.id_autor = autores.id_autor;

-----Mostre o nome do livro, o nome do autor e 
-- a quantidade de vendas de cada registro da tabela vendas
SELECT nome_livro, nome_autor , quantidade_de_vendas
from livros 
join vendas on vendas.id_livro = livros.id_livro
JOIN autores on livros.id_autor = autores.id_autor;

----Qual autor possui o maior total de vendas, 
-- considerando todos os livros e todos os períodos disponíveis?
SELECT nome_autor, nome_livro , SUM(quantidade_de_vendas) as total_vendas
FROM livros
JOIN vendas 
GROUP by nome_autor
ORDER BY total_vendas DESC; 