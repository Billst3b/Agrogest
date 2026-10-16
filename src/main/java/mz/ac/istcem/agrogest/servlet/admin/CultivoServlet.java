package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Cultivo;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.time.LocalDate;
@WebServlet("/admin/cultivos")
public class CultivoServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        req.setAttribute("cultivos", s.cultivos);
        req.setAttribute("campanhas", s.campanhas);
        req.getRequestDispatcher("/WEB-INF/views/admin/cultivos.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        switch (acao) {
            case "criar" -> s.cultivos.add(new Cultivo(s.idCultivo.getAndIncrement(),
                Integer.parseInt(req.getParameter("campanhaId")), req.getParameter("cultura"),
                req.getParameter("variedade"), Double.parseDouble(req.getParameter("hectares")),
                LocalDate.parse(req.getParameter("dataPlantio"))));
            case "remover" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                if (s.colheitas.stream().noneMatch(c -> c.getCultivoId() == id))
                    s.cultivos.removeIf(c -> c.getId() == id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/cultivos");
    }
}
