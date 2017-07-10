/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import CLASS.Agencia;
import CLASS.Cliente;
import java.util.ArrayList;

/**
 *
 * @author gustavo
 */
public interface ClienteDAO {
    
    public ArrayList<Cliente> getAllClientes(String estado,String cidade);
    public Boolean insertcliente(String nome, String cpf, String nasc, String endereco, String cidade, String estado, String n_gerente);
    public void deleteCliente(String nome);
    public Boolean efetuaOperacao(String id_conta,String agencia, String valor, String tipo);
    
}
