<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>AgroGest Analytics — Dashboard</title>
<script src="${pageContext.request.contextPath}/js/graficos.js?v=5" defer></script></head>
<body><div class="app">
<c:set var="ativo" value="dashboard"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">

<!-- Top Header Bar (Reference Channel Analytics Style) -->
<div class="cabecalho">
    <div>
        <h2>AgroGest Analytics</h2>
        <p>Gestão integrada de produção agrícola, stock e facturação · Província de Nampula</p>
    </div>
    <div class="topo-acoes">
        <a class="icone-circulo" href="${ctx}/admin/produtos" title="Pesquisar Catálogo e Stock"></a>
        <a class="icone-circulo" href="${ctx}/admin/relatorios" title="Alertas e Relatórios"><span class="ponto-notif"></span></a>
        <div class="avatar-pill">
            <span class="bolha">AG</span>
            <span><c:out value="${sessionScope.nome}"/></span>
        </div>
    </div>
</div>

<!-- Main Bento Grid (Reference Layout) -->
<div class="bento-grid">

    <!-- Left Hero Bento Card ("Optimize Your Metrics") -->
    <section class="hero-bento">
        <div class="hero-bento-corpo">
            <div>
                <span class="etiqueta-topo">Campanha Agrícola Activa · Nampula</span>
                <h1>Optimize a Sua<br>Produção</h1>
                <p class="sub-hero">Controle sementes certificadas, fertilizantes, cultivos por hectare e facturação com IVA em tempo real.</p>
                <a class="btn-pill-branco" href="${ctx}/admin/vendas#nova-venda">Iniciar Venda</a>
            </div>
            <div class="hero-bento-visual">
                <img src="${ctx}/img/produtos/hero-agro.jpg" alt="Produção Agrícola Nampula">
            </div>
        </div>

        <!-- Bottom Frosted 4-Metric Bar inside Hero Card -->
        <div class="hero-metricas-bar">
            <div class="metrica-item">
                <div class="num-grande">${totalClientes}</div>
                <div class="rotulo-mini"><span class="ponto-cor ciano">●</span> Clientes</div>
                <div class="barra-mini ciano"><span></span></div>
            </div>
            <div class="metrica-item">
                <div class="num-grande">${stockTotalUnidades}</div>
                <div class="rotulo-mini"><span class="ponto-cor coral">●</span> Stock (un.)</div>
                <div class="barra-mini coral"><span></span></div>
            </div>
            <div class="metrica-item">
                <div class="num-grande"><fmt:formatNumber value="${receitaTotal / 1000}" minFractionDigits="1" maxFractionDigits="1"/>k</div>
                <div class="rotulo-mini"><span class="ponto-cor verde">●</span> Vendas (MZN)</div>
                <div class="barra-mini verde"><span></span></div>
            </div>
            <div class="metrica-item">
                <div class="num-grande">${totalProdutos}</div>
                <div class="rotulo-mini"><span class="ponto-cor ambar">●</span> Insumos</div>
                <div class="barra-mini ambar"><span></span></div>
            </div>
            <a class="btn-seta-preto" href="${ctx}/admin/relatorios" title="Ver relatórios detalhados">›</a>
        </div>
    </section>

    <!-- Right Stacked Bento Cards -->
    <div class="bento-direita">

        <!-- Top Right: Dual Spline Curve Chart ("Active Users right now") -->
        <section class="card-bento">
            <div class="painel-cab">
                <h3>Evolução de Receita em Tempo Real </h3>
                <span class="badge aberta">Últimos 6 meses</span>
            </div>
            <div data-grafico="curvas" data-fonte="d-receita" data-formato="moeda" aria-label="Evolução da receita mensal nos últimos 6 meses"></div>
        </section>

        <!-- Bottom Right: Latest Sales + Featured Product Card ("Latest Sales $ 586") -->
        <section class="card-bento card-vendas-destaque">
            <div class="vendas-esq">
                <h3>Últimas Vendas</h3>
                <div class="spark-linha">
                    <svg width="64" height="20" viewBox="0 0 64 20" fill="none" aria-hidden="true">
                        <path d="M2 15 Q 14 6, 24 12 T 44 7 T 62 3" stroke="#b4f461" stroke-width="2.4" stroke-linecap="round"/>
                    </svg>
                    <span>+16% IVA</span>
                </div>
                <div class="valor-lima">
                    <fmt:formatNumber value="${not empty ultimaVenda ? ultimaVenda.total : receitaTotal}" type="number" minFractionDigits="0" maxFractionDigits="0"/> MZN
                </div>
                <div class="rotulo-mini">
                    <span class="ponto-cor ciano">●</span>
                    <span>Total colheitas: <fmt:formatNumber value="${valorColheitasTotal / 1000}" maxFractionDigits="1"/>k MZN</span>
                </div>
            </div>

            <c:if test="${not empty produtoDestaque}">
                <c:set var="fotoDest" value="${produtoDestaque.fotoUrl.startsWith('http') ? produtoDestaque.fotoUrl : ctx.concat('/').concat(produtoDestaque.fotoUrl)}"/>
                <a class="inset-produto-card" href="${ctx}/admin/produtos">
                    <img src="<c:out value='${fotoDest}'/>" alt="<c:out value='${produtoDestaque.nome}'/>">
                    <span class="nome-mini"><c:out value="${produtoDestaque.nome}"/></span>
                </a>
            </c:if>
        </section>

    </div>
