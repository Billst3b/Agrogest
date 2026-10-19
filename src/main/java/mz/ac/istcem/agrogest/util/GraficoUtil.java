package mz.ac.istcem.agrogest.util;

import java.util.List;
import java.util.Map;

/** Serializa séries (rótulo -> valor) em JSON para os gráficos das views. */
public class GraficoUtil {
    public static String json(List<? extends Map.Entry<String, ? extends Number>> serie) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < serie.size(); i++) {
            Map.Entry<String, ? extends Number> e = serie.get(i);
            if (i > 0) sb.append(',');
            sb.append("{\"r\":\"").append(escapar(e.getKey())).append("\",\"v\":")
              .append(e.getValue().doubleValue()).append('}');
        }
        return sb.append(']').toString();
    }

    private static String escapar(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '"': sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '<': sb.append("\\u003c"); break;
                case '>': sb.append("\\u003e"); break;
                case '&': sb.append("\\u0026"); break;
                default:
                    if (c < 0x20) sb.append(String.format("\\u%04x", (int) c));
                    else sb.append(c);
            }
        }
        return sb.toString();
    }
}
