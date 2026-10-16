package mz.ac.istcem.agrogest.model;

import java.io.Serializable;

public class VendaItem implements Serializable {
    private static final long serialVersionUID = 1L;
    private int produtoId;
    private String produtoNome;
    private int quantidade;
    private double precoUnitario;
    private double subtotal;

    public VendaItem() {}
    public VendaItem(Produto p, int quantidade) {
        this.produtoId = p.getId();
        this.produtoNome = p.getNome();
        this.quantidade = quantidade;
        this.precoUnitario = p.getPreco();
        this.subtotal = quantidade * p.getPreco();
    }
    public int getProdutoId() { return produtoId; }
    public void setProdutoId(int produtoId) { this.produtoId = produtoId; }
    public String getProdutoNome() { return produtoNome; }
    public void setProdutoNome(String produtoNome) { this.produtoNome = produtoNome; }
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    public double getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(double precoUnitario) { this.precoUnitario = precoUnitario; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
}
