/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOCODE;

import BANCO.ConectaBD;
import CLASS.Agencia;
import CLASS.Cliente;
import DAO.ClienteDAO;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author gustavo
 */
public class ClienteCode implements ClienteDAO{
    String query=null;
    ResultSet rs=null;
    
    
    @Override
    public ArrayList<Cliente> getAllClientes(String estado, String cidade) {
        Connection conn = null;
        Statement st = null;
        ArrayList<Cliente> clientes = null;
        String query = "SELECT * FROM cliente c,conta_cliente cc,conta ct WHERE ct.id_conta=cc.id_conta AND ct.agencia=cc.agencia AND c.id_cliente=cc.id_cliente AND UPPER(c.cidade)='"+cidade+"' AND UPPER(c.estado)='"+estado+"';";
               
        try {
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            rs = st.executeQuery(query);
            
            clientes = new ArrayList<>();
            Cliente c;
            
            while(rs.next())
            {
                c = new Cliente();
                c.setId_cliente(rs.getString("id_cliente"));
                c.setNome(rs.getString("nome"));
                c.setCidade(rs.getString("cidade"));
                c.setEstado(rs.getString("estado"));
                c.setSaldo(rs.getString("saldo"));
               
                clientes.add(c);
            }         
           
            st.close();
            conn.close();
            
        } catch (SQLException ex) {
            Logger.getLogger(ClienteCode.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return clientes;
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
