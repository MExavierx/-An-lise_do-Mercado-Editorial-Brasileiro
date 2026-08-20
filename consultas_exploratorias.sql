--LIVROS
-- Verificando nossos dados como um todo
SELECT *
FROM livros;

SELECT nome_livro
FROM livros;

--AUTORES
-- Verificando nossos autores 
SELECT nome_autor
FROM autores; 

--EDITORAS 
SELECT nome_editora
FROM editoras; 

--CATEGORIAS 
SELECT nome_categoria
FROM categorias; 


--------
--ORDENANDO 
SELECT nome_livro
FROM livros
ORDER BY nome_livro DESC; 

----------
-- QUAL AUTOR POSSUI MAIS LIVROS CADASTRADOS? E QUANTOS OS OUTROS TEM? 
SELECT nome_autor, COUNT(*) AS total_livros
FROM livros
JOIN autores
ON livros.id_autor = autores.id_autor
GROUP BY nome_autor
ORDER BY total_livros DESC;
----------------------
SELECT nome_autor, nome_livro
FROM livros
JOIN autores
ON livros.id_autor = autores.id_autor
WHERE nome_autor = 'Ali Hazelwood';
------------
SELECT nome_categoria, nome_livro
FROM livros
JOIN categorias
on livros.id_categoria = categorias.id_categoria
WHERE id_categoria = 1; 
---------------
SELECT COUNT(DISTINCT nome_autor) 
FROM livros 
JOIN autores 
ON livros.id_autor = autores.id_autor; 
------------------------
SELECT DISTINCT nome_autor
FROM livros 
JOIN autores 
ON livros.id_autor = autores.id_autor; 
------------------
SELECT * FROM livros 
WHERE id_autor=1;






