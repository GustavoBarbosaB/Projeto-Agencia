CREATE SCHEMA agencia AUTHORIZATION postgres;
SET search_path TO agencia;

-----------------------------------------------

CREATE TABLE agencia (
	nome 	VARCHAR(15),
	cidade VARCHAR(20) NOT NULL,
	estado VARCHAR(15) NOT NULL,
	CONSTRAINT pkagencia PRIMARY KEY (nome)
);



CREATE TABLE funcionarios(
	num_funcional	INT,
	nome 			VARCHAR(45) NOT NULL,
	telefone		VARCHAR(20),
	data_admissao 	DATE DEFAULT current_date,
	agencia	VARCHAR(15),
	num_superv INT,
	CONSTRAINT pkfuncionarios PRIMARY KEY(num_funcional),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON DELETE NO ACTION,
	CONSTRAINT fkfuncionarios FOREIGN KEY(num_superv) REFERENCES funcionarios(num_funcional) ON DELETE SET NULL
);

CREATE TABLE dependentes(
	nome VARCHAR(45),
	num_funcionario INT,
	CONSTRAINT pkdependentes PRIMARY KEY(nome,num_funcionario),
	CONSTRAINT fkfuncionarios FOREIGN KEY(num_funcionario) REFERENCES funcionarios(num_funcional) ON DELETE CASCADE
);

CREATE SEQUENCE seqCliente START 1 INCREMENT BY 1;

CREATE TABLE cliente(
	id_cliente INT DEFAULT NEXTVAL('seqCliente'),
	nome VARCHAR(30) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	data_nasc DATE,
	endereco VARCHAR(30),
	cidade VARCHAR(20),
	estado VARCHAR(15),
	n_gerente INT,
	CONSTRAINT pkcliente PRIMARY KEY(id_cliente),
	CONSTRAINT fkfuncionarios FOREIGN KEY(n_gerente) REFERENCES funcionarios(num_funcional) ON DELETE NO ACTION
);

CREATE SEQUENCE seqConta START 1 INCREMENT BY 1;
-- Criar Store Procedure para inserir conta

CREATE TABLE conta (
	id_conta INT DEFAULT NEXTVAL('seqConta'),
	agencia VARCHAR(15),
	saldo NUMERIC(30,2) DEFAULT 0.0,
	ult_alteracao DATE DEFAULT current_date,
	tipo_conta VARCHAR(15) DEFAULT 'CORRENTE',
	CONSTRAINT pkconta PRIMARY KEY(id_conta,agencia),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON DELETE NO ACTION
);

CREATE TABLE poupanca(
	id_conta INT,
	agencia VARCHAR(15),
	taxa_juros NUMERIC(2,2) NOT NULL DEFAULT 0.00,
	CONSTRAINT pkpoupanca PRIMARY KEY(id_conta,agencia),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE NO ACTION
);

CREATE TABLE corrente (
	id_conta INT,
	agencia VARCHAR(15),
	tarifa_mensal NUMERIC(2,2) DEFAULT 0.5,
	CONSTRAINT pkcorrente PRIMARY KEY(agencia,id_conta),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE NO ACTION
);

CREATE SEQUENCE seqEmprestimo START WITH 1 INCREMENT BY 1;

CREATE TABLE emprestimo(
	id_Emprestimo INT DEFAULT NEXTVAL('seqEmprestimo'),
	valor NUMERIC(30,2) NOT NULL,
	n_parcelas INT,
	agencia VARCHAR(15) NOT NULL,
	CONSTRAINT pkemprestimo PRIMARY KEY(id_emprestimo),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON DELETE NO ACTION
);

CREATE SEQUENCE seqOperacao START WITH 1 INCREMENT BY 1;

CREATE TABLE operacao(
	id_operacao INT DEFAULT NEXTVAL('seqOperacao'),
	agencia VARCHAR(15),
	id_conta INT,
	valor NUMERIC(30,2) DEFAULT 0.0,
	descricao VARCHAR(45) NOT NULL,
	data DATE DEFAULT current_date,
	CONSTRAINT pkoperacao PRIMARY KEY(id_operacao,agencia,id_conta),
	CONSTRAINT fkcorrente FOREIGN KEY(agencia,id_conta) REFERENCES corrente(agencia,id_conta) ON DELETE CASCADE
);

