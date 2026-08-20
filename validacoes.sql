-- Selecionando as tabelas pra verificar se as informações foram inseridas da forma correta. 
SELECT * FROM autores;
SELECT * FROM editoras;
SELECT * FROM categorias;
SELECT * FROM livros;
SELECT * FROM vendas;


-- Selecionando as linhas das tabelas e contando quantas são, para validarmos se a quantidade de dados está correta.
SELECT COUNT(*) FROM livros;
SELECT COUNT(*) FROM autores;
SELECT COUNT(*) FROM editoras;
SELECT COUNT(*) FROM categorias;
SELECT COUNT(*) FROM vendas;



