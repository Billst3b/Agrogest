package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/produtos")
public class ProdutoServlet extends HttpServlet {
    private static final Set<String> CATEGORIAS = Set.of("SEMENTE", "FERTILIZANTE", "MAQUINARIA", "FERRAMENTA");

    @Override
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

        Object flash = req.getSession().getAttribute("flashErro");
        if (flash != null) {
            req.setAttribute("flashErro", flash);
            req.getSession().removeAttribute("flashErro");
        }
        req.setAttribute("produtos", lista);
        req.setAttribute("fornecedores", s.fornecedores);
        req.getRequestDispatcher("/WEB-INF/views/admin/produtos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                if ("criar".equals(acao)) {
                    String nome = req.getParameter("nome");
                    String categoria = req.getParameter("categoria");
                    if (nome == null || nome.isBlank())
                        throw new IllegalArgumentException("O nome do produto é obrigatório.");
                    if (categoria == null || !CATEGORIAS.contains(categoria))
                        throw new IllegalArgumentException("Categoria inválida. Seleccione SEMENTE, FERTILIZANTE, MAQUINARIA ou FERRAMENTA.");
                    double preco = Double.parseDouble(req.getParameter("preco"));
                    int qtd = Integer.parseInt(req.getParameter("quantidade"));
                    if (preco < 0 || qtd < 0)
                        throw new IllegalArgumentException("Preço e quantidade não podem ser negativos.");
                    int fId = Integer.parseInt(req.getParameter("fornecedorId"));
                    Fornecedor f = s.fornecedores.stream().filter(x -> x.getId() == fId).findFirst().orElse(null);
                    if (f == null)
                        throw new IllegalArgumentException("Fornecedor inexistente.");
                    LocalDate val = null;
                    String v = req.getParameter("validade");
                    if (v != null && !v.isBlank()) val = LocalDate.parse(v);
                    String unidade = req.getParameter("unidade");
                    if (unidade == null || unidade.isBlank()) unidade = "un";
                    s.produtos.add(new Produto(s.idProduto.getAndIncrement(),
                        nome.trim(), categoria, fId, f.getNome(), preco, qtd,
                        unidade.trim(), req.getParameter("descricao"),
                        req.getParameter("fotoUrl"), val));
                    PersistenciaUtil.gravar();
                } else if ("repor".equals(acao)) {
                    int qtd = Integer.parseInt(req.getParameter("quantidade"));
                    if (qtd <= 0)
                        throw new IllegalArgumentException("A quantidade a repor deve ser positiva.");
                    Produto p = s.findProduto(Integer.parseInt(req.getParameter("id")));
                    if (p != null) {
                        p.setQuantidade(p.getQuantidade() + qtd);
                        PersistenciaUtil.gravar();
                    }
                } else if ("remover".equals(acao)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    s.produtos.removeIf(p -> p.getId() == id);
                    PersistenciaUtil.gravar();
                }
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            req.getSession().setAttribute("flashErro", "Valores numéricos ou data inválidos.");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/produtos");
    }
}
