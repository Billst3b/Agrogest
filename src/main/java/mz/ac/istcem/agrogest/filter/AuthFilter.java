package mz.ac.istcem.agrogest.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/catalogo", "/carrinho/*", "/compra",
        "/factura", "/minhas-compras"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);
        String path = request.getRequestURI().substring(request.getContextPath().length());

        if (session == null || session.getAttribute("utilizador") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (path.startsWith("/admin")) {
            if (!"ADMIN".equals(session.getAttribute("perfil"))) {
                response.sendRedirect(request.getContextPath() + "/erro403.jsp");
                return;
            }
        }
        chain.doFilter(req, res);
    }
}
