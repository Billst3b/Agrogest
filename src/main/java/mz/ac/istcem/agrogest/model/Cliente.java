package mz.ac.istcem.agrogest.model;

public class Cliente extends Utilizador {
    private static final long serialVersionUID = 1L;
    private String telefone;
    private String endereco;

    public Cliente() { setPerfil("CLIENTE"); }
    public Cliente(int id, String nome, String email, String hash,
                   String telefone, String endereco) {
        super(id, nome, email, hash, "CLIENTE");
        this.telefone = telefone; this.endereco = endereco;
    }
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    public String getEndereco() { return endereco; }
    public void setEndereco(String endereco) { this.endereco = endereco; }
}
