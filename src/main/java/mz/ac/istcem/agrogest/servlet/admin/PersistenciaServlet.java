package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.util.PersistenciaUtil;
import java.io.IOException;
@WebServlet("/admin/persistencia")
public class PersistenciaServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String acao = req.getParameter("acao");
        if ("gravar".equals(acao)) PersistenciaUtil.gravar();
        else if ("eliminar".equals(acao)) PersistenciaUtil.eliminar();
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
