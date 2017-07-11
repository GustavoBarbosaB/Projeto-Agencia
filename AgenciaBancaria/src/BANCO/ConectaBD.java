/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package BANCO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class ConectaBD {
       
    
    public static void loadDrive () {
        try {
            Class.forName("org.postgresql.Driver");
        }catch (ClassNotFoundException cnfe) {
            System.out.println("Não foi possível achar o Driver!");
            cnfe.printStackTrace();
            System.exit(1);
        }
        System.out.println("Driver carregado com sucesso");
    }
    
    
    public static Connection getConnection () {
        Connection conn = null;
        
        try {
            System.out.println("Conectando com o servidor!");
            conn = DriverManager.getConnection("jdbc:postgresql://localhost:5432/agencia?currentSchema=agencia","postgres","root");
            System.out.println("Conectado!");            
            
        }catch (SQLException se) {
            System.out.println("Não foi possível conectar ao banco de dados.");
            se.printStackTrace();
        }
        
        return conn;
    }
    
    public static Boolean executeBD(String insert)
    {
        Connection conn = null;
        Statement st = null;
        try{
            conn = getConnection();
            st = conn.createStatement();
            st.executeUpdate(insert);
            st.close();
            conn.close();
            
        }catch(SQLException ex){
            System.out.print("Ocorreu um erro na inserção!\n");
            ex.printStackTrace();
            return false;
        }
        return true;
    }
    
    public static Boolean testaBD(String query)
    {
        Connection conn = null;
        Statement st = null;
        ResultSet rs;
        Boolean ret = true;
        try{
            conn = getConnection();
            st = conn.createStatement();
            rs = st.executeQuery(query);
            
            if(!rs.next())//não tem
               ret = false;
            
            st.close();
            conn.close();
            
        }catch(SQLException ex){
            System.out.print("Ocorreu um erro na busca!");
            ex.printStackTrace();
            return false;
        }
        return ret;
    }
    
    
}
