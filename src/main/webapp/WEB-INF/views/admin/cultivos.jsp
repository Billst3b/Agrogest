<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Cultivos — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="cultivos"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Cultivos</h2><p>O que foi plantado em cada campanha.</p></div></div>
<section class="painel">
<h3>Novo cultivo</h3>
<c:choose>
<c:when test="${empty campanhas}"><p class="muted" style="margin:0">Crie primeiro uma <a href="${ctx}/admin/campanhas">campanha</a>.</p></c:when>
<c:otherwise>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="cu-camp">Campanha</label><select id="cu-camp" name="campanhaId" required><c:forEach var="c" items="${campanhas}"><option value="${c.id}"><c:out value="${c.nome}"/></option></c:forEach></select></div>
    <div class="campo"><label for="cu-cult">Cultura</label><input id="cu-cult" type="text" name="cultura" placeholder="Ex.: Milho" required></div>
    <div class="campo"><label for="cu-var">Variedade</label><input id="cu-var" type="text" name="variedade" required></div>
    <div class="campo"><label for="cu-ha">Hectares</label><input id="cu-ha" type="number" step="0.1" min="0" name="hectares" required></div>
    <div class="campo"><label for="cu-data">Data de plantio</label><input id="cu-data" type="date" name="dataPlantio" required></div>
    <div class="botao-linha"><button>+ Criar cultivo</button></div>
</form>
</c:otherwise>
</c:choose>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty cultivos}"><div class="vazio"><div class="ico">&#x1F331;</div><p>Nenhum cultivo registado.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>ID</th><th>Campanha</th><th>Cultura</th><th>Variedade</th><th class="num">Hectares</th><th>Plantio</th><th></th></tr></thead><tbody>
<c:forEach var="cu" items="${cultivos}"><tr>
<td class="id">${cu.id}</td>
<td><c:forEach var="c" items="${campanhas}"><c:if test="${c.id == cu.campanhaId}"><c:out value="${c.nome}"/></c:if></c:forEach></td>
<td><strong><c:out value="${cu.cultura}"/></strong></td><td><c:out value="${cu.variedade}"/></td><td class="num">${cu.hectares} ha</td><td>${cu.dataPlantio}</td>
<td class="acoes-linha"><form method="post" onsubmit="return confirm('Remover este cultivo?')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${cu.id}"><button class="perigo pequeno">Remover</button></form></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
