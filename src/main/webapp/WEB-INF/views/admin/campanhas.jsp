<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Campanhas Agrícolas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="campanhas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Campanhas Agrícolas</h2><p>Planeamento de épocas de plantio e colheita na província de Nampula.</p></div></div>
<section class="painel">
<h3>Nova Campanha Agrícola</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="c-nome">Designação da Campanha</label><input id="c-nome" type="text" name="nome" placeholder="Ex.: Campanha 2026/2027" required></div>
    <div class="campo"><label for="c-ini">Data de Início</label><input id="c-ini" type="date" name="inicio" required></div>
    <div class="campo"><label for="c-fim">Data de Fim</label><input id="c-fim" type="date" name="fim" required></div>
    <div class="botao-linha"><button type="submit">+ Criar Campanha</button></div>
</form>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty campanhas}"><div class="vazio"><div class="ico"><span class="i i-calendario"></span></div><p>Nenhuma campanha registada.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Campanhas agrícolas">
<table><thead><tr><th>ID</th><th>Nome da Campanha</th><th>Data Início</th><th>Data Fim</th><th>Estado</th><th class="num">Acções</th></tr></thead><tbody>
<c:forEach var="c" items="${campanhas}"><tr>
<td class="id">#${c.id}</td><td><strong><c:out value="${c.nome}"/></strong></td><td>${c.inicio}</td><td>${c.fim}</td>
<td><span class="badge ${c.aberta ? 'aberta' : 'fechada'}">${c.aberta ? '● Aberta' : 'Fechada'}</span></td>
<td class="acoes-linha">
<form method="post"><input type="hidden" name="acao" value="${c.aberta ? 'fechar' : 'reabrir'}"><input type="hidden" name="id" value="${c.id}"><button type="submit" class="secundario pequeno">${c.aberta ? 'Fechar Campanha' : 'Reabrir Campanha'}</button></form>
<form method="post" onsubmit="return confirm('Remover esta campanha? (Apenas permitido se não tiver cultivos associados)')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${c.id}"><button type="submit" class="perigo pequeno">Remover</button></form>
</td></tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
