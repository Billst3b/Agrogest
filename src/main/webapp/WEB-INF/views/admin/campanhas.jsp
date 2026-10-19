<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Campanhas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="campanhas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Campanhas</h2><p>Períodos agrícolas de plantio e colheita.</p></div></div>
<section class="painel">
<h3>Nova campanha</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="c-nome">Nome</label><input id="c-nome" type="text" name="nome" placeholder="Ex.: 2026/27" required></div>
    <div class="campo"><label for="c-ini">Início</label><input id="c-ini" type="date" name="inicio" required></div>
    <div class="campo"><label for="c-fim">Fim</label><input id="c-fim" type="date" name="fim" required></div>
    <div class="botao-linha"><button>+ Criar campanha</button></div>
</form>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty campanhas}"><div class="vazio"><div class="ico"><span class="i i-calendario"></span></div><p>Nenhuma campanha registada.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>ID</th><th>Nome</th><th>Início</th><th>Fim</th><th>Estado</th><th class="num">Ações</th></tr></thead><tbody>
<c:forEach var="c" items="${campanhas}"><tr>
<td class="id">${c.id}</td><td><strong><c:out value="${c.nome}"/></strong></td><td>${c.inicio}</td><td>${c.fim}</td>
<td><span class="badge ${c.aberta ? 'aberta' : 'fechada'}">${c.aberta ? 'Aberta' : 'Fechada'}</span></td>
<td class="acoes-linha">
<form method="post"><input type="hidden" name="acao" value="${c.aberta ? 'fechar' : 'reabrir'}"><input type="hidden" name="id" value="${c.id}"><button class="secundario pequeno">${c.aberta ? 'Fechar' : 'Reabrir'}</button></form>
<form method="post" onsubmit="return confirm('Remover esta campanha?')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${c.id}"><button class="perigo pequeno">Remover</button></form>
</td></tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
