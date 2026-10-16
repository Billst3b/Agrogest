package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.io.IOException;

@WebServlet("/factura")
public class FacturaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Venda v = DataStore.getInstance().findVenda(id);
        if (v == null) { resp.sendError(404); return; }
        String perfil = (String) req.getSession().getAttribute("perfil");
        if ("CLIENTE".equals(perfil)) {
            Utilizador u = (Utilizador) req.getSession().getAttribute("utilizador");
            if (v.getClienteId() != u.getId()) { resp.sendError(403); return; }
        }
        req.setAttribute("venda", v);
        req.getRequestDispatcher("/WEB-INF/views/cliente/factura.jsp").forward(req, resp);
    }
}