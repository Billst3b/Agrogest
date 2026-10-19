<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Produtos — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="produtos"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Produtos</h2><p>Catálogo e gestão de stock.</p></div></div>
<section class="painel">
<h3>Novo produto</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="p-nome">Nome</label><input id="p-nome" type="text" name="nome" required></div>
    <div class="campo"><label for="p-cat">Categoria</label><select id="p-cat" name="categoria"><option>SEMENTE</option><option>FERTILIZANTE</option><option>MAQUINARIA</option><option>FERRAMENTA</option></select></div>
    <div class="campo"><label for="p-forn">Fornecedor</label><select id="p-forn" name="fornecedorId" required><c:forEach var="f" items="${fornecedores}"><option value="${f.id}"><c:out value="${f.nome}"/></option></c:forEach></select></div>
    <div class="campo"><label for="p-preco">Preço (MZN)</label><input id="p-preco" type="number" step="0.01" min="0" name="preco" required></div>
    <div class="campo"><label for="p-qtd">Quantidade</label><input id="p-qtd" type="number" min="0" name="quantidade" required></div>
    <div class="campo"><label for="p-un">Unidade</label><input id="p-un" type="text" name="unidade" placeholder="kg, saco, un…" required></div>
    <div class="campo"><label for="p-val">Validade</label><input id="p-val" type="date" name="validade"></div>
    <div class="campo largo"><label for="p-desc">Descrição</label><input id="p-desc" type="text" name="descricao"></div>
    <div class="campo largo"><label for="p-foto">URL da foto</label><input id="p-foto" type="url" name="fotoUrl" placeholder="https://…"></div>
    <div class="botao-linha"><button>+ Criar produto</button></div>
</form>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty produtos}"><div class="vazio"><div class="ico"><span class="i i-caixa"></span></div><p>Nenhum produto registado.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>ID</th><th>Nome</th><th>Categoria</th><th>Fornecedor</th><th class="num">Preço</th><th class="num">Stock</th><th class="num">Ações</th></tr></thead><tbody>
<c:forEach var="p" items="${produtos}"><tr>
<td class="id">${p.id}</td><td><strong><c:out value="${p.nome}"/></strong></td><td><span class="badge">${p.categoria}</span></td>
<td><c:out value="${p.fornecedorNome}"/></td>
<td class="num"><fmt:formatNumber value="${p.preco}" type="currency" currencySymbol="MZN"/></td>
<td class="num"><c:choose>
    <c:when test="${p.quantidade == 0}"><span class="badge alerta">Esgotado</span></c:when>
    <c:when test="${p.quantidade < 10}"><span class="badge aviso">${p.quantidade} ${p.unidade}</span></c:when>
    <c:otherwise>${p.quantidade} ${p.unidade}</c:otherwise>
</c:choose></td>
<td class="acoes-linha">
<form method="post"><input type="hidden" name="acao" value="repor"><input type="hidden" name="id" value="${p.id}">
<input type="number" name="quantidade" placeholder="+Qtd" min="1" required aria-label="Quantidade a repor"><button class="secundario pequeno">Repor</button></form>
<form method="post" onsubmit="return confirm('Remover este produto?')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${p.id}"><button class="perigo pequeno">Remover</button></form>
</td></tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
