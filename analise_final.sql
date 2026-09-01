-- 1. Quais autores aparecem com maior frequência nos rankings?

-- Quantos livros publicados esse autor tem:
SELECT a.nome_autor, COUNT(DISTINCT l.id_livro) AS quantidade_livros
FROM livros l
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY quantidade_livros DESC; 


-- Quantas vezes esse autor aparece nos rankins durante os 7 períodos:
SELECT  a.nome_autor, COUNT(*) AS vezes_no_ranking
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY vezes_no_ranking DESC; 


-- Total de vendas durante os 7 períodos:
SELECT a.nome_autor, SUM(v.quantidade_de_vendas) AS total_vendas
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY total_vendas DESC;




-- 2. Quais categorias aparecem mais?
SELECT nome_categoria, COUNT(nome_categoria) as categoria_mais_presente 
FROM livros 
JOIN categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER by categoria_mais_presente DESC; 

-- 3. Quais livros tiveram maior presença no ranking?
SELECT nome_livro, COUNT(*) AS semanas_no_ranking
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY semanas_no_ranking DESC;


-- 4. Há diferenças entre os períodos analisados?
SELECT periodo_inicio, periodo_final, SUM(quantidade_de_vendas) as vendas_periodo_analisado 
FROM vendas 
GROUP BY periodo_inicio
ORDER BY vendas_periodo_analisado  DESC; 

-- 5. Quais editoras concentram mais livros entre os cinco primeiros colocados?
SELECT nome_editora, COUNT(*) AS livros_no_top_5
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN editoras ON livros.id_editora = editoras.id_editora
WHERE posicao_ranking <= 5
GROUP BY nome_editora
ORDER BY livros_no_top_5 DESC;




-- 6. Como o mercado se distribui entre categorias?
SELECT nome_categoria, SUM(quantidade_de_vendas) AS vendas_por_categorias
FROM vendas 
JOIN livros on livros.id_livro = vendas.id_livro
join categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER by vendas_por_categorias DESC;


-- 7. Quais livros apresentaram maior variação de posição ao longo dos períodos?
SELECT livros.nome_livro, MIN(vendas.posicao_ranking) AS melhor_posicao, MAX(vendas.posicao_ranking) AS pior_posicao
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY livros.nome_livro
ORDER BY pior_posicao - melhor_posicao DESC;



-- 8. Quanto foi vendido, no total, em cada posição do ranking?
SELECT posicao_ranking, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
GROUP BY posicao_ranking
ORDER BY posicao_ranking;


-- ANÁLISES DE DESEMPENHO

-- 9. Quais são os 10 livros com maior volume de vendas no período analisado?
SELECT nome_livro, SUM(quantidade_de_vendas) AS livros_top_10 
FROM vendas 
JOIN livros on livros.id_livro = vendas.id_livro
GROUP by nome_livro 
ORDER BY livros_top_10 DESC
LIMIT 10; 


-- 10. Quais são os 10 autores com maior volume de vendas?
SELECT nome_autor, SUM(quantidade_de_vendas) AS autores_top_10
from vendas 
join livros on livros.id_livro = vendas.id_livro
join autores on autores.id_autor = livros.id_autor
GROUP by nome_autor
ORDER by autores_top_10 DESC
LIMIT 10; 


-- 11. Quais categorias apresentam maior volume de vendas?
SELECT nome_categoria, SUM(quantidade_de_vendas) as categorias_mais_vendidas 
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
JOIN categorias on categorias.id_categoria = livros.id_categoria
GROUP by nome_categoria
ORDER BY categorias_mais_vendidas DESC;

-- 12. Qual é a média e a mediana de vendas por livro?
SELECT nome_livro, AVG(quantidade_de_vendas) as media_vendas_livro
FROM vendas
JOIN livros on livros.id_livro = vendas.id_livro
GROUP by nome_livro
ORDER by media_vendas_livro DESC;


-- Como o SQL não tem uma função de mediana nativa, vou fazer outro select
WITH OrderedData AS (
    SELECT 
        nome_livro,
        quantidade_de_vendas,
        ROW_NUMBER() OVER (
            PARTITION BY nome_livro 
            ORDER BY quantidade_de_vendas
        ) AS numero_linha,
        COUNT(*) OVER (
            PARTITION BY nome_livro
        ) AS total_periodos
    FROM vendas
    JOIN livros ON livros.id_livro = vendas.id_livro
)
SELECT nome_livro, quantidade_de_vendas AS mediana
FROM OrderedData
WHERE numero_linha = (total_periodos + 1) / 2;


-- 13. Quais livros apresentam vendas muito acima da média?
SELECT nome_livro, SUM(quantidade_de_vendas) AS soma_livros
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
HAVING SUM(quantidade_de_vendas) >
(
    SELECT AVG(total_livro)
    FROM
    (
        SELECT SUM(quantidade_de_vendas) AS total_livro
        FROM vendas
        GROUP BY id_livro
    )
);


