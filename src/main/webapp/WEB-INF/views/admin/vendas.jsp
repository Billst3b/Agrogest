<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Vendas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="vendas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Vendas</h2><p>Todas as facturas emitidas.</p></div></div>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty vendas}"><div class="vazio"><div class="ico">&#x1F9FE;</div><p>Ainda não há vendas.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>Factura</th><th>Cliente</th><th>Data</th><th class="num">Total</th><th></th></tr></thead><tbody>
<c:forEach var="v" items="${vendas}"><tr>
<td><strong>${v.numeroFactura}</strong></td><td><c:out value="${v.clienteNome}"/></td>
<td class="muted">${v.data.toString().substring(0, 16).replace('T', ' ')}</td>
<td class="num"><fmt:formatNumber value="${v.total}" type="currency" currencySymbol="MZN"/></td>
<td class="acoes-linha"><a class="botao secundario pequeno" href="${ctx}/factura?id=${v.id}">Ver factura</a></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
