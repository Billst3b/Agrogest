package mz.ac.istcem.agrogest.repo;

import mz.ac.istcem.agrogest.model.*;
import java.io.Serializable;
import java.util.*;

public class EstadoSistema implements Serializable {
    private static final long serialVersionUID = 1L;
    public List<Utilizador> utilizadores = new ArrayList<>();
    public List<Fornecedor> fornecedores = new ArrayList<>();
    public List<Produto> produtos = new ArrayList<>();
    public List<Campanha> campanhas = new ArrayList<>();
    public List<Cultivo> cultivos = new ArrayList<>();
    public List<Colheita> colheitas = new ArrayList<>();
    public List<Venda> vendas = new ArrayList<>();
    public int idUtilizador = 1, idFornecedor = 1, idProduto = 1;
    public int idCampanha = 1, idCultivo = 1, idColheita = 1, idVenda = 1;
    public int numeroFactura = 1;
}
