/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAOCODE;

import BANCO.ConectaBD;
import CLASS.Agencia;
import DAO.AgenciaDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
    private Connection conn;
    Statement st;
    String query;
    ResultSet rs;
    
    
    @Override
    public ArrayList<Agencia> getAllAgencia(String estado) {
        ArrayList<Agencia> agencias = new ArrayList<>();
                
        query = "SELECT * FROM agencia a "
                + "WHERE a.estado="+estado+";";
       
        
        try{
            conn = ConectaBD.getConnection();
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
        
        
        try {
            
            conn = ConectaBD.getConnection();
            st = conn.createStatement();
            
            st.executeUpdate(query);
            
            st.close();
            conn.close();
                                  
        } catch (SQLException ex) {
            System.out.println("Houve um erro "+ex);
            Logger.getLogger(AgenciaCode.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
        
        return true;
    }

    @Override
    public void deleteAgencia(String nome) {
        
    }
    
}
