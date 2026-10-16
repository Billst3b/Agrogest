package mz.ac.istcem.agrogest.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Produto implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String nome;
    private String categoria;
    private int fornecedorId;
    private String fornecedorNome;
    private double preco;
    private int quantidade;
    private String unidade;
    private String descricao;
    private String fotoUrl;
    private LocalDate validade;

    public Produto() {}
    public Produto(int id, String nome, String categoria, int fornecedorId,
                   String fornecedorNome, double preco, int quantidade,
                   String unidade, String descricao, String fotoUrl, LocalDate validade) {
        this.id = id; this.nome = nome; this.categoria = categoria;
        this.fornecedorId = fornecedorId; this.fornecedorNome = fornecedorNome;
        this.preco = preco; this.quantidade = quantidade;
        this.unidade = unidade; this.descricao = descricao;
        this.fotoUrl = fotoUrl; this.validade = validade;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }
    public int getFornecedorId() { return fornecedorId; }
    public void setFornecedorId(int fornecedorId) { this.fornecedorId = fornecedorId; }
    public String getFornecedorNome() { return fornecedorNome; }
    public void setFornecedorNome(String fornecedorNome) { this.fornecedorNome = fornecedorNome; }
    public double getPreco() { return preco; }
    public void setPreco(double preco) { this.preco = preco; }
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    public String getUnidade() { return unidade; }
    public void setUnidade(String unidade) { this.unidade = unidade; }
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }
    public LocalDate getValidade() { return validade; }
    public void setValidade(LocalDate validade) { this.validade = validade; }
}