</div>

<!-- Bottom Full-Width Frosted List ("Your top videos in this period" Reference) -->
<section class="painel">
    <div class="bento-lista-cab">
        <div>
            <h3>Insumos e Produtos de Maior Destaque neste Período</h3>
            <p class="muted" style="margin:2px 0 0; font-size:0.84rem">Catálogo activo sincronizado com o armazém de Nampula (${totalCampanhas} campanhas · ${totalHectares} ha cultivados)</p>
        </div>
        <div class="acoes" style="margin:0">
            <a class="chip ${empty param.ordenar || param.ordenar == 'popular' ? 'ativo' : ''}" href="${ctx}/admin/dashboard?ordenar=popular">Popularidade ▾</a>
            <a class="chip ${param.ordenar == 'preco' ? 'ativo' : ''}" href="${ctx}/admin/dashboard?ordenar=preco">Maior Preço</a>
            <a class="chip ${param.ordenar == 'stock' ? 'ativo' : ''}" href="${ctx}/admin/dashboard?ordenar=stock">Maior Stock</a>
        </div>
    </div>

    <div class="bento-colunas-rotulo">
        <span>PRODUTO / INSUMO</span>
        <span>STOCK EM ARMAZÉM</span>
        <span>PREÇO UNITÁRIO (C/ IVA)</span>
        <span>TENDÊNCIA</span>
        <span>ACÇÃO</span>
    </div>

    <c:forEach var="p" items="${topProdutosLista}">
        <c:set var="fotoP" value="${p.fotoUrl.startsWith('http') ? p.fotoUrl : ctx.concat('/').concat(p.fotoUrl)}"/>
        <div class="linha-bento-item">
            <div class="item-prod-info">
                <div class="item-prod-thumb">
                    <img src="<c:out value='${fotoP}'/>" alt="<c:out value='${p.nome}'/>" loading="lazy">
                </div>
                <div class="item-prod-texto">
                    <strong><c:out value="${p.nome}"/></strong>
                    <small><c:out value="${p.categoria}"/> · <c:out value="${p.fornecedorNome}"/></small>
                </div>
            </div>
            <div>
                <span class="indicador-ponto amarelo">${p.quantidade} <c:out value="${p.unidade}"/> em stock</span>
            </div>
            <div>
                <span class="indicador-ponto verde"><fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN (${empty qtdVendidaPorProduto[p.id] ? 0 : qtdVendidaPorProduto[p.id]} vend.)</span>
            </div>
            <div>
                <svg width="76" height="22" viewBox="0 0 76 22" fill="none" aria-hidden="true">
                    <path d="M2 17 L16 11 L30 14 L46 7 L60 10 L74 4" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
            <div style="text-align:right">
                <a class="botao secundario pequeno" href="${ctx}/admin/produtos">Gerir</a>
            </div>
        </div>
    </c:forEach>
</section>

<!-- Detailed Analytical Panels -->
<div class="duas-colunas">
    <section class="painel">
        <div class="painel-cab"><h3>Receita por Categoria</h3><span class="muted">MZN</span></div>
        <div data-grafico="barras" data-fonte="d-categoria" data-formato="moeda"></div>
    </section>
    <section class="painel">
        <div class="painel-cab"><h3>Produtos Mais Vendidos</h3><span class="muted">Por receita · MZN</span></div>
        <div data-grafico="barras" data-fonte="d-top" data-formato="moeda"></div>
    </section>
    <section class="painel">
        <div class="painel-cab"><h3>Monitorização de Stock Crítico</h3><span class="muted">Unidades disponíveis</span></div>
        <div data-grafico="barras" data-fonte="d-stock" data-formato="inteiro"></div>
    </section>
    <section class="painel">
        <div class="painel-cab"><h3>Produção Agrícola por Cultura</h3><span class="muted">Colheitas · kg</span></div>
        <div data-grafico="barras" data-fonte="d-producao" data-formato="kg"></div>
    </section>
</div>

<section class="painel">
    <div class="painel-cab">
        <div>
            <h3>Persistência Manual em Ficheiro</h3>
            <p class="muted" style="margin:2px 0 0">Grave instantaneamente o estado actual em ficheiro serializado (<code>agrogest_state.ser</code>), ou reinicie o ficheiro gravado.</p>
        </div>
        <div class="acoes" style="margin:0">
            <form method="post" action="${ctx}/admin/persistencia">
                <input type="hidden" name="acao" value="gravar">
                <button type="submit"><span class="i i-gravar"></span> Gravar Estado Agora</button>
            </form>
            <form method="post" action="${ctx}/admin/persistencia" onsubmit="return confirm('Eliminar o ficheiro de estado gravado?')">
                <input type="hidden" name="acao" value="eliminar">
                <button type="submit" class="perigo"><span class="i i-lixo"></span> Eliminar Ficheiro</button>
            </form>
        </div>
    </div>
</section>

<script type="application/json" id="d-receita">${receitaMensalJson}</script>
<script type="application/json" id="d-categoria">${receitaCategoriaJson}</script>
<script type="application/json" id="d-top">${topProdutosJson}</script>
<script type="application/json" id="d-stock">${stockJson}</script>
<script type="application/json" id="d-producao">${producaoJson}</script>
</main></div></body></html>
