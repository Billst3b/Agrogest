package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Venda;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.util.*;
@WebServlet("/admin/vendas")
public class VendaAdminServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Venda> lista = new ArrayList<>(DataStore.getInstance().vendas);
        lista.sort(Comparator.comparing(Venda::getData).reversed());
        req.setAttribute("vendas", lista);
        req.getRequestDispatcher("/WEB-INF/views/admin/vendas.jsp").forward(req, resp);
    }
}
