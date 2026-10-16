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
        List<Produto> lista;
        synchronized (DataStore.getInstance().produtos) {
            lista = DataStore.getInstance().produtos.stream()
                    .filter(p -> p.getQuantidade() > 0)
                    .filter(p -> cat == null || cat.isEmpty() || p.getCategoria().equals(cat))
                    .collect(Collectors.toList());
        }
        req.setAttribute("produtos", lista);
        req.getRequestDispatcher("/WEB-INF/views/cliente/catalogo.jsp").forward(req, resp);
    }
}