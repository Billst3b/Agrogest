<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Factura ${venda.numeroFactura} — AgroGest</title></head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<div class="factura">
    <div class="topo">
        <div>
            <div class="marca" style="margin-bottom:6px">
                <img src="${ctx}/img/logo-crest.png" alt="AgroGest, E.I." class="logo-img">
                <span class="marca-bloco">
                    <span class="marca-texto">Agro<span class="destaque">Gest</span></span>
                    <span class="marca-sub">SISTEMA DE GESTÃO AGRÍCOLA</span>
                </span>
            </div>
            <p class="muted" style="margin:6px 0 2px">Comércio de Insumos e Produção Agrícola · Província de Nampula</p>
            <p class="muted" style="margin:0; font-size:0.82rem">NUIT: 400192837 · Av. do Trabalho, Nampula · Moçambique</p>
        </div>
        <div class="numero">
            <span class="badge aberta" style="align-self:flex-end">FACTURA / RECIBO ORIGINAL</span>
            <strong>${venda.numeroFactura}</strong>
            <span class="muted">Data: ${venda.data.toString().substring(0, 16).replace('T', ' ')}</span>
        </div>
    </div>
    <div class="dados">
        <div>
            <div class="etiqueta">Exmo.(a) Cliente Facturado</div>
            <p><strong><c:out value="${venda.clienteNome}"/></strong></p>
            <p class="muted"><c:out value="${venda.clienteEndereco}"/></p>
        </div>
        <div style="text-align:right">
            <div class="etiqueta">Contacto & Condições</div>
            <p><strong><c:out value="${venda.clienteTelefone}"/></strong></p>
            <p class="muted">Moeda: Metical (MZN) · Pronto Pagamento</p>
        </div>
    </div>
    <div class="tabela-wrap" tabindex="0" role="region" aria-label="Itens da factura">
        <table>
            <thead>
                <tr>
                    <th>Descrição do Insumo / Produto</th>
                    <th class="num">Qtd.</th>
                    <th class="num">Preço Unitário</th>
                    <th class="num">Subtotal</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="i" items="${venda.itens}">
                <tr>
                    <td><strong><c:out value="${i.produtoNome}"/></strong></td>
                    <td class="num">${i.quantidade}</td>
                    <td class="num"><fmt:formatNumber value="${i.precoUnitario}" minFractionDigits="2" maxFractionDigits="2"/> MZN</td>
                    <td class="num"><strong><fmt:formatNumber value="${i.subtotal}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <div class="totais">
        <div class="linha"><span class="muted">Subtotal Ilíquido</span><span class="num"><fmt:formatNumber value="${venda.subtotal}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
        <div class="linha"><span class="muted">IVA (16%)</span><span class="num"><fmt:formatNumber value="${venda.iva}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
        <div class="linha total"><span>Total Geral</span><span class="num"><fmt:formatNumber value="${venda.total}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
    </div>
    <div class="acoes" style="justify-content:space-between; border-top:1px solid rgba(255,255,255,0.1); padding-top:20px; margin-top:28px">
        <c:choose>
            <c:when test="${sessionScope.perfil == 'ADMIN'}"><a class="botao secundario" href="${ctx}/admin/vendas">← Voltar às Vendas</a></c:when>
            <c:otherwise><a class="botao secundario" href="${ctx}/minhas-compras">← Minhas Compras</a></c:otherwise>
        </c:choose>
        <div style="display:flex; gap:10px">
            <c:if test="${sessionScope.perfil != 'ADMIN'}">
                <a class="botao secundario" href="${ctx}/catalogo">Continuar a Comprar</a>
            </c:if>
            <button onclick="window.print()"><span class="i i-impressora"></span> Imprimir Factura (A4)</button>
        </div>
    </div>
</div>
</body></html>
