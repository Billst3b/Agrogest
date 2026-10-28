<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Minhas Compras — AgroGest</title></head>
<body>
<c:set var="ativo" value="compras"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">
<div class="cabecalho">
    <div>
        <h2>Histórico de Compras e Facturas</h2>
        <p>Consulte e imprima todas as facturas emitidas para a sua conta.</p>
    </div>
    <a class="botao" href="${ctx}/catalogo">+ Nova Encomenda</a>
</div>
<c:choose>
<c:when test="${empty vendas}">
    <div class="painel vazio">
        <div class="ico"><span class="i i-recibo"></span></div>
        <p>Ainda não efectuou compras nesta conta.</p>
        <a class="botao" href="${ctx}/catalogo">Explorar Catálogo</a>
    </div>
</c:when>
<c:otherwise>
<div class="painel sem-padding">
    <div class="tabela-wrap" tabindex="0" role="region" aria-label="Histórico de facturas">
        <table>
            <thead>
                <tr>
                    <th>Nº Factura</th>
                    <th>Data e Hora</th>
                    <th>Itens Adquiridos</th>
                    <th class="num">Subtotal</th>
                    <th class="num">IVA (16%)</th>
                    <th class="num">Total Pago</th>
                    <th class="num">Acção</th>
                </tr>
            </thead>
            <tbody>
            <c:forEach var="v" items="${vendas}">
                <tr>
                    <td><span class="badge aberta">${v.numeroFactura}</span></td>
                    <td class="muted">${v.data.toString().substring(0, 16).replace('T', ' ')}</td>
                    <td>
                        <c:forEach var="it" items="${v.itens}" varStatus="st">
                            <c:out value="${it.quantidade}x ${it.produtoNome}"/><c:if test="${!st.last}">, </c:if>
                        </c:forEach>
                    </td>
                    <td class="num"><fmt:formatNumber value="${v.subtotal}" minFractionDigits="2" maxFractionDigits="2"/> MZN</td>
                    <td class="num"><fmt:formatNumber value="${v.iva}" minFractionDigits="2" maxFractionDigits="2"/> MZN</td>
                    <td class="num"><strong><fmt:formatNumber value="${v.total}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
                    <td class="acoes-linha"><a class="botao secundario pequeno" href="${ctx}/factura?id=${v.id}"><span class="i i-impressora"></span> Ver / Imprimir</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>
</c:otherwise>
</c:choose>
</main></body></html>
