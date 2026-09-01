
-- 1. Quais autores aparecem com maior frequência nos rankings?

-- Quantos livros publicados cada autor possui:
SELECT a.nome_autor, COUNT(DISTINCT l.id_livro) AS quantidade_livros
FROM livros l
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY quantidade_livros DESC;


-- Quantas vezes cada autor aparece nos rankings durante os 7 períodos:
SELECT a.nome_autor, COUNT(*) AS vezes_no_ranking
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY vezes_no_ranking DESC;


-- Total de vendas de cada autor durante os 7 períodos:
SELECT a.nome_autor, SUM(v.quantidade_de_vendas) AS total_vendas
FROM vendas v
JOIN livros l ON v.id_livro = l.id_livro
JOIN autores a ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome_autor
ORDER BY total_vendas DESC;



-- 2. Quais categorias aparecem mais?
SELECT nome_categoria, COUNT(*) AS quantidade_livros
FROM livros
JOIN categorias ON categorias.id_categoria = livros.id_categoria
GROUP BY nome_categoria
ORDER BY quantidade_livros DESC;



-- 3. Quais livros tiveram maior presença no ranking?
SELECT nome_livro, COUNT(*) AS semanas_no_ranking
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY semanas_no_ranking DESC;



-- 4. Há diferenças nas vendas entre os períodos analisados?
SELECT periodo_inicio, periodo_final, SUM(quantidade_de_vendas) AS vendas_periodo_analisado
FROM vendas
GROUP BY periodo_inicio, periodo_final
ORDER BY vendas_periodo_analisado DESC;



-- 5. Quais editoras concentram mais livros entre os cinco primeiros colocados?
SELECT nome_editora, COUNT(*) AS livros_no_top_5
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN editoras ON livros.id_editora = editoras.id_editora
WHERE posicao_ranking <= 5
GROUP BY nome_editora
ORDER BY livros_no_top_5 DESC;



-- 6. Como o mercado se distribui entre categorias?
SELECT nome_categoria, SUM(quantidade_de_vendas) AS vendas_por_categoria
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN categorias ON categorias.id_categoria = livros.id_categoria
GROUP BY nome_categoria
ORDER BY vendas_por_categoria DESC;



-- 7. Quais livros apresentaram maior variação de posição ao longo dos períodos?
SELECT livros.nome_livro,
       MIN(vendas.posicao_ranking) AS melhor_posicao,
       MAX(vendas.posicao_ranking) AS pior_posicao,
       MAX(vendas.posicao_ranking) - MIN(vendas.posicao_ranking) AS variacao_posicao
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY livros.nome_livro
ORDER BY variacao_posicao DESC;



-- 8. Quanto foi vendido, no total, em cada posição do ranking?
SELECT posicao_ranking, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
GROUP BY posicao_ranking
ORDER BY posicao_ranking;



-- ANÁLISES DE DESEMPENHO

-- 9. Quais são os 10 livros com maior volume de vendas no período analisado?
SELECT nome_livro, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY total_vendas DESC
LIMIT 10;



-- 10. Quais são os 10 autores com maior volume de vendas?
SELECT nome_autor, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN autores ON autores.id_autor = livros.id_autor
GROUP BY nome_autor
ORDER BY total_vendas DESC
LIMIT 10;



-- 11. Quais categorias apresentam maior volume de vendas?
SELECT nome_categoria, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN categorias ON categorias.id_categoria = livros.id_categoria
GROUP BY nome_categoria
ORDER BY total_vendas DESC;



-- 12. Qual é a média e a mediana de vendas por livro?

-- Média de vendas por livro:
SELECT nome_livro, AVG(quantidade_de_vendas) AS media_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY media_vendas DESC;


-- Mediana de vendas por livro:
-- Como existem 7 períodos por livro, a mediana corresponde
-- ao 4º valor após ordenar as vendas.

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
SELECT nome_livro,
       quantidade_de_vendas AS mediana
FROM OrderedData
WHERE numero_linha = (total_periodos + 1) / 2;



-- 13. Quais livros apresentam vendas muito acima da média?
SELECT nome_livro, SUM(quantidade_de_vendas) AS total_vendas
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
)
ORDER BY total_vendas DESC;



