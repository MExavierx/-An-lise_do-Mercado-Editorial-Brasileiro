--1. Quais são os 10 livros com maior volume de vendas no período analisado?
SELECT nome_livro, SUM(quantidade_de_vendas) AS livros_top_10 
FROM vendas 
JOIN livros on livros.id_livro = vendas.id_livro
GROUP by nome_livro 
ORDER BY livros_top_10 DESC
LIMIT 10; 

--2.Quais são os 10 autores com maior volume de vendas?
SELECT nome_autor, SUM(quantidade_de_vendas) AS autores_top_10
from vendas 
join livros on livros.id_livro = vendas.id_livro
join autores on autores.id_autor = livros.id_autor
GROUP by nome_autor
ORDER by autores_top_10 DESC
LIMIT 10; 

--3.Quais categorias apresentam maior volume de vendas?
SELECT nome_categoria, SUM(quantidade_de_vendas) as categorias_mais_vendidas 
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
JOIN categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER BY categorias_mais_vendidas DESC;

--4.Qual é a média e a mediana de vendas por livro?
SELECT nome_livro, AVG(quantidade_de_vendas) as media_vendas_livro
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
GROUP by nome_livro
ORDER by media_vendas_livro DESC;

--5.Quais livros apresentam vendas muito acima da média?
SELECT nome_livro, AVG(quantidade_de_vendas) as media_vendas_livro
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
GROUP by nome_livro
ORDER by media_vendas_livro DESC
LIMIT 5;

--6.Livros que ocupam posições melhores no ranking vendem mais?
SELECT nome_livro, SUM(quantidade_de_vendas) as top_vendem_mais 
FROM vendas 
join livros on livros.id_livro = vendas.id_livro
WHERE posicao_ranking <= 10
GROUP by nome_livro
ORDER BY top_vendem_mais DESC; 

--7.Quais livros apresentaram maior crescimento ou queda nas vendas entre períodos?
  SELECT nome_livro, SUM(quantidade_de_vendas) as top_vendem_mais
	from vendas 
	join livros on livros.id_livro = vendas.id_livro
	GROUP by nome_livro
	ORDER by top_vendem_mais DESC
   	LIMIT 5; 

 SELECT nome_livro, SUM(quantidade_de_vendas) AS top_vendem_menos
	from vendas 
	join livros on livros.id_livro = vendas.id_livro
	GROUP by nome_livro
	ORDER by top_vendem_menos ASC
    LIMIT 5; 


--8.Quais autores possuem poucos livros, mas apresentam alto volume médio de vendas?
SELECT nome_autor, COUNT(nome_livro) as quant_livros, AVG(quantidade_de_vendas) as vendas_media_livros
from vendas 
join livros on livros.id_livro = vendas.id_livro
join autores on autores.id_autor = livros.id_autor
GROUP by nome_autor
ORDER by vendas_media_livros DESC, quant_livros ASC
LIMIT 10;

--9.Quais editoras concentram maior volume de vendas?
SELECT nome_editora, SUM(quantidade_de_vendas) as editoras_mais_vendedoras 
from vendas 
join livros on livros.id_livro = vendas.id_livro
join editoras on editoras.id_editora = livros.id_editora
GROUP by nome_editora
ORDER by editoras_mais_vendedoras DESC; 

--10.Quanto das vendas totais está concentrado nos 10 livros mais vendidos?
SELECT nome_livro, SUM(quantidade_de_vendas) as total_livros 
from vendas 
join livros on livros.id_livro = vendas.id_livro
WHERE posicao_ranking <= 10
GROUP by nome_livro
ORDER by total_livros DESC; 
