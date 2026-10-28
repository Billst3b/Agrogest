<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Colheitas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="colheitas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho">
    <div><h2>Registo de Colheitas</h2><p>Produção obtida em quilogramas (kg) e cálculo automático do valor total da safra.</p></div>
    <div class="filtros" style="margin:0">
        <a class="chip ${empty param.ordenar ? 'ativo' : ''}" href="${ctx}/admin/colheitas">Ordem de Registo</a>
        <a class="chip ${param.ordenar == 'data' ? 'ativo' : ''}" href="${ctx}/admin/colheitas?ordenar=data">Ordenar: Data</a>
        <a class="chip ${param.ordenar == 'quantidade' ? 'ativo' : ''}" href="${ctx}/admin/colheitas?ordenar=quantidade">Ordenar: Quantidade</a>
        <a class="chip ${param.ordenar == 'valor' ? 'ativo' : ''}" href="${ctx}/admin/colheitas?ordenar=valor">Ordenar: Valor Total</a>
    </div>
</div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
<section class="painel">
<h3>Nova Colheita</h3>
<c:choose>
<c:when test="${empty cultivos}"><p class="muted" style="margin:0">Registe primeiro um <a href="${ctx}/admin/cultivos">cultivo</a>.</p></c:when>
<c:otherwise>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="co-cult">Cultivo Associado</label><select id="co-cult" name="cultivoId" required><c:forEach var="cu" items="${cultivos}"><option value="${cu.id}"><c:out value="${cu.cultura} — ${cu.variedade} (${cu.hectares} ha · Plantio: ${cu.dataPlantio})"/></option></c:forEach></select></div>
    <div class="campo"><label for="co-data">Data da Colheita</label><input id="co-data" type="date" name="data" required></div>
    <div class="campo"><label for="co-kg">Quantidade Colhida (kg)</label><input id="co-kg" type="number" step="0.1" min="1" name="quantidadeKg" placeholder="Ex.: 3200" required></div>
    <div class="campo"><label for="co-preco">Preço por kg (MZN)</label><input id="co-preco" type="number" step="0.01" min="0.1" name="precoPorKg" placeholder="Ex.: 22.00" required></div>
    <div class="botao-linha"><button type="submit">+ Registar Colheita</button></div>
</form>
</c:otherwise>
</c:choose>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty colheitas}"><div class="vazio"><div class="ico"><span class="i i-cesto"></span></div><p>Nenhuma colheita registada.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Colheitas registadas">
<table><thead><tr><th>ID</th><th>Cultura / Variedade</th><th>Data</th><th class="num">Quantidade Colhida</th><th class="num">Preço / kg</th><th class="num">Valor Total Calculado</th></tr></thead><tbody>
<c:forEach var="co" items="${colheitas}"><tr>
<td class="id">#${co.id}</td>
<td><strong><c:forEach var="cu" items="${cultivos}"><c:if test="${cu.id == co.cultivoId}"><c:out value="${cu.cultura} (${cu.variedade})"/></c:if></c:forEach></strong></td>
<td>${co.data}</td>
<td class="num"><span class="badge aberta"><fmt:formatNumber value="${co.quantidadeKg}" maxFractionDigits="1"/> kg</span></td>
<td class="num"><fmt:formatNumber value="${co.precoPorKg}" minFractionDigits="2" maxFractionDigits="2"/> MZN</td>
<td class="num"><strong><fmt:formatNumber value="${co.valorTotal}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
