package mz.ac.istcem.agrogest.model;

import java.io.Serializable;
import java.time.LocalDate;

public class Colheita implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;
    private int cultivoId;
    private LocalDate data;
    private double quantidadeKg;
    private double precoPorKg;
    private double valorTotal;

    public Colheita() {}
    public Colheita(int id, int cultivoId, LocalDate data, double quantidadeKg, double precoPorKg) {
        this.id = id; this.cultivoId = cultivoId; this.data = data;
        this.quantidadeKg = quantidadeKg; this.precoPorKg = precoPorKg;
        this.valorTotal = quantidadeKg * precoPorKg;
    }
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCultivoId() { return cultivoId; }
    public void setCultivoId(int cultivoId) { this.cultivoId = cultivoId; }
    public LocalDate getData() { return data; }
    public void setData(LocalDate data) { this.data = data; }
    public double getQuantidadeKg() { return quantidadeKg; }
    public void setQuantidadeKg(double quantidadeKg) { this.quantidadeKg = quantidadeKg; }
    public double getPrecoPorKg() { return precoPorKg; }
    public void setPrecoPorKg(double precoPorKg) { this.precoPorKg = precoPorKg; }
    public double getValorTotal() { return valorTotal; }
    public void setValorTotal(double valorTotal) { this.valorTotal = valorTotal; }
}
