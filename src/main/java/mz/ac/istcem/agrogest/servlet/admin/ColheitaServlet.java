package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Colheita;
import mz.ac.istcem.agrogest.model.Cultivo;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/admin/colheitas")
public class ColheitaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        DataStore s = DataStore.getInstance();
        String ord = req.getParameter("ordenar");
        List<Colheita> lista;
        synchronized (s.colheitas) {
            lista = new ArrayList<>(s.colheitas);
        }
        if ("data".equals(ord)) {
            lista.sort(Comparator.comparing(Colheita::getData).reversed());
        } else if ("valor".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Colheita::getValorTotal).reversed());
        } else if ("quantidade".equals(ord)) {
            lista.sort(Comparator.comparingDouble(Colheita::getQuantidadeKg).reversed());
        }
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.setAttribute("colheitas", lista);
        req.setAttribute("cultivos", s.cultivos);
        req.getRequestDispatcher("/WEB-INF/views/admin/colheitas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                if ("criar".equals(acao)) {
                    int cultivoId = Integer.parseInt(req.getParameter("cultivoId"));
                    Cultivo cu = s.cultivos.stream().filter(x -> x.getId() == cultivoId).findFirst().orElse(null);
                    if (cu == null)
                        throw new IllegalArgumentException("Cultivo inexistente.");
                    LocalDate data = LocalDate.parse(req.getParameter("data"));
                    if (cu.getDataPlantio() != null && data.isBefore(cu.getDataPlantio()))
                        throw new IllegalArgumentException("A data da colheita (" + data + ") não pode ser anterior à data de plantio (" + cu.getDataPlantio() + ").");
                    double qtdKg = Double.parseDouble(req.getParameter("quantidadeKg"));
                    double precoKg = Double.parseDouble(req.getParameter("precoPorKg"));
                    if (qtdKg <= 0 || precoKg <= 0)
                        throw new IllegalArgumentException("A quantidade colhida e o preço por kg devem ser superiores a zero.");
                    s.colheitas.add(new Colheita(s.idColheita.getAndIncrement(), cultivoId, data, qtdKg, precoKg));
                    PersistenciaUtil.gravar();
                }
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            req.getSession().setAttribute("flashErro", "Valores numéricos ou data da colheita inválidos.");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/colheitas");
    }
}
