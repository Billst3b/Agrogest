package mz.ac.istcem.agrogest.repo;

import mz.ac.istcem.agrogest.model.*;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

public class DataStore {
    private static final DataStore INSTANCE = new DataStore();
    public static DataStore getInstance() { return INSTANCE; }

    public final List<Utilizador> utilizadores = Collections.synchronizedList(new ArrayList<>());
    public final List<Fornecedor> fornecedores = Collections.synchronizedList(new ArrayList<>());
    public final List<Produto> produtos = Collections.synchronizedList(new ArrayList<>());
    public final List<Campanha> campanhas = Collections.synchronizedList(new ArrayList<>());
    public final List<Cultivo> cultivos = Collections.synchronizedList(new ArrayList<>());
    public final List<Colheita> colheitas = Collections.synchronizedList(new ArrayList<>());
    public final List<Venda> vendas = Collections.synchronizedList(new ArrayList<>());

    public final AtomicInteger idUtilizador = new AtomicInteger(1);
    public final AtomicInteger idFornecedor = new AtomicInteger(1);
    public final AtomicInteger idProduto = new AtomicInteger(1);
    public final AtomicInteger idCampanha = new AtomicInteger(1);
    public final AtomicInteger idCultivo = new AtomicInteger(1);
    public final AtomicInteger idColheita = new AtomicInteger(1);
    public final AtomicInteger idVenda = new AtomicInteger(1);
    public final AtomicInteger numeroFactura = new AtomicInteger(1);

    private DataStore() {}

    public synchronized Utilizador findUtilizadorByEmail(String email) {
        for (Utilizador u : utilizadores)
            if (u.getEmail().equalsIgnoreCase(email)) return u;
        return null;
    }
    public synchronized Produto findProduto(int id) {
        for (Produto p : produtos) if (p.getId() == id) return p;
        return null;
    }
    public synchronized Venda findVenda(int id) {
        for (Venda v : vendas) if (v.getId() == id) return v;
        return null;
    }

    public EstadoSistema toEstado() {
        EstadoSistema e = new EstadoSistema();
        e.utilizadores = new ArrayList<>(utilizadores);
        e.fornecedores = new ArrayList<>(fornecedores);
        e.produtos = new ArrayList<>(produtos);
        e.campanhas = new ArrayList<>(campanhas);
        e.cultivos = new ArrayList<>(cultivos);
        e.colheitas = new ArrayList<>(colheitas);
        e.vendas = new ArrayList<>(vendas);
        e.idUtilizador = idUtilizador.get(); e.idFornecedor = idFornecedor.get();
        e.idProduto = idProduto.get(); e.idCampanha = idCampanha.get();
        e.idCultivo = idCultivo.get(); e.idColheita = idColheita.get();
        e.idVenda = idVenda.get(); e.numeroFactura = numeroFactura.get();
        return e;
    }

    public synchronized void fromEstado(EstadoSistema e) {
        utilizadores.clear();  utilizadores.addAll(e.utilizadores);
        fornecedores.clear();  fornecedores.addAll(e.fornecedores);
        produtos.clear();      produtos.addAll(e.produtos);
        campanhas.clear();     campanhas.addAll(e.campanhas);
        cultivos.clear();      cultivos.addAll(e.cultivos);
        colheitas.clear();     colheitas.addAll(e.colheitas);
        vendas.clear();        vendas.addAll(e.vendas);
        idUtilizador.set(e.idUtilizador); idFornecedor.set(e.idFornecedor);
        idProduto.set(e.idProduto); idCampanha.set(e.idCampanha);
        idCultivo.set(e.idCultivo); idColheita.set(e.idColheita);
        idVenda.set(e.idVenda); numeroFactura.set(e.numeroFactura);
    }
}