CREATE TABLE conta_cliente(
	id_cliente INT,
	agencia VARCHAR(15),
	id_conta INT,
	data_criacao DATE DEFAULT current_date,
	CONSTRAINT pkconta_cliente PRIMARY KEY(id_cliente,agencia,id_conta),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE CASCADE
);


CREATE TABLE emprestimo_cliente (
	id_cliente INT,
	id_emprestimo INT,
	CONSTRAINT pkemprestimo_cliente PRIMARY KEY(id_cliente,id_emprestimo),
	CONSTRAINT fkemprestimo FOREIGN KEY(id_emprestimo) REFERENCES emprestimo(id_emprestimo) ON DELETE CASCADE,
	CONSTRAINT fkcliente FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente) ON DELETE NO ACTION
);

CREATE TABLE cupom ( 
	id_cupom SERIAL, 
	validade DATE DEFAULT current_date,
	id_conta INT NOT NULL,
	agencia VARCHAR(15) NOT NULL,
	id_operacao INT NOT NULL,
	CONSTRAINT pkcupom PRIMARY KEY(id_cupom),
	CONSTRAINT fkoperacao FOREIGN KEY(id_conta,agencia,id_operacao) REFERENCES operacao(id_conta,agencia,id_operacao) ON DELETE NO ACTION
);
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------- STORED PROCEDURES ---------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

/*
	Esta funçõa cria uma nova conta, para isto
	basta passar como argumento os dados do cliente, da agencia e conta.
	OBS: para usa-la é necessário ter o cliente e a agencia já cadastrados.
*/

CREATE OR REPLACE FUNCTION nova_conta(id_cliente INT, data_criacao DATE, agencia VARCHAR(15), saldo NUMERIC(30,2), tipo_conta VARCHAR(15), tarifa_ou_taxa NUMERIC(2,2)) 
RETURNS void AS $$
DECLARE id_conta INT;
BEGIN
	
	INSERT INTO conta(agencia,saldo,tipo_conta) 
		VALUES (agencia,saldo,tipo_conta);
	
	id_conta:=CURRVAL('seqConta');
	
	IF UPPER(tipo_conta)='CORRENTE' THEN
		INSERT INTO corrente 
			VALUES (id_conta,agencia,tarifa_ou_taxa);
	ELSEIF UPPER(tipo_conta)='POUPANCA' THEN
		INSERT INTO poupanca 	
			VALUES (id_conta,agencia,tarifa_ou_taxa);
	END IF;
	
	INSERT INTO conta_cliente VALUES (id_cliente,agencia,id_conta,data_criacao);
	

END
$$ LANGUAGE plpgsql;

/*
	Esta funçõa cria uma nova conta, para isto
	basta passar como argumento os dados do cliente, da agencia e conta.
	OBS: para usa-la é necessário ter o cliente e a agencia já cadastrados.
*/

CREATE OR REPLACE FUNCTION operacao(id_contaAux INT,agenciaAux VARCHAR(15),valor NUMERIC(30,2),tipo VARCHAR(10)) 
RETURNS void AS $$
BEGIN
	IF (UPPER(tipo)='DEPOSITO') THEN
	INSERT INTO operacao(agencia,id_conta,valor,descricao,data) 
		VALUES (agenciaAux,id_contaAux,valor,'DEPOSITO',current_date);

	UPDATE conta 
		SET saldo=saldo+valor 
			WHERE id_conta=id_contaAux AND agencia=agenciaAux;

	ELSEIF(UPPER(tipo)='SAQUE') THEN
	INSERT INTO operacao(agencia,id_conta,valor,descricao,data) 
		VALUES (agenciaAux,id_contaAux,valor,'SAQUE',current_date);

	UPDATE conta 
		SET saldo=saldo-valor 
			WHERE id_conta=id_contaAux AND agencia=agenciaAux;
	END IF;
END
$$ LANGUAGE plpgsql;
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------- TRIGGER -------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

/*
	Este TRIGGER tem a função de criar um cupom sempre que há
	uma operação acima de R$5000,00.

*/

