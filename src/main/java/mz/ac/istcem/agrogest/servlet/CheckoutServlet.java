package mz.ac.istcem.agrogest.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.service.VendaService;

import java.io.IOException;
import java.util.List;

@WebServlet("/compra")
public class CheckoutServlet extends HttpServlet {
    private final VendaService vendaService = new VendaService();

    @SuppressWarnings("unchecked")
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Object u = session.getAttribute("utilizador");
        if (!(u instanceof Cliente cliente)) {
            session.setAttribute("flashErro", "Apenas clientes podem finalizar compras pelo carrinho. Utilize Vendas no painel de Administração.");
            resp.sendRedirect(req.getContextPath() + "/carrinho");
            return;
        }
        List<VendaItem> carrinho = (List<VendaItem>) session.getAttribute("carrinho");
        if (carrinho == null || carrinho.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/carrinho");
            return;
        }
        try {
            Venda v = vendaService.efetuarVenda(cliente, carrinho);
            session.removeAttribute("carrinho");
            resp.sendRedirect(req.getContextPath() + "/factura?id=" + v.getId());
        } catch (IllegalStateException e) {
            req.setAttribute("erro", e.getMessage());
            req.setAttribute("carrinho", carrinho);
            req.getRequestDispatcher("/WEB-INF/views/cliente/carrinho.jsp").forward(req, resp);
        }
    }
}
