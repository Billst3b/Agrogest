<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Relatórios Analíticos — AgroGest</title>
<script src="${pageContext.request.contextPath}/js/graficos.js?v=5" defer></script></head>
<body><div class="app">
<c:set var="ativo" value="relatorios"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Relatórios de Clientes e Vendas</h2><p>Rankings de volume de compra, assiduidade, ordenação alfabética e clientes sem compras.</p></div></div>
<div class="duas-colunas">
<section class="painel">
    <div class="painel-cab"><h3>Volume de Compras por Cliente</h3><span class="muted">Top 8 · MZN</span></div>
    <div data-grafico="barras" data-fonte="d-volume" data-formato="moeda"></div>
</section>
<section class="painel">
    <div class="painel-cab"><h3>Assiduidade de Clientes</h3><span class="muted">Top 8 · nº de compras</span></div>
    <div data-grafico="barras" data-fonte="d-assiduos" data-formato="inteiro"></div>
</section>
<section class="painel sem-padding">
    <div class="painel-titulo"><h3>Clientes que Compraram (Ordenados por Volume)</h3></div>
    <c:choose><c:when test="${empty clientesPorVolume}"><div class="vazio"><p>Sem dados.</p></div></c:when>
    <c:otherwise>
    <div class="tabela-wrap" tabindex="0" role="region" aria-label="Clientes por volume de compras">
    <table><thead><tr><th>Posição &amp; Cliente</th><th class="num">Volume Total</th></tr></thead><tbody>
    <c:forEach var="e" items="${clientesPorVolume}" varStatus="s"><tr><td><span class="rank">${s.count}</span><strong><c:out value="${e.key.nome}"/></strong></td>
    <td class="num"><strong><fmt:formatNumber value="${e.value}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td></tr></c:forEach>
    </tbody></table></div></c:otherwise></c:choose>
</section>
<section class="painel sem-padding">
    <div class="painel-titulo"><h3>Clientes Mais Assíduos (Ranking por Nº de Compras)</h3></div>
    <c:choose><c:when test="${empty clientesAssiduos}"><div class="vazio"><p>Sem dados.</p></div></c:when>
    <c:otherwise>
    <div class="tabela-wrap" tabindex="0" role="region" aria-label="Clientes mais assíduos">
    <table><thead><tr><th>Posição &amp; Cliente</th><th class="num">Nº de Compras</th></tr></thead><tbody>
    <c:forEach var="e" items="${clientesAssiduos}" varStatus="s"><tr><td><span class="rank">${s.count}</span><strong><c:out value="${e.key.nome}"/></strong></td><td class="num"><span class="badge aberta">${e.value} compras</span></td></tr></c:forEach>
    </tbody></table></div></c:otherwise></c:choose>
</section>
<section class="painel">
    <h3>Clientes Ordenados por Nome (Crescente A–Z)</h3>
    <c:choose><c:when test="${empty clientesPorNome}"><p class="muted">Sem clientes registados.</p></c:when>
    <c:otherwise><ul class="lista"><c:forEach var="c" items="${clientesPorNome}"><li><span><strong><c:out value="${c.nome}"/></strong> · <small class="muted"><c:out value="${c.endereco}"/></small></span><span class="muted"><c:out value="${c.email}"/></span></li></c:forEach></ul></c:otherwise></c:choose>
</section>
<section class="painel">
    <h3>Relatório Extra: Clientes sem Compras</h3>
    <c:choose><c:when test="${empty clientesSemCompras}"><p class="muted">Todos os clientes já efectuaram compras.</p></c:when>
    <c:otherwise><ul class="lista"><c:forEach var="c" items="${clientesSemCompras}"><li><span><strong><c:out value="${c.nome}"/></strong> (<c:out value="${c.email}"/>)</span><span class="badge aviso">0 compras</span></li></c:forEach></ul></c:otherwise></c:choose>
</section>
</div>
<script type="application/json" id="d-volume">${volumeJson}</script>
<script type="application/json" id="d-assiduos">${assiduosJson}</script>
</main></div></body></html>
