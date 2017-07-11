/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package DAO;

import CLASS.Agencia;
import CLASS.Cupom;
import CLASS.Funcionario;
import java.util.ArrayList;

/**
 *
 * @author Gustavo
 */
public interface AgenciaDAO {
    public ArrayList<Cupom> getAllCupons();
    public Boolean insertAgencia(Agencia a);
    public void deleteAgencia(String nome);
    public Boolean insertConta(String id_cliente,String data,String agencia,String saldo,String tartax,String tipo);
    public ArrayList<Funcionario> getAllFuncionarios();
    public void delete(String del);
   
}
