package mz.ac.istcem.agrogest.util;

import mz.ac.istcem.agrogest.repo.*;

import java.io.*;

public class PersistenciaUtil {
    private static final String FICHEIRO =
            System.getProperty("catalina.base", ".") + "/agrogest_state.ser";

    public static synchronized void gravar() {
        EstadoSistema e = DataStore.getInstance().toEstado();
        File tmp = new File(FICHEIRO + ".tmp");
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(tmp))) {
            oos.writeObject(e);
        } catch (IOException ex) { ex.printStackTrace(); return; }
        tmp.renameTo(new File(FICHEIRO));
    }
    public static synchronized void carregar() {
        File f = new File(FICHEIRO);
        if (!f.exists()) return;
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(f))) {
            DataStore.getInstance().fromEstado((EstadoSistema) ois.readObject());
        } catch (Exception ex) { ex.printStackTrace(); }
    }
    public static synchronized void eliminar() {
        new File(FICHEIRO).delete();
    }
}
