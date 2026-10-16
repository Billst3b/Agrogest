package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.service.RelatorioService;
import java.io.IOException;
@WebServlet("/admin/relatorios")
public class RelatorioServlet extends HttpServlet {
    private final RelatorioService service = new RelatorioService();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("clientesPorNome", service.clientesOrdenadosPorNome());
        req.setAttribute("clientesPorVolume", service.clientesPorVolume());
        req.setAttribute("clientesAssiduos", service.clientesMaisAssiduos());
        req.setAttribute("clientesSemCompras", service.clientesSemCompras());
        req.getRequestDispatcher("/WEB-INF/views/admin/relatorios.jsp").forward(req, resp);
    }
}
