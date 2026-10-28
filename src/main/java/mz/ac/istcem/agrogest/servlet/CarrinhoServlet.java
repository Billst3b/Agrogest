package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;

import java.io.IOException;
import java.util.*;

@WebServlet("/carrinho/*")
public class CarrinhoServlet extends HttpServlet {
    @SuppressWarnings("unchecked")
    private List<VendaItem> getCarrinho(HttpSession s) {
        List<VendaItem> c = (List<VendaItem>) s.getAttribute("carrinho");
        if (c == null) { c = new ArrayList<>(); s.setAttribute("carrinho", c); }
        return c;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        req.setAttribute("carrinho", getCarrinho(session));
        if (req.getAttribute("erro") == null && session.getAttribute("flashErro") != null) {
            req.setAttribute("erro", session.getAttribute("flashErro"));
            session.removeAttribute("flashErro");
        }
        req.getRequestDispatcher("/WEB-INF/views/cliente/carrinho.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        HttpSession session = req.getSession();
        List<VendaItem> carrinho = getCarrinho(session);
        try {
            switch (acao == null ? "" : acao) {
                case "adicionar" -> {
                    int pid = Integer.parseInt(req.getParameter("produtoId"));
                    int qtd = Integer.parseInt(req.getParameter("quantidade"));
                    Produto p = DataStore.getInstance().findProduto(pid);
                    if (p == null || p.getQuantidade() <= 0) {
                        session.setAttribute("flashErro", "Produto indisponível ou esgotado em stock.");
                        resp.sendRedirect(req.getContextPath() + "/catalogo");
                        return;
                    }
                    Optional<VendaItem> ex = carrinho.stream().filter(i -> i.getProdutoId() == pid).findFirst();
                    int jaNoCarrinho = ex.map(VendaItem::getQuantidade).orElse(0);
                    if (qtd <= 0 || jaNoCarrinho + qtd > p.getQuantidade()) {
                        session.setAttribute("flashErro", "Stock insuficiente para '" + p.getNome() + "' (disponível: " + p.getQuantidade() + " " + p.getUnidade() + ").");
                        resp.sendRedirect(req.getContextPath() + "/catalogo");
                        return;
                    }
                    if (ex.isPresent()) {
                        int novaQtd = jaNoCarrinho + qtd;
                        ex.get().setQuantidade(novaQtd);
                        ex.get().setSubtotal(novaQtd * ex.get().getPrecoUnitario());
                    } else {
                        carrinho.add(new VendaItem(p, qtd));
                    }
                }
                case "atualizar" -> {
                    int idx = Integer.parseInt(req.getParameter("index"));
                    int qtd = Integer.parseInt(req.getParameter("quantidade"));
                    if (idx >= 0 && idx < carrinho.size()) {
                        VendaItem item = carrinho.get(idx);
                        Produto p = DataStore.getInstance().findProduto(item.getProdutoId());
                        if (qtd <= 0) {
                            carrinho.remove(idx);
                        } else if (p != null) {
                            if (qtd > p.getQuantidade()) {
                                session.setAttribute("flashErro", "Stock insuficiente para '" + p.getNome() + "'. Máximo disponível: " + p.getQuantidade() + " " + p.getUnidade() + ".");
                                item.setQuantidade(p.getQuantidade());
                                item.setSubtotal(p.getQuantidade() * item.getPrecoUnitario());
                            } else {
                                item.setQuantidade(qtd);
                                item.setSubtotal(qtd * item.getPrecoUnitario());
                            }
                        }
                    }
                }
                case "remover" -> {
                    int idx = Integer.parseInt(req.getParameter("index"));
                    if (idx >= 0 && idx < carrinho.size()) carrinho.remove(idx);
                }
                case "limpar" -> carrinho.clear();
            }
        } catch (NumberFormatException e) {
            session.setAttribute("flashErro", "Quantidade ou identificador inválido.");
        }
        resp.sendRedirect(req.getContextPath() + "/carrinho");
    }
}
