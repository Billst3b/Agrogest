package mz.ac.istcem.agrogest.util;

import mz.ac.istcem.agrogest.repo.*;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class PersistenciaUtil {
    private static final String FICHEIRO =
            System.getProperty("catalina.base", ".") + "/agrogest_state.ser";

    public static synchronized void gravar() {
        EstadoSistema e = DataStore.getInstance().toEstado();
        File tmp = new File(FICHEIRO + ".tmp");
        File dest = new File(FICHEIRO);
        File bak = new File(FICHEIRO + ".bak");
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(tmp))) {
            oos.writeObject(e);
        } catch (IOException ex) {
            ex.printStackTrace();
            return;
        }
        try {
            if (dest.exists()) {
                Files.copy(dest.toPath(), bak.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            Files.move(tmp.toPath(), dest.toPath(), StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static synchronized void carregar() {
        File f = new File(FICHEIRO);
        File bak = new File(FICHEIRO + ".bak");
        if (!f.exists() && !bak.exists()) return;
        File alvo = f.exists() ? f : bak;
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(alvo))) {
            DataStore.getInstance().fromEstado((EstadoSistema) ois.readObject());
        } catch (Exception ex) {
            ex.printStackTrace();
            try {
                if (f.exists()) {
                    Files.copy(f.toPath(), new File(FICHEIRO + ".corrompido").toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                if (bak.exists() && alvo != bak) {
                    try (ObjectInputStream oisBak = new ObjectInputStream(new FileInputStream(bak))) {
                        DataStore.getInstance().fromEstado((EstadoSistema) oisBak.readObject());
                    }
                }
            } catch (Exception ignored) {}
        }
    }

    public static synchronized void eliminar() {
        new File(FICHEIRO).delete();
        new File(FICHEIRO + ".bak").delete();
    }
}