-- 14. Livros que ocupam posições melhores no ranking vendem mais?
SELECT
    CASE
        WHEN posicao_ranking <= 10 THEN 'Top 10'
        WHEN posicao_ranking <= 20 THEN 'Top 20'
        ELSE 'Abaixo do Top 20'
    END AS classificacao_ranking,
    SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
GROUP BY
    CASE
        WHEN posicao_ranking <= 10 THEN 'Top 10'
        WHEN posicao_ranking <= 20 THEN 'Top 20'
        ELSE 'Abaixo do Top 20'
    END
ORDER BY total_vendas DESC;



-- 15. Quais livros apresentaram maior crescimento ou queda
-- nas vendas entre o primeiro e o último período?
SELECT
    nome_livro,
    SUM(
        CASE
            WHEN periodo_inicio = '2025-06-30'
            THEN quantidade_de_vendas
            ELSE 0
        END
    ) AS primeiro_periodo,
    SUM(
        CASE
            WHEN periodo_inicio = '2025-08-11'
            THEN quantidade_de_vendas
            ELSE 0
        END
    ) AS ultimo_periodo,
    SUM(
        CASE
            WHEN periodo_inicio = '2025-08-11'
            THEN quantidade_de_vendas
            ELSE 0
        END
    )
    -
    SUM(
        CASE
            WHEN periodo_inicio = '2025-06-30'
            THEN quantidade_de_vendas
            ELSE 0
        END
    ) AS diferenca_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY ABS(diferenca_vendas) DESC;



-- 16. Quais autores possuem poucos livros, mas apresentam
-- alto volume médio de vendas?
SELECT nome_autor, COUNT(DISTINCT nome_livro) AS quantidade_livros,  AVG(quantidade_de_vendas) AS media_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN autores ON autores.id_autor = livros.id_autor
GROUP BY nome_autor
HAVING COUNT(DISTINCT nome_livro) <= 2
ORDER BY media_vendas DESC;



-- 17. Quais editoras concentram maior volume de vendas?
SELECT nome_editora, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN editoras ON editoras.id_editora = livros.id_editora
GROUP BY nome_editora
ORDER BY total_vendas DESC;



-- 18. Quanto das vendas totais está concentrado nos 10 livros mais vendidos?
WITH TotalPorLivro AS (
    SELECT
        id_livro,
        SUM(quantidade_de_vendas) AS total_vendas
    FROM vendas
    GROUP BY id_livro
),
Top10 AS (
    SELECT total_vendas
    FROM TotalPorLivro
    ORDER BY total_vendas DESC
    LIMIT 10
)
SELECT
    SUM(Top10.total_vendas) * 100.0 /
    (
        SELECT SUM(total_vendas)
        FROM TotalPorLivro
    ) AS percentual_vendas_top_10
FROM Top10;



-- 19. Quais autores venderam mais livros do que a média de vendas por autor?
-- 1. Calcular o total de vendas de cada autor.
-- 2. Calcular a média desses totais.
-- 3. Retornar os autores acima dessa média.
SELECT nome_autor, SUM(quantidade_de_vendas) AS total_vendas
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
JOIN autores ON autores.id_autor = livros.id_autor
GROUP BY nome_autor
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
)
ORDER BY total_vendas DESC;



-- CLASSIFICAÇÃO DOS LIVROS


-- Classifique cada livro de acordo com sua melhor posição alcançada:
-- 1 a 10    → Top 10
-- 11 a 15   → Top 15
-- 16 ou pior → Abaixo do Top 15
SELECT nome_livro, MIN(posicao_ranking) AS melhor_posicao,
    CASE
        WHEN MIN(posicao_ranking) <= 10 THEN 'Top 10'
        WHEN MIN(posicao_ranking) <= 15 THEN 'Top 15'
        ELSE 'Abaixo do Top 15'
    END AS classificacao
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
ORDER BY melhor_posicao;



-- CONSISTÊNCIA NO RANKING

-- Quais livros apresentaram maior consistência,
-- permanecendo no ranking durante todos os períodos?
SELECT nome_livro, COUNT(DISTINCT periodo_inicio) AS quantidade_periodos
FROM vendas
JOIN livros ON livros.id_livro = vendas.id_livro
GROUP BY nome_livro
HAVING COUNT(DISTINCT periodo_inicio) = 7
ORDER BY nome_livro;

