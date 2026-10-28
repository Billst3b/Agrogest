package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Cliente;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PasswordUtil;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/clientes")
public class ClienteAdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        String ord = req.getParameter("ordenar");
        List<Cliente> clientes;
        synchronized (s.utilizadores) {
            clientes = s.utilizadores.stream().filter(u -> u instanceof Cliente)
                    .map(u -> (Cliente) u).collect(Collectors.toList());
        }
        Map<Integer, Long> compras = new HashMap<>();
        synchronized (s.vendas) { s.vendas.forEach(v -> compras.merge(v.getClienteId(), 1L, Long::sum)); }

        if ("nome".equals(ord)) {
            clientes.sort(Comparator.comparing(Cliente::getNome, String.CASE_INSENSITIVE_ORDER));
        } else if ("compras".equals(ord)) {
            clientes.sort(Comparator.comparingLong((Cliente c) -> compras.getOrDefault(c.getId(), 0L)).reversed());
        }

        req.setAttribute("clientes", clientes);
        req.setAttribute("compras", compras);
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.getRequestDispatcher("/WEB-INF/views/admin/clientes.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        if ("criar".equals(acao)) {
            String email = req.getParameter("email");
            if (s.findUtilizadorByEmail(email) != null) {
                req.getSession().setAttribute("flashErro", "Email já registado: " + email);
            } else {
                s.utilizadores.add(new Cliente(s.idUtilizador.getAndIncrement(),
                    req.getParameter("nome"), email, PasswordUtil.hash(req.getParameter("password")),
                    req.getParameter("telefone"), req.getParameter("endereco")));
            }
        } else if ("remover".equals(acao)) {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean temVendas;
            synchronized (s.vendas) { temVendas = s.vendas.stream().anyMatch(v -> v.getClienteId() == id); }
            if (temVendas) {
                req.getSession().setAttribute("flashErro", "Não é possível remover um cliente com vendas registadas.");
            } else {
                s.utilizadores.removeIf(u -> u instanceof Cliente && u.getId() == id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/clientes");
    }
}
