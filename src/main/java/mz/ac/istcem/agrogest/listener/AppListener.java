package mz.ac.istcem.agrogest.listener;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import mz.ac.istcem.agrogest.model.Administrador;
import mz.ac.istcem.agrogest.repo.DataStore;
import mz.ac.istcem.agrogest.util.*;

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
            System.out.println("✔ Admin criado: admin@agro.mz / admin234");
        }
    }
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        PersistenciaUtil.gravar();
        System.out.println("💾 Estado gravado.");
    }
}
