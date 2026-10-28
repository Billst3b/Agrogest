<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Cultivos — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="cultivos"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho">
    <div><h2>Gestão de Cultivos</h2><p>Controlo de culturas, variedades e áreas plantadas (hectares) por campanha.</p></div>
    <div class="filtros" style="margin:0">
        <a class="chip ${empty param.ordenar ? 'ativo' : ''}" href="${ctx}/admin/cultivos">Ordem de Registo</a>
        <a class="chip ${param.ordenar == 'nome' ? 'ativo' : ''}" href="${ctx}/admin/cultivos?ordenar=nome">Ordenar: Cultura</a>
        <a class="chip ${param.ordenar == 'data' ? 'ativo' : ''}" href="${ctx}/admin/cultivos?ordenar=data">Ordenar: Data</a>
        <a class="chip ${param.ordenar == 'valor' ? 'ativo' : ''}" href="${ctx}/admin/cultivos?ordenar=valor">Ordenar: Hectares</a>
    </div>
</div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
<section class="painel">
<h3>Registar Novo Cultivo</h3>
<c:choose>
<c:when test="${empty campanhas}"><p class="muted" style="margin:0">Crie primeiro uma <a href="${ctx}/admin/campanhas">campanha agrícola</a>.</p></c:when>
<c:otherwise>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="cu-camp">Campanha Agrícola</label><select id="cu-camp" name="campanhaId" required><c:forEach var="c" items="${campanhas}"><option value="${c.id}"><c:out value="${c.nome}"/></option></c:forEach></select></div>
    <div class="campo"><label for="cu-cult">Cultura</label><input id="cu-cult" type="text" name="cultura" placeholder="Ex.: Feijão nhemba, Milho…" required></div>
    <div class="campo"><label for="cu-var">Variedade</label><input id="cu-var" type="text" name="variedade" placeholder="Ex.: Macia, Matuba…" required></div>
    <div class="campo"><label for="cu-ha">Área Plantada (ha)</label><input id="cu-ha" type="number" step="0.1" min="0.1" name="hectares" required></div>
    <div class="campo"><label for="cu-data">Data de Plantio</label><input id="cu-data" type="date" name="dataPlantio" required></div>
    <div class="botao-linha"><button type="submit">+ Registar Cultivo</button></div>
</form>
</c:otherwise>
</c:choose>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty cultivos}"><div class="vazio"><div class="ico"><span class="i i-rebento"></span></div><p>Nenhum cultivo registado.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Cultivos registados">
<table><thead><tr><th>ID</th><th>Campanha</th><th>Cultura</th><th>Variedade</th><th class="num">Área (Hectares)</th><th>Data de Plantio</th><th class="num">Acções</th></tr></thead><tbody>
<c:forEach var="cu" items="${cultivos}"><tr>
<td class="id">#${cu.id}</td>
<td><c:forEach var="c" items="${campanhas}"><c:if test="${c.id == cu.campanhaId}"><span class="badge">${c.nome}</span></c:if></c:forEach></td>
<td><strong><c:out value="${cu.cultura}"/></strong></td><td><c:out value="${cu.variedade}"/></td><td class="num"><strong>${cu.hectares} ha</strong></td><td>${cu.dataPlantio}</td>
<td class="acoes-linha"><form method="post" onsubmit="return confirm('Remover este cultivo? (Apenas permitido se não tiver colheitas associadas)')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${cu.id}"><button type="submit" class="perigo pequeno">Remover</button></form></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
