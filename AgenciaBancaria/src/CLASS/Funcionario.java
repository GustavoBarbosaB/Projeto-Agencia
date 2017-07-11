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
public class Funcionario {

    public String getNum_funcional() {
        return num_funcional;
    }

    public void setNum_funcional(String num_funcional) {
        this.num_funcional = num_funcional;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getAgencia() {
        return agencia;
    }

    public void setAgencia(String agencia) {
        this.agencia = agencia;
    }
    
    private String num_funcional;
    private String nome;
    private String agencia;
    
}
