<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Dashboard — AgroGest</title>
<script src="${pageContext.request.contextPath}/js/graficos.js?v=3" defer></script></head>
<body><div class="app">
<c:set var="ativo" value="dashboard"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Dashboard</h2><p>Visão geral do sistema.</p></div></div>

<div class="cards">
    <a class="stat destaque" href="${ctx}/admin/vendas"><div class="rotulo">Receita total</div><div class="valor"><fmt:formatNumber value="${receitaTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/> <small>MZN</small></div></a>
    <a class="stat" href="${ctx}/admin/vendas"><div class="rotulo"><span class="i i-recibo"></span> Vendas</div><div class="valor">${totalVendas}</div></a>
    <a class="stat" href="${ctx}/admin/relatorios"><div class="rotulo"><span class="i i-pessoas"></span> Clientes</div><div class="valor">${totalClientes}</div></a>
    <a class="stat" href="${ctx}/admin/produtos"><div class="rotulo"><span class="i i-caixa"></span> Produtos</div><div class="valor">${totalProdutos}</div></a>
    <a class="stat" href="${ctx}/admin/fornecedores"><div class="rotulo"><span class="i i-camiao"></span> Fornecedores</div><div class="valor">${totalFornecedores}</div></a>
    <a class="stat" href="${ctx}/admin/campanhas"><div class="rotulo"><span class="i i-calendario"></span> Campanhas</div><div class="valor">${totalCampanhas}</div></a>
</div>

<section class="painel">
    <div class="painel-cab"><h3>Receita mensal</h3><span class="muted">Últimos 6 meses · MZN</span></div>
    <div data-grafico="colunas" data-fonte="d-receita" data-formato="moeda" aria-label="Receita mensal dos últimos 6 meses"></div>
</section>

<div class="duas-colunas">
<section class="painel">
    <div class="painel-cab"><h3>Receita por categoria</h3><span class="muted">MZN</span></div>
    <div data-grafico="barras" data-fonte="d-categoria" data-formato="moeda"></div>
</section>
<section class="painel">
    <div class="painel-cab"><h3>Produtos mais vendidos</h3><span class="muted">Por receita</span></div>
    <div data-grafico="barras" data-fonte="d-top" data-formato="moeda"></div>
</section>
<section class="painel">
    <div class="painel-cab"><h3>Produtos com menos stock</h3><span class="muted">Unidades</span></div>
    <div data-grafico="barras" data-fonte="d-stock" data-formato="inteiro"></div>
</section>
<section class="painel">
    <div class="painel-cab"><h3>Produção por cultura</h3><span class="muted">Colheitas · kg</span></div>
    <div data-grafico="barras" data-fonte="d-producao" data-formato="kg"></div>
</section>
</div>

<section class="painel">
    <h3>Persistência manual</h3>
    <p class="muted" style="margin:0">Grave o estado actual em ficheiro, ou elimine o ficheiro gravado.</p>
    <div class="acoes">
        <form method="post" action="${ctx}/admin/persistencia">
            <input type="hidden" name="acao" value="gravar">
            <button type="submit"><span class="i i-gravar"></span> Gravar estado</button>
        </form>
        <form method="post" action="${ctx}/admin/persistencia" onsubmit="return confirm('Eliminar o ficheiro de estado gravado?')">
            <input type="hidden" name="acao" value="eliminar">
            <button type="submit" class="perigo"><span class="i i-lixo"></span> Eliminar ficheiro</button>
        </form>
    </div>
</section>

<script type="application/json" id="d-receita">${receitaMensalJson}</script>
<script type="application/json" id="d-categoria">${receitaCategoriaJson}</script>
<script type="application/json" id="d-top">${topProdutosJson}</script>
<script type="application/json" id="d-stock">${stockJson}</script>
<script type="application/json" id="d-producao">${producaoJson}</script>
</main></div></body></html>
