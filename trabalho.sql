CREATE SCHEMA agencia AUTHORIZATION postgres;
SET search_path TO agencia;

-----------------------------------------------

CREATE TABLE agencia {
	nome 	VARCHAR(15)
	cidade VARCHAR(20)
	estado VARCHAR(15)
	CONSTRAINT pkagencia PRIMMARY KEY (nome) 
}

CREATE TABLE emprestimo{
	idEmprestimo INT
	n_parcelas INT 
	valor DOUBLE
	agencia_nome VARCHAR(15)
}

CREATE TABLE conta {
	idConta INT
	saldo FLOAT
	data_ultimo_acesso 
}

CREATE TABLE cliente_emprestimo {
	cliente_idcliente INT
	Emprestimo_idEmprestimo INT
}

CREATE TABLE cliente_conta{
	id_cliente INT
	id_conta INT
	agencia_nome VARCHAR()
	data_criacao DATE
}

CREATE TABLE cliente{
	id_cliente INT
	nome VARCHAR(30)
	cpf VARCHAR(11)
	data_nasc DATE
	endereco VARCHAR(30)
	cidade VARCHAR(20)
	estado VARCHAR(15)
	num_supervisor INT
}

CREATE TABLE funcionarios{
	num_funcional	INT
	telefone		VARCHAR(20)
	nome 			VARCHAR(45)
	data_admissao 	DATE
	agencia_nome	VARCHAR(15)
	num_supervisor INT
}

CREATE TABLE dependentes{
	nome INT
	num_funcionario INT
}

CREATE TABLE poupanca{
	id_conta INT
	agencia_nome VARCHAR(15)
	TAXA_JUROS DOUBLE
}

CREATE TABLE corrente {
	conta_
}