-- 14. Livros que ocupam posições melhores no ranking vendem mais?
SELECT
    CASE
        WHEN posicao_ranking <= 10 THEN 'Top 10'
        WHEN posicao_ranking <= 20 THEN 'Top 20'
        ELSE 'Abaixo do Top 20'
    END,
    SUM(quantidade_de_vendas)
FROM vendas
GROUP BY
    CASE
        WHEN posicao_ranking <= 10 THEN 'Top 10'
        WHEN posicao_ranking <= 20 THEN 'Top 20'
        ELSE 'Abaixo do Top 20'
    END;


-- 15. Quais livros apresentaram maior crescimento ou queda nas vendas entre períodos?
SELECT 
    nome_livro,
    SUM(
        CASE
            WHEN periodo_inicio = '2025-06-30'
            THEN quantidade_de_vendas
        END
    ) AS primeiro_periodo,

    SUM(
        CASE
            WHEN periodo_inicio = '2025-08-11'
            THEN quantidade_de_vendas
        END
    ) AS ultimo_periodo,

    SUM(
        CASE
            WHEN periodo_inicio = '2025-08-11'
            THEN quantidade_de_vendas
        END
    )
    -
    SUM(
        CASE
            WHEN periodo_inicio = '2025-06-30'
            THEN quantidade_de_vendas
        END
    ) AS diferenca_vendas

FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY ABS(diferenca_vendas) DESC;


-- 16. Quais autores possuem poucos livros, mas apresentam alto volume médio de vendas?
SELECT nome_autor, COUNT(nome_livro) as quant_livros, AVG(quantidade_de_vendas) as vendas_media_livros
from vendas 
join livros on livros.id_livro = vendas.id_livro
join autores on autores.id_autor = livros.id_autor
GROUP by nome_autor
ORDER by vendas_media_livros DESC, quant_livros ASC
LIMIT 10;

-- 17. Quais editoras concentram maior volume de vendas?
SELECT nome_editora, SUM(quantidade_de_vendas) as editoras_mais_vendedoras 
from vendas 
join livros on livros.id_livro = vendas.id_livro
join editoras on editoras.id_editora = livros.id_editora
GROUP by nome_editora
ORDER by editoras_mais_vendedoras DESC; 

-- 18. Quanto das vendas totais está concentrado nos 10 livros mais vendidos?
SELECT 
    SUM(
        CASE
            WHEN posicao_ranking <= 10
            THEN quantidade_de_vendas
            ELSE 0
        END
    ) * 100.0 / SUM(quantidade_de_vendas) AS percentual_vendas_top_10
FROM vendas;


-- 19. Quais autores venderam mais livros do que a média de vendas por autor?
-- 1. Total de vendas por autor
-- 2. Média de vendas por autor
-- 3. comparar a média de vendas com a média dos autores
SELECT nome_autor, SUM(quantidade_de_vendas) as soma_autores 
from vendas 
join livros on livros.id_livro = vendas.id_livro
join autores on autores.id_autor = livros.id_autor
GROUP by nome_autor
HAVING SUM(quantidade_de_vendas) > 
(
	SELECT AVG(total_autores)
  	FROM 
  	(
		SELECT SUM(quantidade_de_vendas) AS total_autores
			FROM vendas
			JOIN livros ON livros.id_livro = vendas.id_livro
			GROUP BY livros.id_autor
    )

);


-- CLASSIFICAÇÃO DOS LIVROS

-- Classifique cada livro de acordo com sua melhor posição alcançada no ranking:
-- 1. posição 1 a 10 → "Top 10"
-- 2. posição 11 a 15 → "Top 15"
-- 3. posição 16 ou pior → "Abaixo do Top 15"
SELECT 
	CASE 
    	WHEN posicao_ranking <= 10 THEN 'Top 10' 
        WHEN posicao_ranking <= 15 THEN 'Top 15' 
        ELSE 'Abaixo do Top 15' 
    END, 
    SUM(quantidade_de_vendas) 
 FROM vendas
 GROUP by 
 CASE 
    	WHEN posicao_ranking <= 10 THEN 'Top 10' 
        WHEN posicao_ranking <= 15 THEN 'Top 15' 
        ELSE 'Abaixo do Top 15' 
    END;


-- Eu tenho o case when, mas ele não está sendo aplicado em cada livro separadamente. 
-- Para aplicar separamente ficaria
-- Classifique cada livro de acordo com sua melhor posição alcançada no ranking:
SELECT nome_livro,
       MIN(posicao_ranking),
       CASE
           WHEN MIN(posicao_ranking) <= 10 THEN 'Top 10'
           WHEN MIN(posicao_ranking) <= 15 THEN 'Top 15'
           ELSE 'Abaixo do Top 15'
       END
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro;




-- Quais livros apresentaram maior consistência, permanecendo no ranking durante todos os períodos?
SELECT 
    nome_livro, COUNT(DISTINCT periodo_inicio) AS quantidade_periodos
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
HAVING COUNT(DISTINCT periodo_inicio) = 7
ORDER BY nome_livro;
