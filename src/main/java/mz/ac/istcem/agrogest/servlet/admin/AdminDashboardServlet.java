package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
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
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}