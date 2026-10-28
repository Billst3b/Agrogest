package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Fornecedor;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.util.*;

@WebServlet("/admin/fornecedores")
public class FornecedorServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String ord = req.getParameter("ordenar");
        List<Fornecedor> lista;
        synchronized (DataStore.getInstance().fornecedores) {
            lista = new ArrayList<>(DataStore.getInstance().fornecedores);
        }
        if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Fornecedor::getNome, String.CASE_INSENSITIVE_ORDER));
        } else if ("provincia".equals(ord)) {
            lista.sort(Comparator.comparing(Fornecedor::getProvincia, String.CASE_INSENSITIVE_ORDER));
        }
        req.setAttribute("fornecedores", lista);
        req.getRequestDispatcher("/WEB-INF/views/admin/fornecedores.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        if ("criar".equals(acao)) {
            s.fornecedores.add(new Fornecedor(s.idFornecedor.getAndIncrement(),
                req.getParameter("nome"), req.getParameter("tipo"),
                req.getParameter("contacto"), req.getParameter("provincia")));
        } else if ("remover".equals(acao)) {
            int id = Integer.parseInt(req.getParameter("id"));
            s.fornecedores.removeIf(f -> f.getId() == id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/fornecedores");
    }
}
