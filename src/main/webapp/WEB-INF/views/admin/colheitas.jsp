<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Colheitas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="colheitas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Colheitas</h2><p>Produção registada por cultivo.</p></div></div>
<section class="painel">
<h3>Nova colheita</h3>
<c:choose>
<c:when test="${empty cultivos}"><p class="muted" style="margin:0">Registe primeiro um <a href="${ctx}/admin/cultivos">cultivo</a>.</p></c:when>
<c:otherwise>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="co-cult">Cultivo</label><select id="co-cult" name="cultivoId" required><c:forEach var="cu" items="${cultivos}"><option value="${cu.id}"><c:out value="${cu.cultura} (${cu.variedade})"/></option></c:forEach></select></div>
    <div class="campo"><label for="co-data">Data</label><input id="co-data" type="date" name="data" required></div>
    <div class="campo"><label for="co-kg">Quantidade (kg)</label><input id="co-kg" type="number" step="0.1" min="0" name="quantidadeKg" required></div>
    <div class="campo"><label for="co-preco">Preço por kg (MZN)</label><input id="co-preco" type="number" step="0.01" min="0" name="precoPorKg" required></div>
    <div class="botao-linha"><button>+ Registar colheita</button></div>
</form>
</c:otherwise>
</c:choose>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty colheitas}"><div class="vazio"><div class="ico">&#x1F9FA;</div><p>Nenhuma colheita registada.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>ID</th><th>Cultivo</th><th>Data</th><th class="num">Quantidade</th><th class="num">Preço/kg</th><th class="num">Total</th></tr></thead><tbody>
<c:forEach var="co" items="${colheitas}"><tr>
<td class="id">${co.id}</td>
<td><strong><c:forEach var="cu" items="${cultivos}"><c:if test="${cu.id == co.cultivoId}"><c:out value="${cu.cultura}"/></c:if></c:forEach></strong></td>
<td>${co.data}</td><td class="num">${co.quantidadeKg} kg</td>
<td class="num"><fmt:formatNumber value="${co.precoPorKg}" type="currency" currencySymbol="MZN"/></td>
<td class="num"><strong><fmt:formatNumber value="${co.valorTotal}" type="currency" currencySymbol="MZN"/></strong></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
