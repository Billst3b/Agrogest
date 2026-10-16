package mz.ac.istcem.agrogest.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Venda implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private String numeroFactura;
    private int clienteId;
    private String clienteNome;
    private String clienteEndereco;
    private String clienteTelefone;
    private LocalDateTime data;
    private List<VendaItem> itens = new ArrayList<>();
    private double subtotal;
    private double iva;
    private double total;

    public Venda() {}
    public void calcularTotais() {
        subtotal = itens.stream().mapToDouble(VendaItem::getSubtotal).sum();
        iva = subtotal * 0.16;
        total = subtotal + iva;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNumeroFactura() { return numeroFactura; }
    public void setNumeroFactura(String numeroFactura) { this.numeroFactura = numeroFactura; }
    public int getClienteId() { return clienteId; }
    public void setClienteId(int clienteId) { this.clienteId = clienteId; }
    public String getClienteNome() { return clienteNome; }
    public void setClienteNome(String clienteNome) { this.clienteNome = clienteNome; }
    public String getClienteEndereco() { return clienteEndereco; }
    public void setClienteEndereco(String clienteEndereco) { this.clienteEndereco = clienteEndereco; }
    public String getClienteTelefone() { return clienteTelefone; }
    public void setClienteTelefone(String clienteTelefone) { this.clienteTelefone = clienteTelefone; }
    public LocalDateTime getData() { return data; }
    public void setData(LocalDateTime data) { this.data = data; }
    public List<VendaItem> getItens() { return itens; }
    public void setItens(List<VendaItem> itens) { this.itens = itens; }
    public double getSubtotal() { return subtotal; }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
    public double getIva() { return iva; }
    public void setIva(double iva) { this.iva = iva; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
}
