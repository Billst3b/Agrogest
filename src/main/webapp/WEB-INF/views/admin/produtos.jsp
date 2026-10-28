<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Produtos e Stock — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="produtos"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho">
    <div>
        <h2>Catálogo de Produtos e Armazém</h2>
        <p>Gestão de insumos agrícolas, preços, validades e reposição de stock.</p>
    </div>
    <div class="filtros" style="margin:0">
        <a class="chip ${empty param.filtro ? 'ativo' : ''}" href="${ctx}/admin/produtos">Todos</a>
        <a class="chip ${param.filtro == 'armazem' ? 'ativo' : ''}" href="${ctx}/admin/produtos?filtro=armazem">Em Armazém (Stock &gt; 0)</a>
        <a class="chip ${param.ordenar == 'nome' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=nome&filtro=${param.filtro}">Ordenar: Nome</a>
        <a class="chip ${param.ordenar == 'preco' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=preco&filtro=${param.filtro}">Ordenar: Preço</a>
        <a class="chip ${param.ordenar == 'stock' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=stock&filtro=${param.filtro}">Ordenar: Stock</a>
    </div>
</div>

<section class="painel">
<h3>Registar Novo Produto</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="p-nome">Nome do Produto</label><input id="p-nome" type="text" name="nome" placeholder="Ex.: Semente Feijão Nhemba" required></div>
    <div class="campo"><label for="p-cat">Categoria</label><select id="p-cat" name="categoria"><option>SEMENTE</option><option>FERTILIZANTE</option><option>MAQUINARIA</option><option>FERRAMENTA</option></select></div>
    <div class="campo"><label for="p-forn">Fornecedor</label><select id="p-forn" name="fornecedorId" required><c:forEach var="f" items="${fornecedores}"><option value="${f.id}"><c:out value="${f.nome}"/></option></c:forEach></select></div>
    <div class="campo"><label for="p-preco">Preço Unitário (MZN)</label><input id="p-preco" type="number" step="0.01" min="0" name="preco" required></div>
    <div class="campo"><label for="p-qtd">Quantidade Inicial</label><input id="p-qtd" type="number" min="0" name="quantidade" required></div>
    <div class="campo"><label for="p-un">Unidade</label><input id="p-un" type="text" name="unidade" placeholder="kg, saco, un, kit…" required></div>
    <div class="campo"><label for="p-val">Validade</label><input id="p-val" type="date" name="validade"></div>
    <div class="campo largo"><label for="p-desc">Descrição Técnica</label><input id="p-desc" type="text" name="descricao" placeholder="Características da variedade ou equipamento"></div>
    <div class="campo largo"><label for="p-foto">Fotografia (URL ou caminho local)</label><input id="p-foto" type="text" name="fotoUrl" placeholder="img/produtos/feijao.jpg ou https://…"></div>
    <div class="botao-linha"><button type="submit">+ Criar Produto</button></div>
</form>
</section>

<section class="painel sem-padding">
<c:choose>
<c:when test="${empty produtos}"><div class="vazio"><div class="ico"><span class="i i-caixa"></span></div><p>Nenhum produto registado.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Tabela de produtos em catálogo">
<table>
<thead>
    <tr>
        <th>ID</th>
        <th>Produto / Insumo</th>
        <th>Categoria</th>
        <th>Fornecedor</th>
        <th>Validade</th>
        <th class="num">Preço</th>
        <th class="num">Stock</th>
        <th class="num">Acções / Repor Stock</th>
    </tr>
</thead>
<tbody>
<c:forEach var="p" items="${produtos}">
<c:set var="fotoP" value="${empty p.fotoUrl ? '' : (p.fotoUrl.startsWith('http') ? p.fotoUrl : ctx.concat('/').concat(p.fotoUrl))}"/>
<tr>
    <td class="id">#${p.id}</td>
    <td>
        <div class="item-prod-info">
            <c:if test="${not empty fotoP}">
                <div class="item-prod-thumb"><img src="<c:out value='${fotoP}'/>" alt="<c:out value='${p.nome}'/>" loading="lazy"></div>
            </c:if>
            <div class="item-prod-texto">
                <strong><c:out value="${p.nome}"/></strong>
                <small><c:out value="${p.descricao}"/></small>
            </div>
        </div>
    </td>
    <td><span class="badge ${p.categoria == 'SEMENTE' ? 'aberta' : p.categoria == 'FERTILIZANTE' ? 'azul' : 'aviso'}">${p.categoria}</span></td>
    <td><c:out value="${p.fornecedorNome}"/></td>
    <td class="muted">${empty p.validade ? '—' : p.validade}</td>
    <td class="num"><strong><fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
    <td class="num">
        <c:choose>
            <c:when test="${p.quantidade == 0}"><span class="badge alerta">Esgotado</span></c:when>
            <c:when test="${p.quantidade < 10}"><span class="badge aviso">${p.quantidade} ${p.unidade}</span></c:when>
            <c:otherwise><span class="badge aberta">${p.quantidade} ${p.unidade}</span></c:otherwise>
        </c:choose>
    </td>
    <td class="acoes-linha">
        <form method="post">
            <input type="hidden" name="acao" value="repor">
            <input type="hidden" name="id" value="${p.id}">
            <input type="number" name="quantidade" placeholder="+Qtd" min="1" required aria-label="Quantidade a repor">
            <button type="submit" class="secundario pequeno">+ Repor</button>
        </form>
        <form method="post" onsubmit="return confirm('Remover este produto do catálogo?')">
            <input type="hidden" name="acao" value="remover">
            <input type="hidden" name="id" value="${p.id}">
            <button type="submit" class="perigo pequeno">Remover</button>
        </form>
    </td>
</tr>
</c:forEach>
</tbody>
</table>
</div>
</c:otherwise>
</c:choose>
</section>
</main></div></body></html>
