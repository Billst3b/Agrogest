package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.GraficoUtil;

import java.io.IOException;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final DateTimeFormatter MES =
            DateTimeFormatter.ofPattern("MMM yy", new Locale("pt", "PT"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        req.setAttribute("totalProdutos", s.produtos.size());
        req.setAttribute("totalClientes", s.utilizadores.stream()
                .filter(u -> "CLIENTE".equals(u.getPerfil())).count());
        req.setAttribute("totalVendas", s.vendas.size());
        req.setAttribute("totalFornecedores", s.fornecedores.size());
        req.setAttribute("totalCampanhas", s.campanhas.size());

        List<Venda> vendas;
        List<Produto> produtos;
        List<Cultivo> cultivos;
        List<Colheita> colheitas;
        synchronized (s.vendas) { vendas = new ArrayList<>(s.vendas); }
        synchronized (s.produtos) { produtos = new ArrayList<>(s.produtos); }
        synchronized (s.cultivos) { cultivos = new ArrayList<>(s.cultivos); }
        synchronized (s.colheitas) { colheitas = new ArrayList<>(s.colheitas); }

        double receitaTotal = vendas.stream().mapToDouble(Venda::getTotal).sum();
        double valorColheitasTotal = colheitas.stream().mapToDouble(Colheita::getValorTotal).sum();
        double totalHectares = cultivos.stream().mapToDouble(Cultivo::getHectares).sum();
        int stockTotalUnidades = produtos.stream().mapToInt(Produto::getQuantidade).sum();

        req.setAttribute("receitaTotal", receitaTotal);
        req.setAttribute("valorColheitasTotal", valorColheitasTotal);
        req.setAttribute("totalHectares", totalHectares);
        req.setAttribute("stockTotalUnidades", stockTotalUnidades);

        // Última venda e produto em destaque para o cartão Bento lateral
        if (!vendas.isEmpty()) {
            List<Venda> ordVendas = new ArrayList<>(vendas);
            ordVendas.sort(Comparator.comparing(Venda::getData).reversed());
            req.setAttribute("ultimaVenda", ordVendas.get(0));
            req.setAttribute("ultimasVendas", ordVendas.stream().limit(5).collect(Collectors.toList()));
        }

        // Receita dos últimos 6 meses (meses sem vendas aparecem a zero)
        YearMonth agora = YearMonth.now();
        LinkedHashMap<YearMonth, Double> porMes = new LinkedHashMap<>();
        for (int i = 5; i >= 0; i--) porMes.put(agora.minusMonths(i), 0.0);
        for (Venda v : vendas) {
            if (v.getData() == null) continue;
            YearMonth ym = YearMonth.from(v.getData());
            if (porMes.containsKey(ym)) porMes.merge(ym, v.getTotal(), Double::sum);
        }
        List<Map.Entry<String, Double>> receitaMensal = new ArrayList<>();
        porMes.forEach((ym, total) -> receitaMensal.add(Map.entry(ym.format(MES), total)));
        req.setAttribute("receitaMensalJson", GraficoUtil.json(receitaMensal));

        // Receita por categoria e top produtos (a partir dos itens vendidos)
        Map<Integer, String> categoriaPorProduto = produtos.stream()
                .collect(Collectors.toMap(Produto::getId, Produto::getCategoria, (a, b) -> a));
        Map<String, Double> porCategoria = new HashMap<>();
        Map<String, Double> porProduto = new HashMap<>();
        Map<Integer, Integer> qtdVendidaPorProduto = new HashMap<>();
        Map<Integer, Double> receitaPorProdutoId = new HashMap<>();

        for (Venda v : vendas) {
            for (VendaItem it : v.getItens()) {
                String cat = categoriaPorProduto.getOrDefault(it.getProdutoId(), "OUTRO");
                porCategoria.merge(cat, it.getSubtotal(), Double::sum);
                porProduto.merge(it.getProdutoNome(), it.getSubtotal(), Double::sum);
                qtdVendidaPorProduto.merge(it.getProdutoId(), it.getQuantidade(), Integer::sum);
                receitaPorProdutoId.merge(it.getProdutoId(), it.getSubtotal(), Double::sum);
            }
        }
        req.setAttribute("receitaCategoriaJson", GraficoUtil.json(ordenar(porCategoria, 8)));
        req.setAttribute("topProdutosJson", GraficoUtil.json(ordenar(porProduto, 6)));
        req.setAttribute("qtdVendidaPorProduto", qtdVendidaPorProduto);
        req.setAttribute("receitaPorProdutoId", receitaPorProdutoId);

        // Produto em destaque (maior receita ou primeiro produto)
        Produto destaque = produtos.stream()
                .max(Comparator.comparingDouble(p -> receitaPorProdutoId.getOrDefault(p.getId(), 0.0)))
                .orElse(produtos.isEmpty() ? null : produtos.get(0));
        req.setAttribute("produtoDestaque", destaque);
        if (destaque != null) {
            req.setAttribute("receitaDestaque", receitaPorProdutoId.getOrDefault(destaque.getId(), destaque.getPreco()));
        }

        // Lista de produtos ordenada para a secção Bento inferior
        String ord = req.getParameter("ordenar");
        List<Produto> topLista = new ArrayList<>(produtos);
        if ("preco".equals(ord)) {
            topLista.sort(Comparator.comparingDouble(Produto::getPreco).reversed());
        } else if ("stock".equals(ord)) {
            topLista.sort(Comparator.comparingInt(Produto::getQuantidade).reversed());
        } else {
            topLista.sort(Comparator.comparingDouble((Produto p) -> receitaPorProdutoId.getOrDefault(p.getId(), 0.0)).reversed());
        }
        req.setAttribute("topProdutosLista", topLista.stream().limit(6).collect(Collectors.toList()));

        // Produtos com menos stock
        List<Map.Entry<String, Integer>> stock = produtos.stream()
                .sorted(Comparator.comparingInt(Produto::getQuantidade))
                .limit(6)
                .map(p -> Map.entry(p.getNome(), p.getQuantidade()))
                .collect(Collectors.toList());
        req.setAttribute("stockJson", GraficoUtil.json(stock));

        // Produção colhida (kg) por cultura
        Map<Integer, String> culturaPorCultivo = cultivos.stream()
                .collect(Collectors.toMap(Cultivo::getId, Cultivo::getCultura, (a, b) -> a));
        Map<String, Double> producao = new HashMap<>();
        for (Colheita c : colheitas) {
            producao.merge(culturaPorCultivo.getOrDefault(c.getCultivoId(), "Outro"),
                    c.getQuantidadeKg(), Double::sum);
        }
        req.setAttribute("producaoJson", GraficoUtil.json(ordenar(producao, 8)));

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private static List<Map.Entry<String, Double>> ordenar(Map<String, Double> mapa, int limite) {
        return mapa.entrySet().stream()
                .sorted((a, b) -> Double.compare(b.getValue(), a.getValue()))
                .limit(limite)
                .collect(Collectors.toList());
    }
}
