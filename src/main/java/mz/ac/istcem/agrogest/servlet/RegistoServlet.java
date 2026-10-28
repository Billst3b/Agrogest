package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Cliente;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PasswordUtil;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;

@WebServlet("/registo")
public class RegistoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        String tel   = req.getParameter("telefone");
        String end   = req.getParameter("endereco");
        String erro = null;
        if (nome == null || nome.isBlank()) erro = "O nome é obrigatório";
        else if (email == null || !email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) erro = "Email inválido";
        else if (pass == null || pass.length() < 4) erro = "A palavra-passe deve ter pelo menos 4 caracteres";
        if (erro != null) {
            req.setAttribute("erro", erro);
            req.getRequestDispatcher("/registo.jsp").forward(req, resp);
            return;
        }
        email = email.trim().toLowerCase();
        DataStore store = DataStore.getInstance();
        synchronized (store) {
            if (store.findUtilizadorByEmail(email) != null) {
                req.setAttribute("erro", "Email já registado");
                req.getRequestDispatcher("/registo.jsp").forward(req, resp);
                return;
            }
            Cliente c = new Cliente(store.idUtilizador.getAndIncrement(),
                nome.trim(), email, PasswordUtil.hash(pass),
                tel == null ? "" : tel.trim(),
                end == null ? "" : end.trim());
            store.utilizadores.add(c);
            PersistenciaUtil.gravar();
        }
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
