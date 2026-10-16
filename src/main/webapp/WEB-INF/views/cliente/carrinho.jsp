<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Carrinho — AgroGest</title></head>
<body>
<c:set var="ativo" value="carrinho"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">
<div class="cabecalho"><div><h2>O meu carrinho</h2></div></div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
<c:choose>
<c:when test="${empty carrinho}">
    <div class="painel vazio"><div class="ico">&#x1F6D2;</div><p>O carrinho está vazio.</p>
        <a class="botao" href="${ctx}/catalogo">Ir às compras</a></div>
</c:when>
<c:otherwise>
<c:set var="soma" value="${0}"/>
<div class="resumo">
    <div class="painel sem-padding"><div class="tabela-wrap">
    <table><thead><tr><th>Produto</th><th class="num">Qtd</th><th class="num">Preço</th><th class="num">Subtotal</th><th></th></tr></thead>
    <tbody>
    <c:forEach var="item" items="${carrinho}" varStatus="s">
        <c:set var="soma" value="${soma + item.subtotal}"/>
        <tr>
            <td><strong><c:out value="${item.produtoNome}"/></strong></td>
            <td class="num">${item.quantidade}</td>
            <td class="num"><fmt:formatNumber value="${item.precoUnitario}" type="currency" currencySymbol="MZN"/></td>
            <td class="num"><fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="MZN"/></td>
            <td class="acoes-linha">
                <form method="post" action="${ctx}/carrinho">
                    <input type="hidden" name="acao" value="remover">
                    <input type="hidden" name="index" value="${s.index}">
                    <button type="submit" class="perigo pequeno" title="Remover">Remover</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody></table></div></div>

    <aside class="painel totais">
        <h3>Resumo</h3>
        <div class="linha"><span class="muted">Subtotal</span><span class="num"><fmt:formatNumber value="${soma}" type="currency" currencySymbol="MZN"/></span></div>
        <div class="linha"><span class="muted">IVA (16%)</span><span class="num"><fmt:formatNumber value="${soma * 0.16}" type="currency" currencySymbol="MZN"/></span></div>
        <div class="linha total"><span>Total</span><span class="num"><fmt:formatNumber value="${soma * 1.16}" type="currency" currencySymbol="MZN"/></span></div>
        <form method="post" action="${ctx}/compra">
            <button class="primario grande bloco">Finalizar compra</button>
        </form>
        <form method="post" action="${ctx}/carrinho" onsubmit="return confirm('Esvaziar o carrinho?')">
            <input type="hidden" name="acao" value="limpar">
            <button class="secundario bloco">Esvaziar carrinho</button>
        </form>
        <a class="botao secundario bloco" style="margin-top:12px" href="${ctx}/catalogo">← Continuar a comprar</a>
    </aside>
</div>
</c:otherwise>
</c:choose>
</main></body></html>
