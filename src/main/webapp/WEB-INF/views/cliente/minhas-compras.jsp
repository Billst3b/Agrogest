<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Minhas compras — AgroGest</title></head>
<body>
<c:set var="ativo" value="compras"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">
<div class="cabecalho"><div><h2>Histórico de compras</h2><p>As suas facturas anteriores.</p></div></div>
<c:choose>
<c:when test="${empty vendas}">
    <div class="painel vazio"><div class="ico">&#x1F9FE;</div><p>Ainda não efectuou compras.</p>
        <a class="botao" href="${ctx}/catalogo">Ver catálogo</a></div>
</c:when>
<c:otherwise>
<div class="painel sem-padding"><div class="tabela-wrap">
<table><thead><tr><th>Factura</th><th>Data</th><th class="num">Total</th><th></th></tr></thead>
<tbody>
<c:forEach var="v" items="${vendas}">
<tr>
<td><strong>${v.numeroFactura}</strong></td>
<td class="muted">${v.data.toString().substring(0, 16).replace('T', ' ')}</td>
<td class="num"><fmt:formatNumber value="${v.total}" type="currency" currencySymbol="MZN"/></td>
<td class="acoes-linha"><a class="botao secundario pequeno" href="${ctx}/factura?id=${v.id}">Ver factura</a></td>
</tr>
</c:forEach>
</tbody></table></div></div>
</c:otherwise>
</c:choose>
</main></body></html>
