package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.service.VendaService;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/vendas")
public class VendaAdminServlet extends HttpServlet {
    private final VendaService vendaService = new VendaService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        String ord = req.getParameter("ordenar");
        List<Venda> lista = new ArrayList<>(s.vendas);
        if ("valor".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Venda::getTotal).reversed());
        } else if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Venda::getClienteNome, String.CASE_INSENSITIVE_ORDER));
        } else {
            lista.sort(Comparator.comparing(Venda::getData).reversed());
        }
        req.setAttribute("vendas", lista);
        synchronized (s.utilizadores) {
            req.setAttribute("clientes", s.utilizadores.stream().filter(u -> u instanceof Cliente)
                    .sorted(Comparator.comparing(u -> u.getNome(), String.CASE_INSENSITIVE_ORDER))
                    .collect(Collectors.toList()));
        }
        synchronized (s.produtos) {
            req.setAttribute("produtos", s.produtos.stream().filter(p -> p.getQuantidade() > 0)
                    .collect(Collectors.toList()));
        }
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.getRequestDispatcher("/WEB-INF/views/admin/vendas.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        DataStore s = DataStore.getInstance();
        try {
            int clienteId = Integer.parseInt(req.getParameter("clienteId"));
            Utilizador u;
            synchronized (s.utilizadores) {
                u = s.utilizadores.stream().filter(x -> x.getId() == clienteId).findFirst().orElse(null);
            }
            if (!(u instanceof Cliente)) throw new IllegalStateException("Cliente inválido.");

            String[] produtoIds = req.getParameterValues("produtoId");
            String[] quantidades = req.getParameterValues("quantidade");
            Map<Integer, Integer> qtdPorProduto = new LinkedHashMap<>();
            for (int i = 0; produtoIds != null && i < produtoIds.length; i++) {
                if (produtoIds[i].isBlank() || quantidades[i].isBlank()) continue;
                int qtd = Integer.parseInt(quantidades[i]);
                if (qtd <= 0) continue;
                qtdPorProduto.merge(Integer.parseInt(produtoIds[i]), qtd, Integer::sum);
            }
            if (qtdPorProduto.isEmpty()) throw new IllegalStateException("Adicione pelo menos um produto.");

            List<VendaItem> itens = new ArrayList<>();
            for (Map.Entry<Integer, Integer> e : qtdPorProduto.entrySet()) {
                Produto p = s.findProduto(e.getKey());
                if (p == null) throw new IllegalStateException("Produto inexistente.");
                itens.add(new VendaItem(p, e.getValue()));
            }
            Venda v = vendaService.efetuarVenda((Cliente) u, itens);
            resp.sendRedirect(req.getContextPath() + "/factura?id=" + v.getId());
        } catch (IllegalStateException | NumberFormatException e) {
            req.getSession().setAttribute("flashErro",
                    e instanceof NumberFormatException ? "Dados da venda inválidos." : e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/vendas#nova-venda");
        }
    }
}
