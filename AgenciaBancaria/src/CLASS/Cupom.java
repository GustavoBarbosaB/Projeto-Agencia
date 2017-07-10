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
public class Cupom {

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getValidade() {
        return validade;
    }

    public void setValidade(String validade) {
        this.validade = validade;
    }

    public String getId_conta() {
        return id_conta;
    }

    public void setId_conta(String id_conta) {
        this.id_conta = id_conta;
    }

    public String getAgencia() {
        return agencia;
    }

    public void setAgencia(String agencia) {
        this.agencia = agencia;
    }

    public String getId_operacao() {
        return id_operacao;
    }

    public void setId_operacao(String id_operacao) {
        this.id_operacao = id_operacao;
    }
    String id;
    String validade;
    String id_conta;
    String agencia;
    String id_operacao;
        
}
