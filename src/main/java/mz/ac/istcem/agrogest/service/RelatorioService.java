package mz.ac.istcem.agrogest.service;

import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.util.*;
import java.util.stream.Collectors;

public class RelatorioService {
    private final DataStore store = DataStore.getInstance();

    public List<Cliente> clientesOrdenadosPorNome() {
        return store.utilizadores.stream()
                .filter(u -> u instanceof Cliente).map(u -> (Cliente) u)
                .sorted(Comparator.comparing(Cliente::getNome, String.CASE_INSENSITIVE_ORDER))
                .collect(Collectors.toList());
    }
    public List<Map.Entry<Cliente, Double>> clientesPorVolume() {
        Map<Cliente, Double> mapa = new HashMap<>();
        for (Venda v : store.vendas) {
            Cliente c = (Cliente) store.utilizadores.stream()
                    .filter(u -> u.getId() == v.getClienteId()).findFirst().orElse(null);
            if (c != null) mapa.merge(c, v.getTotal(), Double::sum);
        }
        return mapa.entrySet().stream()
                .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
                .collect(Collectors.toList());
    }
    public List<Map.Entry<Cliente, Long>> clientesMaisAssiduos() {
        Map<Cliente, Long> mapa = new HashMap<>();
        for (Venda v : store.vendas) {
            Cliente c = (Cliente) store.utilizadores.stream()
                    .filter(u -> u.getId() == v.getClienteId()).findFirst().orElse(null);
            if (c != null) mapa.merge(c, 1L, Long::sum);
        }
        return mapa.entrySet().stream()
                .sorted((a, b) -> Long.compare(b.getValue(), a.getValue()))
                .collect(Collectors.toList());
    }
    public List<Cliente> clientesSemCompras() {
        Set<Integer> comCompras = store.vendas.stream()
                .map(Venda::getClienteId).collect(Collectors.toSet());
        return store.utilizadores.stream()
                .filter(u -> u instanceof Cliente).map(u -> (Cliente) u)
                .filter(c -> !comCompras.contains(c.getId()))
                .collect(Collectors.toList());
    }
}
