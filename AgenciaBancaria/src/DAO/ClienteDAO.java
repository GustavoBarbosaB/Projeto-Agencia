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
    
    public ArrayList<Cliente> getAllClientes(String estado);
    public Boolean insertcliente(Agencia a);
    public void deleteCliente(String nome);
    
}
