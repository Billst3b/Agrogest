package mz.ac.istcem.agrogest.service;

import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.time.LocalDateTime;
import java.util.List;

public class VendaService {
    private final DataStore store = DataStore.getInstance();

    /**
     * Sincroniza no singleton DataStore (lock global partilhado por todas as
     * instâncias de VendaService e pelo ProdutoServlet), garantindo que duas
     * vendas simultâneas nunca deixam o stock negativo.
     */
    public Venda efetuarVenda(Cliente cliente, List<VendaItem> itens) {
        synchronized (store) {
            Venda v = efetuarVendaInterno(cliente, itens);
            PersistenciaUtil.gravar();
            return v;
        }
    }

    private Venda efetuarVendaInterno(Cliente cliente, List<VendaItem> itens) {
        if (itens == null || itens.isEmpty())
            throw new IllegalStateException("Carrinho vazio");
        for (VendaItem item : itens) {
            Produto p = store.findProduto(item.getProdutoId());
            if (p == null || p.getQuantidade() < item.getQuantidade())
                throw new IllegalStateException("Stock insuficiente para: " + item.getProdutoNome());
        }
        for (VendaItem item : itens) {
            Produto p = store.findProduto(item.getProdutoId());
            p.setQuantidade(p.getQuantidade() - item.getQuantidade());
        }
        Venda v = new Venda();
        v.setId(store.idVenda.getAndIncrement());
        LocalDateTime agora = LocalDateTime.now();
        v.setNumeroFactura("FT-" + agora.getYear() + "-" + store.numeroFactura.getAndIncrement());
        v.setClienteId(cliente.getId());
        v.setClienteNome(cliente.getNome());
        v.setClienteEndereco(cliente.getEndereco());
        v.setClienteTelefone(cliente.getTelefone());
        v.setData(agora);
        v.setItens(itens);
        v.calcularTotais();
        store.vendas.add(v);
        return v;
    }
}
