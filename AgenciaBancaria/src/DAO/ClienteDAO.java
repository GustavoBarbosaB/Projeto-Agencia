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
    
    public ArrayList<Cliente> getAllContasClientes(String estado,String cidade);
    public ArrayList<Cliente> getAllClientes();
    public Boolean insertcliente(String nome, String cpf, String nasc, String endereco, String cidade, String estado, String n_gerente);
    public void deleteCliente(String nome);
    public Boolean efetuaOperacao(String id_conta,String agencia, String valor, String tipo);
    
}
