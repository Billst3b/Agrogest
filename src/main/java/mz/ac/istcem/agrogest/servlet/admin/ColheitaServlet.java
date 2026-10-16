package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Colheita;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.time.LocalDate;
@WebServlet("/admin/colheitas")
public class ColheitaServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        req.setAttribute("colheitas", s.colheitas);
        req.setAttribute("cultivos", s.cultivos);
        req.getRequestDispatcher("/WEB-INF/views/admin/colheitas.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        if ("criar".equals(acao)) {
            s.colheitas.add(new Colheita(s.idColheita.getAndIncrement(),
                Integer.parseInt(req.getParameter("cultivoId")),
                LocalDate.parse(req.getParameter("data")),
                Double.parseDouble(req.getParameter("quantidadeKg")),
                Double.parseDouble(req.getParameter("precoPorKg"))));
        }
        resp.sendRedirect(req.getContextPath() + "/admin/colheitas");
    }
}
