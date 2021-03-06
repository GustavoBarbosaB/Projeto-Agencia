/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOCODE;

import BANCO.ConectaBD;
import CLASS.Cliente;
import DAO.ClienteDAO;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**'
 *
 * @author gustavo
 */
public class ClienteCode implements ClienteDAO{
    String query=null;
    ResultSet rs=null;
    Connection conn = null;
    Statement st = null;
    
    
    
    @Override
    public ArrayList<Cliente> getAllContasClientes(String estado, String cidade) {
        
        ArrayList<Cliente> clientes = null;
       
        
        if(cidade.equals("")){
            if(estado.equals("")){
                query = "SELECT * FROM cliente c,conta_cliente cc,conta ct WHERE ct.id_conta=cc.id_conta AND ct.agencia=cc.agencia AND c.id_cliente=cc.id_cliente;";
            }else
                query = "SELECT * FROM cliente c,conta_cliente cc,conta ct WHERE ct.id_conta=cc.id_conta AND ct.agencia=cc.agencia AND c.id_cliente=cc.id_cliente AND UPPER(c.estado) ILIKE '%"+estado+"%';";   
        
        }else if(estado.equals("")){
            query = "SELECT * FROM cliente c,conta_cliente cc,conta ct WHERE ct.id_conta=cc.id_conta AND ct.agencia=cc.agencia AND c.id_cliente=cc.id_cliente AND UPPER(c.cidade) ILIKE '%"+cidade+"%';";
        }else
            query = "SELECT * FROM cliente c,conta_cliente cc,conta ct WHERE ct.id_conta=cc.id_conta AND ct.agencia=cc.agencia AND c.id_cliente=cc.id_cliente AND UPPER(c.cidade) ILIKE '%"+cidade+"%' AND UPPER(c.estado) ILIKE '%"+estado+"%';";
               
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
                c.setTipo(rs.getString("tipo_conta"));
                c.setId_conta(rs.getString("id_conta"));
                c.setAgencia(rs.getString("agencia"));
                c.setGerente(rs.getString("n_gerente"));
                
                
               
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
    public Boolean insertcliente(String nome, String cpf, String nasc, String endereco, String cidade, String estado, String n_gerente) {
        
        if(n_gerente.equals(""))
            query = "INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado)"
                    + " VALUES ('"+nome+"','"+cpf+"','"+nasc+"','"+endereco+"','"+cidade+"','"+estado+"');";
        else
            query = "INSERT INTO cliente(nome,cpf,data_nasc,endereco,cidade,estado,n_gerente)"
                    + " VALUES ('"+nome+"','"+cpf+"','"+nasc+"','"+endereco+"','"+cidade+"','"+estado+"',"+n_gerente+");";
                
                
        try {
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            st.executeUpdate(query);
            st.close();
            conn.close();
            
        } catch (SQLException ex) {
            System.out.println("Erro ao tentar inserir Cliente!");
            Logger.getLogger(ClienteCode.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
        return true;
    }

    @Override
    public void deleteCliente(String nome) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Boolean efetuaOperacao(String id_conta, String agencia, String valor, String tipo) {
        if(tipo.equals("DEPOSITO"))
            query = "SELECT operacao("+id_conta+",'"+agencia+"',"+valor+",'DEPOSITO');";
        else if(tipo.equals("SAQUE"))
            query = "SELECT operacao("+id_conta+",'"+agencia+"',"+valor+",'SAQUE');";
        
        try {
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            st.executeQuery(query);
            conn.close();
            st.close();
            
        } catch (SQLException ex) {
            System.out.println("Erro ao efetuar operação!");
            Logger.getLogger(ClienteCode.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
        
        return true;
    }

    @Override
    public ArrayList<Cliente> getAllClientes() {
       
        ArrayList<Cliente> clientes = null;
        
        try {
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            rs = st.executeQuery("SELECT * FROM cliente;");
            
            clientes = new ArrayList<>();
            Cliente c;
            
            while(rs.next())
            {
                c = new Cliente();
                c.setId_cliente(rs.getString("id_cliente"));
                c.setNome(rs.getString("nome"));
                c.setCidade(rs.getString("cidade"));
                c.setEstado(rs.getString("estado"));
                c.setGerente(rs.getString("n_gerente"));
               
                clientes.add(c);
            }         
           
            st.close();
            conn.close();
            
        } catch (SQLException ex) {
            Logger.getLogger(ClienteCode.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return clientes;
    }
    
    
    
}
