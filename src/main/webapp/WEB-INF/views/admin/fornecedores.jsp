<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Fornecedores — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="fornecedores"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho">
    <div>
        <h2>Fornecedores Agrícolas</h2>
        <p>Entidades parceiras que fornecem sementes, fertilizantes e maquinaria.</p>
    </div>
    <div class="filtros" style="margin:0">
        <a class="chip ${empty param.ordenar ? 'ativo' : ''}" href="${ctx}/admin/fornecedores">Ordem de Registo</a>
        <a class="chip ${param.ordenar == 'nome' ? 'ativo' : ''}" href="${ctx}/admin/fornecedores?ordenar=nome">Ordenar: Nome</a>
        <a class="chip ${param.ordenar == 'provincia' ? 'ativo' : ''}" href="${ctx}/admin/fornecedores?ordenar=provincia">Ordenar: Província</a>
    </div>
</div>
<section class="painel">
<h3>Novo Fornecedor</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="f-nome">Nome da Empresa</label><input id="f-nome" type="text" name="nome" placeholder="Ex.: Sementes do Sul, Lda" required></div>
    <div class="campo"><label for="f-tipo">Especialidade / Tipo</label><select id="f-tipo" name="tipo"><option>SEMENTES</option><option>MAQUINARIA</option><option>FERTILIZANTES</option></select></div>
    <div class="campo"><label for="f-contacto">Contacto Telefónico</label><input id="f-contacto" type="text" name="contacto" placeholder="+258 84 000 0000" required></div>
    <div class="campo"><label for="f-prov">Província</label><input id="f-prov" type="text" name="provincia" placeholder="Ex.: Nampula, Maputo…" required></div>
    <div class="botao-linha"><button type="submit">+ Registar Fornecedor</button></div>
</form>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty fornecedores}"><div class="vazio"><div class="ico"><span class="i i-camiao"></span></div><p>Nenhum fornecedor registado.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Lista de fornecedores">
<table><thead><tr><th>ID</th><th>Empresa Fornecedora</th><th>Tipo de Insumo</th><th>Contacto</th><th>Província</th><th class="num">Acções</th></tr></thead><tbody>
<c:forEach var="f" items="${fornecedores}"><tr>
<td class="id">#${f.id}</td><td><strong><c:out value="${f.nome}"/></strong></td>
<td><span class="badge ${f.tipo == 'SEMENTES' ? 'aberta' : f.tipo == 'FERTILIZANTES' ? 'azul' : 'aviso'}">${f.tipo}</span></td>
<td><c:out value="${f.contacto}"/></td><td>📍 <c:out value="${f.provincia}"/></td>
<td class="acoes-linha"><form method="post" onsubmit="return confirm('Remover este fornecedor?')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${f.id}"><button type="submit" class="perigo pequeno">Remover</button></form></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
