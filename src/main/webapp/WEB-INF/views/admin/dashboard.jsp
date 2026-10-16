<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Dashboard — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="dashboard"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Dashboard</h2><p>Visão geral do sistema.</p></div></div>
<div class="cards">
    <a class="stat" href="${ctx}/admin/produtos"><span class="ico">&#x1F4E6;</span><div><div class="valor">${totalProdutos}</div><div class="rotulo">Produtos</div></div></a>
    <a class="stat" href="${ctx}/admin/relatorios"><span class="ico">&#x1F465;</span><div><div class="valor">${totalClientes}</div><div class="rotulo">Clientes</div></div></a>
    <a class="stat" href="${ctx}/admin/vendas"><span class="ico">&#x1F9FE;</span><div><div class="valor">${totalVendas}</div><div class="rotulo">Vendas</div></div></a>
    <a class="stat" href="${ctx}/admin/fornecedores"><span class="ico">&#x1F69A;</span><div><div class="valor">${totalFornecedores}</div><div class="rotulo">Fornecedores</div></div></a>
    <a class="stat" href="${ctx}/admin/campanhas"><span class="ico">&#x1F4C5;</span><div><div class="valor">${totalCampanhas}</div><div class="rotulo">Campanhas</div></div></a>
</div>
<section class="painel">
    <h3>&#x1F4BE; Persistência manual</h3>
    <p class="muted" style="margin:0">Grave o estado actual em ficheiro, ou elimine o ficheiro gravado.</p>
    <div class="acoes">
        <form method="post" action="${ctx}/admin/persistencia">
            <input type="hidden" name="acao" value="gravar">
            <button type="submit">&#x1F4BE; Gravar estado</button>
        </form>
        <form method="post" action="${ctx}/admin/persistencia" onsubmit="return confirm('Eliminar o ficheiro de estado gravado?')">
            <input type="hidden" name="acao" value="eliminar">
            <button type="submit" class="perigo">&#x1F5D1;️ Eliminar ficheiro</button>
        </form>
    </div>
</section>
</main></div></body></html>
