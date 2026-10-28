package mz.ac.istcem.agrogest.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import mz.ac.istcem.agrogest.model.*;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebListener
public class AppListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        PersistenciaUtil.carregar();
        DataStore store = DataStore.getInstance();

        if (store.findUtilizadorByEmail("admin@agro.mz") == null) {
            Administrador a = new Administrador(
                store.idUtilizador.getAndIncrement(),
                "Administrador", "admin@agro.mz",
                PasswordUtil.hash("admin234"));
            store.utilizadores.add(a);
            System.out.println("Admin criado: admin@agro.mz / admin234");
        }

        Cliente cDemo = (Cliente) store.findUtilizadorByEmail("cliente@agro.mz");
        if (cDemo == null) {
            cDemo = new Cliente(
                store.idUtilizador.getAndIncrement(),
                "Cliente Demo", "cliente@agro.mz",
                PasswordUtil.hash("cliente123"), "+258 84 000 0000", "Av. 24 de Julho, Maputo");
            store.utilizadores.add(cDemo);
            System.out.println("Cliente criado: cliente@agro.mz / cliente123");
        }

        if (store.produtos.isEmpty()) {
            seedDadosIniciais(store, cDemo);
            PersistenciaUtil.gravar();
            System.out.println("AgroGest: Dados iniciais de demonstração carregados com sucesso.");
        }
    }

    private void seedDadosIniciais(DataStore store, Cliente cDemo) {
        // 1. Clientes adicionais de Nampula e região
        Cliente cJoao = criarClienteSeNaoExiste(store, "João Silva", "joao@teste.mz", "1234",
                "+258 84 321 9870", "Av. Eduardo Mondlane, Nampula");
        Cliente cAmina = criarClienteSeNaoExiste(store, "Amina Momade", "amina@agro.mz", "1234",
                "+258 82 445 1120", "Bairro de Muhala Expansão, Nampula");
        Cliente cCarlos = criarClienteSeNaoExiste(store, "Carlos Mucavele", "carlos@cooperativa.mz", "1234",
                "+258 84 890 2231", "Zona Industrial, Nacala-Porto");
        Cliente cFatima = criarClienteSeNaoExiste(store, "Fátima Ussene", "fatima@ribaueterras.mz", "1234",
                "+258 86 710 3344", "Distrito de Ribáuè, Nampula");
        Cliente cBernardo = criarClienteSeNaoExiste(store, "Bernardo Chissano", "bernardo@malema.mz", "1234",
                "+258 84 612 9087", "Vila de Malema, Nampula");
        // Clientes sem compras (para o relatório extra do enunciado)
        criarClienteSeNaoExiste(store, "Helena Nhantumbo", "helena@monapo.mz", "1234",
                "+258 87 301 4490", "Vila de Monapo, Nampula");
        criarClienteSeNaoExiste(store, "Celso Matsinhe", "celso@meconta.mz", "1234",
                "+258 84 912 0011", "Distrito de Meconta, Nampula");

        // 2. Fornecedores
        Fornecedor f1 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "Sementes do Sul, Lda", "SEMENTES", "+258 84 210 4400", "Maputo");
        Fornecedor f2 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "AgroQuímica Rovuma, S.A.", "FERTILIZANTES", "+258 82 554 1920", "Nampula");
        Fornecedor f3 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "MecAgro Moçambique, Lda", "MAQUINARIA", "+258 84 900 3110", "Sofala");
        Fornecedor f4 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "Sementes Planalto de Ribáuè", "SEMENTES", "+258 86 412 8890", "Nampula");
        Fornecedor f5 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "Fertilizantes do Índico, Lda", "FERTILIZANTES", "+258 84 771 2300", "Nampula");
        Fornecedor f6 = new Fornecedor(store.idFornecedor.getAndIncrement(),
                "Tractores & Alfaias Zambeze", "MAQUINARIA", "+258 82 309 5511", "Tete");
        store.fornecedores.addAll(List.of(f1, f2, f3, f4, f5, f6));

        // 3. Produtos (12 produtos com fotografias locais e descrições completas)
        LocalDate hoje = LocalDate.now();
        Produto p1 = new Produto(store.idProduto.getAndIncrement(),
                "Semente Feijão Nhemba (Macia)", "SEMENTE", f1.getId(), f1.getNome(),
                320.00, 400, "kg",
                "Semente certificada de ciclo curto adaptada ao clima de Nampula, elevada resistência à seca.",
                "img/produtos/feijao.jpg", hoje.plusMonths(8));
        Produto p2 = new Produto(store.idProduto.getAndIncrement(),
                "Semente de Milho Branco Matuba", "SEMENTE", f4.getId(), f4.getNome(),
                280.00, 650, "kg",
                "Variedade de polinização aberta com alto rendimento em solos argilosos do norte.",
                "img/produtos/milho.jpg", hoje.plusMonths(10));
        Produto p3 = new Produto(store.idProduto.getAndIncrement(),
                "Semente de Soja Certificada TGx", "SEMENTE", f1.getId(), f1.getNome(),
                410.00, 280, "kg",
                "Grão vigoroso com excelente fixação biológica de azoto para rotação de culturas.",
                "img/produtos/soja.jpg", hoje.plusMonths(9));
        Produto p4 = new Produto(store.idProduto.getAndIncrement(),
                "Semente de Gergelim Lindi 02", "SEMENTE", f4.getId(), f4.getNome(),
                520.00, 190, "kg",
                "Gergelim branco tipo exportação com teor de óleo superior a 52%.",
                "img/produtos/gergelim.jpg", hoje.plusMonths(12));
        Produto p5 = new Produto(store.idProduto.getAndIncrement(),
                "Adubo Composto NPK 12-24-12", "FERTILIZANTE", f2.getId(), f2.getNome(),
                1850.00, 120, "saco",
                "Saco de 50 kg para adubação de fundo no plantio de cereais, leguminosas e hortícolas.",
                "img/produtos/npk.jpg", hoje.plusMonths(24));
        Produto p6 = new Produto(store.idProduto.getAndIncrement(),
                "Ureia Agrícola Granulada 46% N", "FERTILIZANTE", f5.getId(), f5.getNome(),
                2100.00, 85, "saco",
                "Saco de 50 kg de libertação rápida para cobertura azotada em milho e arroz.",
                "img/produtos/ureia.jpg", hoje.plusMonths(18));
        Produto p7 = new Produto(store.idProduto.getAndIncrement(),
                "Sulfato de Amónio Cristalizado", "FERTILIZANTE", f2.getId(), f2.getNome(),
                1490.00, 7, "saco",
                "Fertilizante rico em azoto e enxofre para correção nutricional de solos tropicais.",
                "img/produtos/sulfato.jpg", hoje.plusMonths(15));
        Produto p8 = new Produto(store.idProduto.getAndIncrement(),
                "Motocultivador Diesel 12CV c/ Charrua", "MAQUINARIA", f3.getId(), f3.getNome(),
                68500.00, 4, "un",
                "Equipamento completo de lavoura com arranque eléctrico, fresa rotativa e charrua reversível.",
                "img/produtos/tractor.jpg", hoje.plusMonths(60));
        Produto p9 = new Produto(store.idProduto.getAndIncrement(),
                "Pulverizador Costal Motorizado 20L", "MAQUINARIA", f6.getId(), f6.getNome(),
                6400.00, 18, "un",
                "Atomizador a gasolina de alto alcance para controlo fitossanitário em pomares e campos.",
                "img/produtos/pulverizador.jpg", hoje.plusMonths(36));
        Produto p10 = new Produto(store.idProduto.getAndIncrement(),
                "Debulhador Eléctrico de Milho 800kg/h", "MAQUINARIA", f3.getId(), f3.getNome(),
                24900.00, 6, "un",
                "Debulhadora de alta eficiência com separação automática de sabugo e ventilação.",
                "img/produtos/debulhador.jpg", hoje.plusMonths(48));
        Produto p11 = new Produto(store.idProduto.getAndIncrement(),
                "Enxada Forjada Cabo Eucalipto 2.5lb", "FERRAMENTA", f6.getId(), f6.getNome(),
                450.00, 150, "un",
                "Lâmina em aço carbono temperado de alta durabilidade com cabo ergonómico tratado.",
                "img/produtos/enxada.jpg", hoje.plusMonths(36));
        Produto p12 = new Produto(store.idProduto.getAndIncrement(),
                "Kit de Rega Gota-a-Gota (1 Hectare)", "FERRAMENTA", f3.getId(), f3.getNome(),
                12800.00, 14, "kit",
                "Sistema completo com filtro de discos, tubagem principal PEAD, válvulas e fitas gotejadoras.",
                "img/produtos/rega.jpg", hoje.plusMonths(36));
        store.produtos.addAll(List.of(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12));

        // 4. Campanhas Agrícolas
        Campanha camp1 = new Campanha(store.idCampanha.getAndIncrement(),
                "Campanha 2026/2027 — Época Chuvosa",
                LocalDate.of(2026, 10, 1), LocalDate.of(2027, 6, 30));
        camp1.setAberta(true);

        Campanha camp2 = new Campanha(store.idCampanha.getAndIncrement(),
                "Campanha 2026 — Época Fresca (Regadio)",
                LocalDate.of(2026, 4, 1), LocalDate.of(2026, 9, 30));
        camp2.setAberta(false);

        Campanha camp3 = new Campanha(store.idCampanha.getAndIncrement(),
                "Campanha 2025/2026 — Safra Norte",
                LocalDate.of(2025, 10, 1), LocalDate.of(2026, 5, 31));
        camp3.setAberta(false);
        store.campanhas.addAll(List.of(camp1, camp2, camp3));

        // 5. Cultivos
        Cultivo cu1 = new Cultivo(store.idCultivo.getAndIncrement(), camp1.getId(),
                "Feijão Nhemba", "Macia", 8.0, LocalDate.of(2026, 10, 15));
        Cultivo cu2 = new Cultivo(store.idCultivo.getAndIncrement(), camp1.getId(),
                "Milho Branco", "Matuba ZM523", 14.5, LocalDate.of(2026, 10, 20));
        Cultivo cu3 = new Cultivo(store.idCultivo.getAndIncrement(), camp1.getId(),
                "Mandioca Doce", "Nikwaha", 10.0, LocalDate.of(2026, 10, 5));
        Cultivo cu4 = new Cultivo(store.idCultivo.getAndIncrement(), camp2.getId(),
                "Soja Comercial", "Sana TGx", 12.0, LocalDate.of(2026, 4, 12));
        Cultivo cu5 = new Cultivo(store.idCultivo.getAndIncrement(), camp3.getId(),
                "Gergelim Exportação", "Lindi 02", 6.5, LocalDate.of(2025, 11, 2));
        store.cultivos.addAll(List.of(cu1, cu2, cu3, cu4, cu5));

        // 6. Colheitas
        Colheita co1 = new Colheita(store.idColheita.getAndIncrement(), cu1.getId(),
                LocalDate.of(2026, 10, 25), 3200.0, 22.00);
        Colheita co2 = new Colheita(store.idColheita.getAndIncrement(), cu2.getId(),
                LocalDate.of(2026, 9, 28), 9500.0, 18.50);
        Colheita co3 = new Colheita(store.idColheita.getAndIncrement(), cu3.getId(),
                LocalDate.of(2026, 8, 19), 14200.0, 12.00);
        Colheita co4 = new Colheita(store.idColheita.getAndIncrement(), cu4.getId(),
                LocalDate.of(2026, 7, 30), 6800.0, 35.00);
        Colheita co5 = new Colheita(store.idColheita.getAndIncrement(), cu5.getId(),
                LocalDate.of(2026, 5, 15), 4100.0, 54.00);
        store.colheitas.addAll(List.of(co1, co2, co3, co4, co5));

        // 7. Vendas históricas distribuídas nos últimos 6 meses (para alimentar gráficos e facturas)
        LocalDateTime agora = LocalDateTime.now();
        registarVendaSeed(store, cJoao, agora.minusMonths(5).withDayOfMonth(12),
                List.of(new VendaItem(p2, 25), new VendaItem(p5, 4), new VendaItem(p11, 10)));
        registarVendaSeed(store, cAmina, agora.minusMonths(4).withDayOfMonth(18),
                List.of(new VendaItem(p1, 30), new VendaItem(p6, 6), new VendaItem(p9, 2)));
        registarVendaSeed(store, cCarlos, agora.minusMonths(3).withDayOfMonth(9),
                List.of(new VendaItem(p8, 1), new VendaItem(p5, 8)));
        registarVendaSeed(store, cFatima, agora.minusMonths(2).withDayOfMonth(21),
                List.of(new VendaItem(p3, 40), new VendaItem(p12, 2), new VendaItem(p6, 5)));
        registarVendaSeed(store, cBernardo, agora.minusMonths(1).withDayOfMonth(14),
                List.of(new VendaItem(p10, 1), new VendaItem(p4, 20), new VendaItem(p11, 15)));
        registarVendaSeed(store, cDemo, agora.minusDays(6),
                List.of(new VendaItem(p1, 10), new VendaItem(p5, 2), new VendaItem(p9, 1)));
        registarVendaSeed(store, cJoao, agora.minusDays(2),
                List.of(new VendaItem(p2, 15), new VendaItem(p5, 3), new VendaItem(p11, 6)));
        registarVendaSeed(store, cDemo, agora.minusHours(3),
                List.of(new VendaItem(p4, 12), new VendaItem(p12, 1)));
    }

    private Cliente criarClienteSeNaoExiste(DataStore store, String nome, String email,
                                            String senha, String telefone, String endereco) {
        Utilizador u = store.findUtilizadorByEmail(email);
        if (u instanceof Cliente c) return c;
        Cliente novo = new Cliente(store.idUtilizador.getAndIncrement(),
                nome, email, PasswordUtil.hash(senha), telefone, endereco);
        store.utilizadores.add(novo);
        return novo;
    }

    private void registarVendaSeed(DataStore store, Cliente c, LocalDateTime data, List<VendaItem> itens) {
        Venda v = new Venda();
        v.setId(store.idVenda.getAndIncrement());
        v.setNumeroFactura("FT-" + data.getYear() + "-" + store.numeroFactura.getAndIncrement());
        v.setClienteId(c.getId());
        v.setClienteNome(c.getNome());
        v.setClienteEndereco(c.getEndereco());
        v.setClienteTelefone(c.getTelefone());
        v.setData(data);
        v.setItens(itens);
        v.calcularTotais();
        store.vendas.add(v);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        PersistenciaUtil.gravar();
        System.out.println("Estado gravado.");
    }
}
