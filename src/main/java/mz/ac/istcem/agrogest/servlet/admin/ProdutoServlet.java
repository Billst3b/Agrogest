package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/produtos")
public class ProdutoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        String ord = req.getParameter("ordenar");
        String filtro = req.getParameter("filtro");

        List<Produto> lista;
        synchronized (s.produtos) {
            lista = new ArrayList<>(s.produtos);
        }
        if ("armazem".equals(filtro)) {
            lista = lista.stream().filter(p -> p.getQuantidade() > 0).collect(Collectors.toList());
        }
        if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Produto::getNome, String.CASE_INSENSITIVE_ORDER));
        } else if ("preco".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Produto::getPreco).reversed());
        } else if ("stock".equals(ord)) {
            lista.sort(Comparator.comparingInt(Produto::getQuantidade).reversed());
        }

        req.setAttribute("produtos", lista);
        req.setAttribute("fornecedores", s.fornecedores);
        req.getRequestDispatcher("/WEB-INF/views/admin/produtos.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        switch (acao) {
            case "criar" -> {
                int fId = Integer.parseInt(req.getParameter("fornecedorId"));
                Fornecedor f = s.fornecedores.stream().filter(x -> x.getId() == fId).findFirst().orElse(null);
                LocalDate val = null;
                String v = req.getParameter("validade");
                if (v != null && !v.isEmpty()) val = LocalDate.parse(v);
                s.produtos.add(new Produto(s.idProduto.getAndIncrement(),
                    req.getParameter("nome"), req.getParameter("categoria"),
                    fId, f == null ? "" : f.getNome(),
                    Double.parseDouble(req.getParameter("preco")),
                    Integer.parseInt(req.getParameter("quantidade")),
                    req.getParameter("unidade"), req.getParameter("descricao"),
                    req.getParameter("fotoUrl"), val));
            }
            case "repor" -> {
                Produto p = s.findProduto(Integer.parseInt(req.getParameter("id")));
                if (p != null) p.setQuantidade(p.getQuantidade() + Integer.parseInt(req.getParameter("quantidade")));
            }
            case "remover" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                s.produtos.removeIf(p -> p.getId() == id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/produtos");
    }
}
