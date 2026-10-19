<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Relatórios — AgroGest</title>
<script src="${pageContext.request.contextPath}/js/graficos.js?v=3" defer></script></head>
<body><div class="app">
<c:set var="ativo" value="relatorios"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Relatórios</h2><p>Comportamento dos clientes.</p></div></div>
<div class="duas-colunas">
<section class="painel">
    <div class="painel-cab"><h3>Volume de compras</h3><span class="muted">Top 8 · MZN</span></div>
    <div data-grafico="barras" data-fonte="d-volume" data-formato="moeda"></div>
</section>
<section class="painel">
    <div class="painel-cab"><h3>Assiduidade</h3><span class="muted">Top 8 · nº de compras</span></div>
    <div data-grafico="barras" data-fonte="d-assiduos" data-formato="inteiro"></div>
</section>
<section class="painel sem-padding">
    <div class="painel-titulo"><h3>Clientes por volume de compras</h3></div>
    <c:choose><c:when test="${empty clientesPorVolume}"><div class="vazio"><p>Sem dados.</p></div></c:when>
    <c:otherwise><table><thead><tr><th>Cliente</th><th class="num">Total</th></tr></thead><tbody>
    <c:forEach var="e" items="${clientesPorVolume}" varStatus="s"><tr><td><span class="rank">${s.count}</span><c:out value="${e.key.nome}"/></td>
    <td class="num"><fmt:formatNumber value="${e.value}" type="currency" currencySymbol="MZN"/></td></tr></c:forEach>
    </tbody></table></c:otherwise></c:choose>
</section>
<section class="painel sem-padding">
    <div class="painel-titulo"><h3>Clientes mais assíduos</h3></div>
    <c:choose><c:when test="${empty clientesAssiduos}"><div class="vazio"><p>Sem dados.</p></div></c:when>
    <c:otherwise><table><thead><tr><th>Cliente</th><th class="num">Nº de compras</th></tr></thead><tbody>
    <c:forEach var="e" items="${clientesAssiduos}" varStatus="s"><tr><td><span class="rank">${s.count}</span><c:out value="${e.key.nome}"/></td><td class="num">${e.value}</td></tr></c:forEach>
    </tbody></table></c:otherwise></c:choose>
</section>
<section class="painel">
    <h3>Todos os clientes</h3>
    <c:choose><c:when test="${empty clientesPorNome}"><p class="muted">Sem clientes registados.</p></c:when>
    <c:otherwise><ul class="lista"><c:forEach var="c" items="${clientesPorNome}"><li><span><c:out value="${c.nome}"/></span><span class="muted"><c:out value="${c.email}"/></span></li></c:forEach></ul></c:otherwise></c:choose>
</section>
<section class="painel">
    <h3>Clientes sem compras</h3>
    <c:choose><c:when test="${empty clientesSemCompras}"><p class="muted">Todos os clientes já compraram.</p></c:when>
    <c:otherwise><ul class="lista"><c:forEach var="c" items="${clientesSemCompras}"><li><span><c:out value="${c.nome}"/></span><span class="badge fechada">Sem compras</span></li></c:forEach></ul></c:otherwise></c:choose>
</section>
</div>
<script type="application/json" id="d-volume">${volumeJson}</script>
<script type="application/json" id="d-assiduos">${assiduosJson}</script>
</main></div></body></html>
