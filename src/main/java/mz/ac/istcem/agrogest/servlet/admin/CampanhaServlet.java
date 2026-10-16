package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Campanha;
import mz.ac.istcem.agrogest.repo.DataStore;
import java.io.IOException;
import java.time.LocalDate;
@WebServlet("/admin/campanhas")
public class CampanhaServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("campanhas", DataStore.getInstance().campanhas);
        req.getRequestDispatcher("/WEB-INF/views/admin/campanhas.jsp").forward(req, resp);
    }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        switch (acao) {
            case "criar" -> s.campanhas.add(new Campanha(s.idCampanha.getAndIncrement(),
                req.getParameter("nome"), LocalDate.parse(req.getParameter("inicio")),
                LocalDate.parse(req.getParameter("fim"))));
            case "fechar" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                s.campanhas.stream().filter(c -> c.getId() == id).findFirst().ifPresent(c -> c.setAberta(false));
            }
            case "reabrir" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                s.campanhas.stream().filter(c -> c.getId() == id).findFirst().ifPresent(c -> c.setAberta(true));
            }
            case "remover" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                if (s.cultivos.stream().noneMatch(cu -> cu.getCampanhaId() == id))
                    s.campanhas.removeIf(c -> c.getId() == id);
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/campanhas");
    }
}
