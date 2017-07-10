/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package CLASS;

/**
 *
 * @author gustavo
 */
public class Cliente {
    
    private String id_cliente;
    private String nome;
    private String cpf;
    private String cidade;
    private String n_gerente;
    private String agencia;
    private String id_conta;
    private String criacao;
    private String tipo;

    public String getAgencia() {
        return agencia;
    }

    public void setAgencia(String agencia) {
        this.agencia = agencia;
    }

    public String getId_conta() {
        return id_conta;
    }

    public void setId_conta(String id_conta) {
        this.id_conta = id_conta;
    }

    public String getCriacao() {
        return criacao;
    }

    public void setCriacao(String criacao) {
        this.criacao = criacao;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
  
    
    public String getId_cliente() {
        return id_cliente;
    }

    public void setId_cliente(String id_cliente) {
        this.id_cliente = id_cliente;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public String getN_gerente() {
        return n_gerente;
    }

    public void setN_gerente(String n_gerente) {
        this.n_gerente = n_gerente;
    }
       
    
}
