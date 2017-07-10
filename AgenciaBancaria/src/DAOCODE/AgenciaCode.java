/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOCODE;

import BANCO.ConectaBD;
import static BANCO.ConectaBD.getConnection;
import CLASS.Agencia;
import DAO.AgenciaDAO;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Gustavo
 */
public class AgenciaCode implements AgenciaDAO {
    
    String query;
    ResultSet rs;  
    Connection conn = null;
    Statement st = null;
    
    @Override
    public ArrayList<Agencia> getAllAgencia(String estado) {
        ArrayList<Agencia> agencias = new ArrayList<>();
        
                
        query = "SELECT * FROM agencia a "
                + "WHERE a.estado='"+estado+"';";
       
        
        try{
            conn = getConnection();
            st = conn.createStatement();
            rs = st.executeQuery(query);
            
            while(rs.next())
            {
                Agencia a = new Agencia();
                
                a.setNome(rs.getString("nome"));
                a.setCidade(rs.getString("cidade"));
                a.setEstado(rs.getString("estado"));
                
                agencias.add(a);
            }
            st.close();
            conn.close();
            
            for(Agencia a:agencias)
            {
                System.out.println("Agencia: "+a.getNome());
            }
           
                
        }catch(SQLException ex){
            System.out.println("Houve um erro "+ex);
            Logger.getLogger(AgenciaCode.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return agencias;
    }

    @Override
    public Boolean insertAgencia(Agencia a) {
                   
        query = "INSERT INTO agencia VALUES ('"+
                a.getNome()+"','"+
                a.getCidade()+"','"+
                a.getEstado()+"');";
                    
           if(ConectaBD.executeBD(query))
               return true;
                                          
        
        
        return false;
    }

    @Override
    public void deleteAgencia(String nome) {
        
    }

    @Override
    public Boolean insertConta(String id_cliente, String data, String agencia, String saldo, String tartax, String tipo) {
        query = "SELECT nova_conta("+id_cliente+",'"+data+"','"+agencia+"',"+saldo+",'"+tipo+"',"+tartax+");";
        
        try {
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            st.executeQuery(query);
            st.close();
            conn.close();
            
        } catch (SQLException ex) {
            System.out.println("Erro ao tentar inserir Conta!");
            Logger.getLogger(ClienteCode.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
        return true;
    }
    
}
