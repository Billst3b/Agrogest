package mz.ac.istcem.agrogest.service;

import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.time.LocalDateTime;
import java.util.List;

public class VendaService {
    private final DataStore store = DataStore.getInstance();

    public synchronized Venda efetuarVenda(Cliente cliente, List<VendaItem> itens) {
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
        v.setNumeroFactura(String.format("FT-%04d", store.numeroFactura.getAndIncrement()));
        v.setClienteId(cliente.getId());
        v.setClienteNome(cliente.getNome());
        v.setClienteEndereco(cliente.getEndereco());
        v.setClienteTelefone(cliente.getTelefone());
        v.setData(LocalDateTime.now());
        v.setItens(itens);
        v.calcularTotais();
        store.vendas.add(v);
        return v;
    }
}
