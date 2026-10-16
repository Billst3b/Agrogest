package mz.ac.istcem.agrogest.servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;
@WebServlet("/minhas-compras")
public class MinhasComprasServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Utilizador u = (Utilizador) req.getSession().getAttribute("utilizador");
        List<Venda> minhas = DataStore.getInstance().vendas.stream()
                .filter(v -> v.getClienteId() == u.getId())
                .sorted(Comparator.comparing(Venda::getData).reversed())
                .collect(Collectors.toList());
        req.setAttribute("vendas", minhas);
        req.getRequestDispatcher("/WEB-INF/views/cliente/minhas-compras.jsp").forward(req, resp);
    }
}
