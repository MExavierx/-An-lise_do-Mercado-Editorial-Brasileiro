/* Criando as nossas tabelas 
	1. autores pra armazenar o nome do autor, o id pode ser auto incrementado, porque já foi selecionado em ordem alfábetica 
    2. editoras pra armazenar o nome das editoras, e o id segue o mesmo raciocínio 
    3. categorias pra armazenar o tipo de categoria dos livros encontrados
    4. livros pra armazenar o nome do livro e como nossas chaves estrangeiras tem os IDs dos autores, editoras e categorias. 
    5. vendas pra armazenar os livros que serão vendidos. 
    
 OBS: Os nossos dados foram definidos por 7 períodos
	-> começo: 30/06
	-> final:  17/08
	-> total: 1 mês e 18 dias
 
*/

CREATE TABLE autores (
    id_autor INTEGER PRIMARY KEY AUTOINCREMENT, 
    nome_autor VARCHAR(100) NOT NULL
);

CREATE TABLE editoras (
    id_editora INTEGER PRIMARY KEY AUTOINCREMENT, 
    nome_editora VARCHAR(50) NOT NULL 
);

CREATE TABLE categorias (
    id_categoria INTEGER PRIMARY KEY AUTOINCREMENT, 
    nome_categoria VARCHAR(50) NOT NULL 
);

CREATE TABLE livros (
    id_livro INTEGER PRIMARY KEY AUTOINCREMENT, 
    nome_livro VARCHAR(50),
    id_autor INT, 
    id_editora INT, 
    id_categoria INT, 
  
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_editora) REFERENCES editoras(id_editora), 
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE vendas (
    id_venda INTEGER PRIMARY KEY AUTOINCREMENT, 
    id_livro INT,
  	periodo_inicio DATE NOT NULL, 
  	periodo_final DATE NOT NULL, 
  	posicao_ranking INTEGER, 
  	quantidade_de_vendas INTEGER NOT NULL, 
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro) 
);
