CREATE SCHEMA agencia AUTHORIZATION postgres;
SET search_path TO agencia;

-----------------------------------------------

CREATE TABLE agencia (
	nome 	VARCHAR(15),
	cidade VARCHAR(20) NOT NULL,
	estado VARCHAR(15) NOT NULL,
	CONSTRAINT pkagencia PRIMARY KEY (nome), 
);



CREATE TABLE funcionarios(
	num_funcional	INT,
	nome 			VARCHAR(45) NOT NULL,
	telefone		VARCHAR(20),
	data_admissao 	DATE DEFAULT current_date,
	agencia	VARCHAR(15),
	num_superv INT,
	CONSTRAINT pkfuncionarios PRIMARY KEY(num_funcional),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON NO ACTION,
	CONSTRAINT fkfuncionarios FOREIGN KEY(num_superv) REFERENCES funcionarios(num_funcional) ON DELETE SET NULL,
);

CREATE TABLE dependentes(
	nome VARCHAR(45),
	num_funcionario INT,
	CONSTRAINT pkdependentes PRIMARY KEY(nome,num_funcionario),
	CONSTRAINT fkfuncionarios FOREIGN KEY(num_funcionario) REFERENCES funcionarios(num_funcional) ON DELETE CASCADE,
);

CREATE SEQUENCE seqCliente START 0 INCREMENT BY 1;

CREATE TABLE cliente(
	id_cliente INT DEFAULT NEXTVAL(seqCliente),
	nome VARCHAR(30) NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	data_nasc DATE,
	endereco VARCHAR(30),
	cidade VARCHAR(20),
	estado VARCHAR(15),
	n_gerente INT,
	CONSTRAINT pkcliente PRIMARY KEY(id_cliente),
	CONSTRAINT fkfuncionarios FOREIGN KEY(n_gerente) REFERENCES funcionarios(num_funcional) ON DELETE NO ACTION,
);

CREATE SEQUENCE seqConta START 0 INCREMENT BY 1;
-- Criar Store Procedure para inserir conta

CREATE TABLE conta (
	id_conta INT,
	agencia VARCHAR(15),
	saldo DOUBLE DEFAULT 0.0,
	ult_alteracao DATE DEFAULT current_date,
	tipo_conta VARCHAR(15) DEFAULT 'CORRENTE',
	CONSTRAINT pkconta PRIMARY KEY(id_conta,agencia),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON DELETE NO ACTION,
	CHECK(saldo>=0.0), 
);

CREATE TABLE poupanca(
	id_conta INT,
	agencia VARCHAR(15),
	TAXA_JUROS DOUBLE NOT NULL,
	CONSTRAINT pkpoupanca PRIMARY KEY(id_conta,agencia),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE NO ACTION,
);

CREATE TABLE corrente (
	id_conta INT,
	agencia VARCHAR(15),
	tarifa_mensal DOUBLE DEFAULT 0.5,
	CONSTRAINT pkcorrente PRIMARY KEY(agencia,id_conta),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE NO ACTION,
);

CREATE SEQUENCE seqEmprestimo START WITH 0 INCREMENT BY 1;

CREATE TABLE emprestimo(
	id_Emprestimo INT DEFAULT NEXTVAL(seqEmprestimo),
	valor DOUBLE NOT NULL,
	n_parcelas INT,
	agencia VARCHAR(15) NOT NULL,
	CONSTRAINT pkemprestimo PRIMARY KEY(id_emprestimo),
	CONSTRAINT fkagencia FOREIGN KEY(agencia) REFERENCES agencia(nome) ON DELETE NO ACTION, 
);

CREATE SEQUENCE seqOperacao START WITH 0 INCREMENT BY 1;

CREATE TABLE operacao(
	id_operacao	INT DEFAULT NEXTVAL(seqOperacao),
	agencia VARCHAR(15),
	id_conta INT,
	valor DOUBLE DEFAULT 0.0,
	descricao VARCHAR(45) NOT NULL,
	data DATE DEFAULT current_date,
	id_cupom INT UNIQUE,
	CONSTRAINT pkoperacao PRIMARY KEY(id_operacao,agencia,id_conta),
	CONSTRAINT fkcorrente FOREIGN KEY(agencia,id_conta) REFERENCES corrente(agencia,id_conta) ON DELETE CASCADE,
);

CREATE TABLE conta_cliente(
	id_cliente INT,
	agencia VARCHAR(15),
	id_conta INT,
	data_criacao DATE DEFAULT current_date,
	CONSTRAINT pkconta_cliente PRIMARY KEY(id_cliente,agencia,id_conta),
	CONSTRAINT fkconta FOREIGN KEY(agencia,id_conta) REFERENCES conta(agencia,id_conta) ON DELETE CASCADE,
);


CREATE TABLE emprestimo_cliente (
	id_cliente INT,
	id_emprestimo INT,
	CONSTRAINT pkemprestimo_cliente PRIMARY KEY(id_cliente,id_emprestimo),
	CONSTRAINT fkemprestimo FOREIGN KEY(id_emprestimo) REFERENCES emprestimo(id_emprestimo) ON DELETE CASCADE,
	CONSTRAINT fkcliente FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente) ON DELETE NO ACTION,
);


CREATE TABLE cupom ( 
	id_cupom INT, 
	validade DATE DEFAULT current_date,
	id_conta INT,
	agencia VARCHAR(15)
	id_operacao INT,
	CONSTRAINT pkcupom PRIMARY KEY(id_cupom),
	CONSTRAINT fkoperacao FOREIGN KEY(id_conta,agencia,id_operacao) REFERENCES operacao(id_conta,agencia,id_operacao) ON DELETE SET NULL,
);










