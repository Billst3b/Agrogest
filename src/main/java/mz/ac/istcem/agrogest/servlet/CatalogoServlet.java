package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Produto;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/catalogo")
public class CatalogoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String cat = req.getParameter("categoria");
        String q = req.getParameter("q");
        String ord = req.getParameter("ordenar");
        String termo = q == null ? "" : q.trim().toLowerCase();

        List<Produto> todos;
        synchronized (DataStore.getInstance().produtos) {
            todos = new ArrayList<>(DataStore.getInstance().produtos);
        }

        Map<String, Long> contagemPorCat = todos.stream()
                .collect(Collectors.groupingBy(Produto::getCategoria, Collectors.counting()));
        req.setAttribute("totalDisponiveis", todos.size());
        req.setAttribute("contagemPorCat", contagemPorCat);

        List<Produto> lista = todos.stream()
                .filter(p -> cat == null || cat.isEmpty() || p.getCategoria().equals(cat))
                .filter(p -> termo.isEmpty()
                        || p.getNome().toLowerCase().contains(termo)
                        || (p.getDescricao() != null && p.getDescricao().toLowerCase().contains(termo))
                        || (p.getFornecedorNome() != null && p.getFornecedorNome().toLowerCase().contains(termo)))
                .collect(Collectors.toList());

        if ("preco_asc".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Produto::getPreco));
        } else if ("preco_desc".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Produto::getPreco).reversed());
        } else if ("stock".equals(ord)) {
            lista.sort(Comparator.comparingInt(Produto::getQuantidade).reversed());
        } else if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Produto::getNome, String.CASE_INSENSITIVE_ORDER));
        }

        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");

        req.setAttribute("produtos", lista);
        req.getRequestDispatcher("/WEB-INF/views/cliente/catalogo.jsp").forward(req, resp);
    }
}
