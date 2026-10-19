package mz.ac.istcem.agrogest.servlet.admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import mz.ac.istcem.agrogest.service.RelatorioService;
import mz.ac.istcem.agrogest.util.GraficoUtil;
import java.io.IOException;
import java.util.Map;
import java.util.stream.Collectors;
@WebServlet("/admin/relatorios")
public class RelatorioServlet extends HttpServlet {
    private final RelatorioService service = new RelatorioService();
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("clientesPorNome", service.clientesOrdenadosPorNome());
        var porVolume = service.clientesPorVolume();
        var assiduos = service.clientesMaisAssiduos();
        req.setAttribute("clientesPorVolume", porVolume);
        req.setAttribute("clientesAssiduos", assiduos);
        req.setAttribute("volumeJson", GraficoUtil.json(porVolume.stream().limit(8)
                .map(e -> Map.entry(e.getKey().getNome(), e.getValue())).collect(Collectors.toList())));
        req.setAttribute("assiduosJson", GraficoUtil.json(assiduos.stream().limit(8)
                .map(e -> Map.entry(e.getKey().getNome(), e.getValue())).collect(Collectors.toList())));
        req.setAttribute("clientesSemCompras", service.clientesSemCompras());
        req.getRequestDispatcher("/WEB-INF/views/admin/relatorios.jsp").forward(req, resp);
    }
}
