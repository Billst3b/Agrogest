package mz.ac.istcem.agrogest.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.Fornecedor;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/fornecedores")
public class FornecedorServlet extends HttpServlet {
    @Override
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
        HttpSession session = req.getSession();
        req.setAttribute("erro", session.getAttribute("flashErro"));
        session.removeAttribute("flashErro");
        req.setAttribute("fornecedores", lista);
        req.getRequestDispatcher("/WEB-INF/views/admin/fornecedores.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        DataStore s = DataStore.getInstance();
        try {
            synchronized (s) {
                if ("criar".equals(acao)) {
                    String tipo = req.getParameter("tipo");
                    String nome = req.getParameter("nome");
                    if (nome == null || nome.isBlank()
                            || !Set.of("SEMENTES", "MAQUINARIA", "FERTILIZANTES").contains(tipo)) {
                        req.getSession().setAttribute("flashErro", "Nome obrigatório e tipo deve ser SEMENTES, MAQUINARIA ou FERTILIZANTES.");
                        resp.sendRedirect(req.getContextPath() + "/admin/fornecedores");
                        return;
                    }
                    s.fornecedores.add(new Fornecedor(s.idFornecedor.getAndIncrement(),
                        nome.trim(), tipo,
                        req.getParameter("contacto"), req.getParameter("provincia")));
                    PersistenciaUtil.gravar();
                } else if ("remover".equals(acao)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean temProdutos;
                    synchronized (s.produtos) {
                        temProdutos = s.produtos.stream().anyMatch(p -> p.getFornecedorId() == id);
                    }
                    if (temProdutos) {
                        req.getSession().setAttribute("flashErro", "Não é possível remover este fornecedor porque possui produtos associados.");
                    } else {
                        s.fornecedores.removeIf(f -> f.getId() == id);
                        PersistenciaUtil.gravar();
                    }
                }
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("flashErro", "Identificador de fornecedor inválido.");
        }
        resp.sendRedirect(req.getContextPath() + "/admin/fornecedores");
    }
}
