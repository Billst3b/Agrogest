package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Cliente;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PasswordUtil;

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
        DataStore store = DataStore.getInstance();
        if (store.findUtilizadorByEmail(email) != null) {
            req.setAttribute("erro", "Email já registado");
            req.getRequestDispatcher("/registo.jsp").forward(req, resp);
            return;
        }
        Cliente c = new Cliente(store.idUtilizador.getAndIncrement(),
            nome, email, PasswordUtil.hash(pass), tel, end);
        store.utilizadores.add(c);
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}