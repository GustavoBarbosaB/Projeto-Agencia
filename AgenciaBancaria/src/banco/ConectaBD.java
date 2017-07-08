/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package banco;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author esdraschaves
 */
public class ConectaBD {
    Connection conexao = null;
    Statement sentenca;
    String query = "set search_path to agencia";
    
    
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
        Connection conexao = null;
        
        try {
            System.out.println("Conectando com o servidor!");
            //String url = ;
            conexao = DriverManager.getConnection("jdbc:postgresql://localhost:5433/agencia","postgres","root");
            System.out.println("Conectado!");
            
        }catch (SQLException se) {
            System.out.println("Não foi possível conectar ao banco de dados.");
            se.printStackTrace();
        }
        
        return conexao;
    }
}
