package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Campanha;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/admin/campanhas")
public class CampanhaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String ord = req.getParameter("ordenar");
        List<Campanha> lista;
        synchronized (DataStore.getInstance().campanhas) {
            lista = new ArrayList<>(DataStore.getInstance().campanhas);
        }
        if ("nome".equals(ord)) {
            lista.sort(Comparator.comparing(Campanha::getNome, String.CASE_INSENSITIVE_ORDER));
        } else if ("data".equals(ord)) {
            lista.sort(Comparator.comparing(Campanha::getInicio).reversed());
        }
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.setAttribute("campanhas", lista);
        req.getRequestDispatcher("/WEB-INF/views/admin/campanhas.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                switch (acao == null ? "" : acao) {
                    case "criar" -> {
                        String nome = req.getParameter("nome");
                        if (nome == null || nome.isBlank())
                            throw new IllegalArgumentException("O nome da campanha é obrigatório.");
                        LocalDate inicio = LocalDate.parse(req.getParameter("inicio"));
                        LocalDate fim = LocalDate.parse(req.getParameter("fim"));
                        if (fim.isBefore(inicio))
                            throw new IllegalArgumentException("A data de fim da campanha não pode ser anterior à data de início.");
                        s.campanhas.add(new Campanha(s.idCampanha.getAndIncrement(), nome.trim(), inicio, fim));
                        PersistenciaUtil.gravar();
                    }
                    case "fechar" -> {
                        int id = Integer.parseInt(req.getParameter("id"));
                        s.campanhas.stream().filter(c -> c.getId() == id).findFirst().ifPresent(c -> c.setAberta(false));
                        PersistenciaUtil.gravar();
                    }
                    case "reabrir" -> {
                        int id = Integer.parseInt(req.getParameter("id"));
                        s.campanhas.stream().filter(c -> c.getId() == id).findFirst().ifPresent(c -> c.setAberta(true));
                        PersistenciaUtil.gravar();
                    }
                    case "remover" -> {
                        int id = Integer.parseInt(req.getParameter("id"));
                        if (s.cultivos.stream().noneMatch(cu -> cu.getCampanhaId() == id)) {
                            s.campanhas.removeIf(c -> c.getId() == id);
                            PersistenciaUtil.gravar();
                        } else {
                            req.getSession().setAttribute("flashErro", "Não é possível remover esta campanha porque possui cultivos associados.");
                        }
                    }
                }
            }
        } catch (NumberFormatException | DateTimeParseException e) {
            req.getSession().setAttribute("flashErro", "Datas ou identificador de campanha inválidos.");
        } catch (IllegalArgumentException e) {
            req.getSession().setAttribute("flashErro", e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/campanhas");
    }
}
