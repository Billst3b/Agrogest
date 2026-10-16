<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Catálogo — AgroGest</title></head>
<body>
<c:set var="ativo" value="catalogo"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">
<div class="cabecalho">
    <div><h2>Catálogo de produtos</h2><p>Insumos disponíveis em stock.</p></div>
</div>
<c:set var="catSel" value="${param.categoria}"/>
<nav class="filtros" aria-label="Filtrar por categoria">
    <a class="chip ${empty catSel ? 'ativo' : ''}" href="${ctx}/catalogo">Todas</a>
    <a class="chip ${catSel == 'SEMENTE' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=SEMENTE">&#x1F331; Sementes</a>
    <a class="chip ${catSel == 'FERTILIZANTE' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=FERTILIZANTE">&#x1F9EA; Fertilizantes</a>
    <a class="chip ${catSel == 'MAQUINARIA' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=MAQUINARIA">&#x1F69C; Maquinaria</a>
    <a class="chip ${catSel == 'FERRAMENTA' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=FERRAMENTA">&#x1F6E0;️ Ferramentas</a>
</nav>
<c:choose>
<c:when test="${empty produtos}">
    <div class="painel vazio"><div class="ico">&#x1F4ED;</div><p>Não há produtos disponíveis nesta categoria.</p>
        <a class="botao secundario" href="${ctx}/catalogo">Ver todos</a></div>
</c:when>
<c:otherwise>
<div class="grid">
<c:forEach var="p" items="${produtos}">
    <article class="produto">
        <div class="foto">
            <c:choose>
                <c:when test="${not empty p.fotoUrl}"><img src="<c:out value='${p.fotoUrl}'/>" alt="<c:out value='${p.nome}'/>" loading="lazy"></c:when>
                <c:when test="${p.categoria == 'SEMENTE'}">&#x1F331;</c:when>
                <c:when test="${p.categoria == 'FERTILIZANTE'}">&#x1F9EA;</c:when>
                <c:when test="${p.categoria == 'MAQUINARIA'}">&#x1F69C;</c:when>
                <c:otherwise>&#x1F6E0;&#xFE0F;</c:otherwise>
            </c:choose>
        </div>
        <div class="corpo">
            <span><span class="badge">${p.categoria}</span></span>
            <h3><c:out value="${p.nome}"/></h3>
            <p class="desc"><c:out value="${p.descricao}"/></p>
            <div class="linha">
                <span class="preco"><fmt:formatNumber value="${p.preco}" type="currency" currencySymbol="MZN"/></span>
                <span class="stock">${p.quantidade} ${p.unidade} em stock</span>
            </div>
            <form method="post" action="${ctx}/carrinho">
                <input type="hidden" name="acao" value="adicionar">
                <input type="hidden" name="produtoId" value="${p.id}">
                <input type="number" name="quantidade" value="1" min="1" max="${p.quantidade}" aria-label="Quantidade">
                <button type="submit">&#x1F6D2; Adicionar</button>
            </form>
        </div>
    </article>
</c:forEach>
</div>
</c:otherwise>
</c:choose>
</main></body></html>
