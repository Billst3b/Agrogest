package mz.ac.istcem.agrogest.model;

public class Administrador extends Utilizador {
    public Administrador() { setPerfil("ADMIN"); }
    public Administrador(int id, String nome, String email, String hash) {
        super(id, nome, email, hash, "ADMIN");
    }
}
