/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOCODE;

import CLASS.Agencia;
import CLASS.Cliente;
import DAO.ClienteDAO;
import java.sql.ResultSet;
import java.util.ArrayList;

/**
 *
 * @author gustavo
 */
public class ClienteCode implements ClienteDAO{
    String query=null;
    ResultSet rs=null;
    
    @Override
    public ArrayList<Cliente> getAllClientes(String estado) {
            
        
    }

    @Override
    public Boolean insertcliente(Agencia a) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void deleteCliente(String nome) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
