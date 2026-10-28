<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Catálogo de Insumos — AgroGest</title></head>
<body>
<c:set var="ativo" value="catalogo"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">

<!-- Featured Client Hero Glass Card -->
<section class="hero-bento" style="min-height:auto; margin-bottom:26px; padding:26px 30px">
    <div class="hero-bento-corpo">
        <div>
            <span class="etiqueta-topo">Armazém Central de Nampula · Stock Verificado</span>
            <h1 style="font-size:clamp(1.6rem, 1.2rem + 1.2vw, 2.3rem)">Catálogo Agrícola — Campanha 2026/2027</h1>
            <p class="sub-hero" style="margin-bottom:16px">Sementes certificadas, fertilizantes granulados, maquinaria agrícola e sistemas de rega prontos para entrega imediata com emissão de factura oficial.</p>
            <div style="display:flex; gap:10px; flex-wrap:wrap">
                <a class="btn-pill-branco" href="${ctx}/carrinho"><span class="i i-carrinho"></span> Ver Carrinho (${empty sessionScope.carrinho ? 0 : sessionScope.carrinho.size()})</a>
                <a class="botao secundario" href="${ctx}/minhas-compras"><span class="i i-recibo"></span> Histórico de Facturas</a>
            </div>
        </div>
        <div class="hero-bento-visual">
            <img src="${ctx}/img/produtos/hero-agro.jpg" alt="Catálogo AgroGest">
        </div>
    </div>
</section>

<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>

<!-- Category Filter Chips & Search/Sort Bar -->
<c:set var="catSel" value="${param.categoria}"/>
<div class="catalogo-barra">
    <nav class="filtros" style="margin-bottom:0" aria-label="Filtrar por categoria">
        <a class="chip ${empty catSel ? 'ativo' : ''}" href="${ctx}/catalogo">Todos (${totalDisponiveis})</a>
        <a class="chip ${catSel == 'SEMENTE' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=SEMENTE"><span class="i i-folha"></span> Sementes (${empty contagemPorCat['SEMENTE'] ? 0 : contagemPorCat['SEMENTE']})</a>
        <a class="chip ${catSel == 'FERTILIZANTE' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=FERTILIZANTE"><span class="i i-caixa"></span> Fertilizantes (${empty contagemPorCat['FERTILIZANTE'] ? 0 : contagemPorCat['FERTILIZANTE']})</a>
        <a class="chip ${catSel == 'MAQUINARIA' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=MAQUINARIA"><span class="i i-camiao"></span> Maquinaria (${empty contagemPorCat['MAQUINARIA'] ? 0 : contagemPorCat['MAQUINARIA']})</a>
        <a class="chip ${catSel == 'FERRAMENTA' ? 'ativo' : ''}" href="${ctx}/catalogo?categoria=FERRAMENTA"><span class="i i-check"></span> Ferramentas (${empty contagemPorCat['FERRAMENTA'] ? 0 : contagemPorCat['FERRAMENTA']})</a>
    </nav>

    <form method="get" action="${ctx}/catalogo" class="catalogo-pesquisa">
        <c:if test="${not empty catSel}"><input type="hidden" name="categoria" value="<c:out value='${catSel}'/>"></c:if>
        <input type="search" name="q" value="<c:out value='${param.q}'/>" placeholder="Pesquisar produto ou fornecedor…">
        <select name="ordenar" onchange="this.form.submit()" aria-label="Ordenar produtos">
            <option value="">Ordenar por…</option>
            <option value="nome" ${param.ordenar == 'nome' ? 'selected' : ''}>Nome (A–Z)</option>
            <option value="preco_asc" ${param.ordenar == 'preco_asc' ? 'selected' : ''}>Menor Preço</option>
            <option value="preco_desc" ${param.ordenar == 'preco_desc' ? 'selected' : ''}>Maior Preço</option>
            <option value="stock" ${param.ordenar == 'stock' ? 'selected' : ''}>Maior Stock</option>
        </select>
        <button type="submit" class="secundario pequeno">Filtrar</button>
    </form>
</div>

<c:choose>
<c:when test="${empty produtos}">
    <div class="painel vazio">
        <div class="ico"><span class="i i-caixa"></span></div>
        <p>Não foram encontrados produtos para os filtros seleccionados.</p>
        <a class="botao secundario" href="${ctx}/catalogo">Limpar Filtros</a>
    </div>
</c:when>
<c:otherwise>
<div class="grid">
<c:forEach var="p" items="${produtos}">
    <c:set var="fotoUrlResolvida" value="${p.fotoUrl.startsWith('http') ? p.fotoUrl : ctx.concat('/').concat(p.fotoUrl)}"/>
    <article class="produto">
        <div class="foto">
            <c:choose>
                <c:when test="${not empty p.fotoUrl}">
                    <img src="<c:out value='${fotoUrlResolvida}'/>" alt="<c:out value='${p.nome}'/>" loading="lazy">
                </c:when>
                <c:when test="${p.categoria == 'SEMENTE'}"><span class="i i-rebento"></span></c:when>
                <c:when test="${p.categoria == 'FERTILIZANTE'}"><span class="i i-frasco"></span></c:when>
                <c:when test="${p.categoria == 'MAQUINARIA'}"><span class="i i-tractor"></span></c:when>
                <c:otherwise><span class="i i-ferramenta"></span></c:otherwise>
            </c:choose>
        </div>
        <div class="corpo">
            <div style="display:flex; justify-content:space-between; align-items:center; gap:8px">
                <span class="badge ${p.categoria == 'SEMENTE' ? 'aberta' : p.categoria == 'FERTILIZANTE' ? 'azul' : 'aviso'}"><c:out value="${p.categoria}"/></span>
                <c:choose>
                    <c:when test="${p.quantidade <= 0}"><span class="badge alerta">Esgotado (0 ${p.unidade})</span></c:when>
                    <c:when test="${p.quantidade < 10}"><span class="badge aviso">Últimas ${p.quantidade} ${p.unidade}</span></c:when>
                    <c:otherwise><span class="badge">Stock: ${p.quantidade} ${p.unidade}</span></c:otherwise>
                </c:choose>
            </div>
            <h3><c:out value="${p.nome}"/></h3>
            <p class="desc"><c:out value="${p.descricao}"/></p>
            <div class="meta-forn">
                <span><c:out value="${p.fornecedorNome}"/></span>
                <c:if test="${not empty p.validade}"><span>⏳ Val: ${p.validade}</span></c:if>
            </div>
            <div class="linha">
                <span class="preco"><fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span>
                <span class="stock">por <c:out value="${p.unidade}"/></span>
            </div>
            <c:choose>
                <c:when test="${p.quantidade <= 0}">
                    <button type="button" class="secundario bloco" disabled style="opacity:0.5; cursor:not-allowed">Indisponível em Stock</button>
                </c:when>
                <c:otherwise>
                    <form method="post" action="${ctx}/carrinho">
                        <input type="hidden" name="acao" value="adicionar">
                        <input type="hidden" name="produtoId" value="${p.id}">
                        <input type="number" name="quantidade" value="1" min="1" aria-label="Quantidade">
                        <button type="submit"><span class="i i-carrinho"></span> Adicionar</button>
                    </form>
                </c:otherwise>
            </c:choose>
        </div>
    </article>
</c:forEach>
</div>
</c:otherwise>
</c:choose>
</main></body></html>
