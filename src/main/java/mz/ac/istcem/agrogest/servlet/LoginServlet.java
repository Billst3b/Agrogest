package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Utilizador;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PasswordUtil;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        String pass  = req.getParameter("password");
        Utilizador u = DataStore.getInstance().findUtilizadorByEmail(email);
        if (u != null && u.isAtivo() && u.getPasswordHash().equals(PasswordUtil.hash(pass))) {
            HttpSession s = req.getSession();
            s.setAttribute("utilizador", u);
            s.setAttribute("perfil", u.getPerfil());
            s.setAttribute("nome", u.getNome());
            if ("ADMIN".equals(u.getPerfil()))
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            else
                resp.sendRedirect(req.getContextPath() + "/catalogo");
        } else {
            req.setAttribute("erro", "Credenciais inválidas");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}