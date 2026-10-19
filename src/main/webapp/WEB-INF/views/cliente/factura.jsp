<%@ page contentType="text/html; charset=UTF-8" %>
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
            <span class="marca"><span class="logo"><span class="i i-folha"></span></span> AgroGest</span>
            <p class="muted" style="margin:8px 0 0">Insumos e gestão agrícola</p>
        </div>
        <div class="numero">
            <span class="etiqueta">Factura</span>
            <strong>${venda.numeroFactura}</strong>
            <span class="muted">${venda.data.toString().substring(0, 16).replace('T', ' ')}</span>
        </div>
    </div>
    <div class="dados">
        <div>
            <div class="etiqueta">Facturado a</div>
            <p><strong><c:out value="${venda.clienteNome}"/></strong></p>
            <p><c:out value="${venda.clienteEndereco}"/></p>
            <p><c:out value="${venda.clienteTelefone}"/></p>
        </div>
    </div>
    <table><thead><tr><th>Produto</th><th class="num">Qtd</th><th class="num">Preço unit.</th><th class="num">Subtotal</th></tr></thead>
    <tbody>
    <c:forEach var="i" items="${venda.itens}">
        <tr>
            <td><c:out value="${i.produtoNome}"/></td><td class="num">${i.quantidade}</td>
            <td class="num"><fmt:formatNumber value="${i.precoUnitario}" type="currency" currencySymbol="MZN"/></td>
            <td class="num"><fmt:formatNumber value="${i.subtotal}" type="currency" currencySymbol="MZN"/></td>
        </tr>
    </c:forEach>
    </tbody></table>
    <div class="totais">
        <div class="linha"><span class="muted">Subtotal</span><span class="num"><fmt:formatNumber value="${venda.subtotal}" type="currency" currencySymbol="MZN"/></span></div>
        <div class="linha"><span class="muted">IVA (16%)</span><span class="num"><fmt:formatNumber value="${venda.iva}" type="currency" currencySymbol="MZN"/></span></div>
        <div class="linha total"><span>Total</span><span class="num"><fmt:formatNumber value="${venda.total}" type="currency" currencySymbol="MZN"/></span></div>
    </div>
    <div class="acoes">
        <c:choose>
            <c:when test="${sessionScope.perfil == 'ADMIN'}"><a class="botao secundario" href="${ctx}/admin/vendas">← Voltar às vendas</a></c:when>
            <c:otherwise><a class="botao secundario" href="${ctx}/minhas-compras">← Minhas compras</a></c:otherwise>
        </c:choose>
        <button onclick="window.print()"><span class="i i-impressora"></span> Imprimir</button>
    </div>
</div>
</body></html>
