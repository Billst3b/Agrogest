package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Campanha;
import mz.ac.istcem.agrogest.model.Cultivo;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/admin/cultivos")
public class CultivoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        String ord = req.getParameter("ordenar");
        List<Cultivo> lista;
        synchronized (s.cultivos) {
            lista = new ArrayList<>(s.cultivos);
        }
        if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Cultivo::getCultura, String.CASE_INSENSITIVE_ORDER));
        } else if ("data".equals(ord)) {
            lista.sort(Comparator.comparing(Cultivo::getDataPlantio).reversed());
        } else if ("valor".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Cultivo::getHectares).reversed());
        }
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.setAttribute("cultivos", lista);
        req.setAttribute("campanhas", s.campanhas);
        req.getRequestDispatcher("/WEB-INF/views/admin/cultivos.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                switch (acao == null ? "" : acao) {
                    case "criar" -> {
                        int campId = Integer.parseInt(req.getParameter("campanhaId"));
                        Campanha camp = s.campanhas.stream().filter(c -> c.getId() == campId).findFirst().orElse(null);
                        if (camp == null)
                            throw new IllegalArgumentException("Campanha agrícola inexistente.");
                        String cultura = req.getParameter("cultura");
                        if (cultura == null || cultura.isBlank())
                            throw new IllegalArgumentException("O nome da cultura é obrigatório.");
                        String variedade = req.getParameter("variedade");
                        double hectares = Double.parseDouble(req.getParameter("hectares"));
                        if (hectares <= 0)
                            throw new IllegalArgumentException("A área plantada (hectares) deve ser superior a zero.");
                        LocalDate dataPlantio = LocalDate.parse(req.getParameter("dataPlantio"));
                        s.cultivos.add(new Cultivo(s.idCultivo.getAndIncrement(),
                            campId, cultura.trim(), variedade == null ? "" : variedade.trim(),
                            hectares, dataPlantio));
                        PersistenciaUtil.gravar();
                    }
                    case "remover" -> {
                        int id = Integer.parseInt(req.getParameter("id"));
                        if (s.colheitas.stream().noneMatch(c -> c.getCultivoId() == id)) {
                            s.cultivos.removeIf(c -> c.getId() == id);
                            PersistenciaUtil.gravar();
                        } else {
                            req.getSession().setAttribute("flashErro", "Não é possível remover este cultivo porque possui colheitas registadas.");
                        }
                    }
                }
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            req.getSession().setAttribute("flashErro", "Dados numéricos ou data de plantio inválidos.");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/cultivos");
    }
}