CREATE OR REPLACE FUNCTION cria_cupom()
RETURNS trigger AS 
$$
BEGIN
	IF (new.valor >=5000.00)THEN
		INSERT INTO cupom(validade,id_conta,agencia,id_operacao) 
			VALUES (new.data+30,new.id_conta,new.agencia,new.id_operacao);
	END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER cupom_trigger AFTER 
	INSERT ON operacao FOR EACH ROW EXECUTE PROCEDURE cria_cupom();

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------- INSERÇÕES -----------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------


INSERT INTO agencia (nome,cidade,estado) VALUES ('Itamarati','São Paulo','SP');
INSERT INTO agencia (nome,cidade,estado) VALUES ('Jaburu' ,'Belo Horizonte', 'MG');
INSERT INTO agencia (nome,cidade,estado) VALUES ('Santos Drummond','Ribeirao Preto','SP');
INSERT INTO agencia (nome,cidade,estado) VALUES ('Pitangueiras','São Paulo','SP');
INSERT INTO agencia (nome,cidade,estado) VALUES ('Getulio Vargas','Rio de Janeiro','RJ');

INSERT INTO emprestimo(valor,n_parcelas,agencia) VALUES (750.00,3,'Santos Drummond');
INSERT INTO emprestimo(valor,n_parcelas,agencia) VALUES (1500.00,2,'Itamarati');
INSERT INTO emprestimo(valor,n_parcelas,agencia) VALUES (12000.00,5,'Itamarati');
INSERT INTO emprestimo(valor,n_parcelas,agencia) VALUES (2400.00,3,'Itamarati');
INSERT INTO emprestimo(valor,n_parcelas,agencia) VALUES (1500.00,2,'Pitangueiras');

INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (15232,01133074696,'João Vedrasco','Itamarati',15232);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (17263,01133074623,'Kleber Santana','Itamarati',15232);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (12364,01133864533,'João Santana', 'Itamarati',15232);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (72631,03434510983,'Gabriel Rodrigues' ,'Jaburu',72631);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (72342,03434510876,'Guilherme Becckerman','Jaburu',72631);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (32642,01133075244,'Joelma Da Cunha','Pitangueiras',32642);
INSERT INTO funcionarios(num_funcional,telefone,nome,agencia,num_superv) VALUES (52312,01633074455,'Luanna Costa','Santos Drummond',52312);

INSERT INTO dependentes (nome,num_funcionario) VALUES ('Carlos Pacheco',15232);
INSERT INTO dependentes (nome,num_funcionario) VALUES ('João Vedrasco Junior',15232);
INSERT INTO dependentes (nome,num_funcionario) VALUES ('Isadora Bottion',17263);
INSERT INTO dependentes (nome,num_funcionario) VALUES ('Mariana Costa',52312);
INSERT INTO dependentes (nome,num_funcionario) VALUES ('Jhon Becckerman',72342);

INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Guilherme Figueiredo','42159869821','2006/11/26','Alameda Pitangueiras','São Carlos','SP',52312);
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Lucas Varella' ,'45256231232','1994/03/21','Rua Antonio Carvalho', 'Ribeirão Preto','SP' ,52312);
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('André Riul' ,'52342143212','1964/06/25','Rua Maestral D', 'São Paulo','SP',17263);
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Giovanna Arcais','49582314502','1949/06/25','Avenida Prof Juvenilla','São Paulo','SP',12364);
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Daniel Outis' ,'39492394923','1977/03/17','Avenida Belarmino Pacheco', 'Belo Horizonte', 'MG',72631);
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Jorgin de lá','42152456320','1988/08/12','Avenida AIAI MEU GZUS' ,'São paulo','SP',32642) ;
INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Marco de sá','42523242312','1977/04/15','Avenida Santos do mar ','São Paulo','SP',32642);
INSERT INTO Cliente (nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Joesley Batista','92039294212','1963/08/19','Avenida oloro meu','Belo Horizonte','MG',72631);
INSERT INTO Cliente (nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Gustavo Barbosa','92039294222','04-10-1996','Avenida cisca dois','Araguari','MG',52312);
INSERT INTO Cliente (nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Bruno Barbosa','92039294222','04-10-1996','Avenida cisca dois','Araguari','MG',72631);
INSERT INTO Cliente (nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Vitor Basso','45039294222','04-12-1993','Rua Euripedes','Uberlandia','MG',17263);
INSERT INTO Cliente (nome,cpf,data_nasc,endereco,cidade,estado,n_gerente) VALUES ('Antonio Vilela','45039294222','03-11-1993','Rua Alameda 2','Uberlandia','MG',17263);


SELECT nova_conta(1,'20-06-2013','Santos Drummond',12000.00,'CORRENTE',0.2);
SELECT nova_conta(2,'21-06-2013','Itamarati',1500.00,'POUPANCA',0.2);
SELECT nova_conta(3,'22-06-2013','Pitangueiras',2000.00,'CORRENTE',0.2);
SELECT nova_conta(4,'20-06-2013','Jaburu',18000.00,'POUPANCA',0.2);
SELECT nova_conta(5,'24-06-2013','Itamarati',1485.00,'CORRENTE',0.2);
SELECT nova_conta(6,'20-06-2013','Pitangueiras',3698.00,'POUPANCA',0.2);
SELECT nova_conta(7,'20-06-2013','Jaburu',1300.00,'CORRENTE',0.2);
SELECT nova_conta(8,'26-06-2013','Itamarati',45.00,'POUPANCA',0.2);
SELECT nova_conta(9,'27-06-2013','Santos Drummond',894.00,'CORRENTE',0.2);
SELECT nova_conta(11,'23-06-2013','Pitangueiras',645.00,'POUPANCA',0.2);
SELECT nova_conta(12,'22-06-2013','Itamarati',369.00,'CORRENTE',0.2);
SELECT nova_conta(10,'22-05-2013','Pitangueiras',3639.00,'CORRENTE',0.2);

INSERT INTO emprestimo_cliente(id_cliente,id_emprestimo) VALUES (2,1);
INSERT INTO emprestimo_cliente(id_cliente,id_emprestimo) VALUES (3,2);
INSERT INTO emprestimo_cliente(id_cliente,id_emprestimo) VALUES (3,3);
INSERT INTO emprestimo_cliente(id_cliente,id_emprestimo) VALUES (4,4);
INSERT INTO emprestimo_cliente(id_cliente,id_emprestimo) VALUES (5,5);


SELECT deposito(1,'Santos Drummond',5900.00,'DEPOSITO'); --FAZER MAIS 4

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
----------------------------- CONSULTAS -----------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

--------------------- BÁSICAS ---------------------
SELECT * FROM cliente;
SELECT * FROM funcionarios;
SELECT * FROM operacao;
SELECT * FROM conta;
SELECT * FROM emprestimo;
SELECT * FROM conta_cliente;
SELECT * FROM agencia;
SELECT * FROM corrente;
SELECT * FROM poupanca;
SELECT * FROM emprestimo_cliente;
SELECT * FROM dependentes;
SELECT * FROM cupom;

--------------------- 5 CONSULTAS COM DUAS OU MAIS TABELAS --------------------- 



--------------------- 2 CONSULTAS COM AGREGAÇÃO E GROUP BY --------------------- 

--numero de conta por agencia
SELECT agencia.nome,COUNT (agencia.nome)
FROM agencia,conta
WHERE agencia.nome = conta.agencia
GROUP BY agencia.nome;

--numero de cliente por agencia
SELECT agencia.nome,COUNT (agencia.nome)
FROM agencia,cliente,conta_cliente
WHERE cliente.id_cliente = conta_cliente.id_cliente AND conta_cliente.agencia = agencia.nome
GROUP BY agencia.nome;

--numero de contas o cliente possui
SELECT cliente.nome,count(cliente.nome)
FROM cliente,conta_cliente
WHERE cliente.id_cliente = conta_cliente.id_cliente
GROUP BY cliente.nome;


--------------------- 2 CONSULTAS COM AGREGAÇÃO, GROUP BY E HAVING ---------------------
-- numero de contas por agencia. Listar somente agencias com mais de 2 contas;
SELECT a.nome, COUNT(*) 
FROM agencia a, conta_cliente cc
WHERE a.nome=cc.agencia
GROUP BY a.nome
HAVING COUNT(a.nome)>=2;

-- maior valor de emprestimo por agencia. Mostrar as agencia com mais de 2 emprestimos
-- Listar o nome da agencia e o maior valor emprestado.
SELECT e.agencia, MAX(valor) 
FROM emprestimo e
GROUP BY e.agencia
HAVING COUNT(e.agencia)>2;