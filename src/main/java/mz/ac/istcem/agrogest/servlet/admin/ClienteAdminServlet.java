package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Cliente;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PasswordUtil;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/admin/clientes")
public class ClienteAdminServlet extends HttpServlet {
    @Override
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                if ("criar".equals(acao)) {
                    String nome = req.getParameter("nome");
                    String email = req.getParameter("email");
                    String pass = req.getParameter("password");
                    String tel = req.getParameter("telefone");
                    String end = req.getParameter("endereco");
                    if (nome == null || nome.isBlank())
                        throw new IllegalArgumentException("O nome do cliente é obrigatório.");
                    if (email == null || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$"))
                        throw new IllegalArgumentException("Email inválido.");
                    if (pass == null || pass.length() < 4)
                        throw new IllegalArgumentException("A palavra-passe deve ter pelo menos 4 caracteres.");
                    email = email.trim().toLowerCase();
                    if (s.findUtilizadorByEmail(email) != null) {
                        req.getSession().setAttribute("flashErro", "Email já registado: " + email);
                    } else {
                        s.utilizadores.add(new Cliente(s.idUtilizador.getAndIncrement(),
                            nome.trim(), email, PasswordUtil.hash(pass),
                            tel == null ? "" : tel.trim(),
                            end == null ? "" : end.trim()));
                        PersistenciaUtil.gravar();
                    }
                } else if ("remover".equals(acao)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean temVendas;
                    synchronized (s.vendas) { temVendas = s.vendas.stream().anyMatch(v -> v.getClienteId() == id); }
                    if (temVendas) {
                        req.getSession().setAttribute("flashErro", "Não é possível remover um cliente com vendas registadas.");
                    } else {
                        s.utilizadores.removeIf(u -> u instanceof Cliente && u.getId() == id);
                        PersistenciaUtil.gravar();
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flashErro", "Identificador de cliente inválido.");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/clientes");
    }
}
