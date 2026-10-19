<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Clientes — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="clientes"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Clientes</h2><p>Registo e gestão de clientes.</p></div></div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
<section class="painel">
<h3>Novo cliente</h3>
<form method="post" class="form-grid">
    <input type="hidden" name="acao" value="criar">
    <div class="campo"><label for="c-nome">Nome completo</label><input id="c-nome" type="text" name="nome" required></div>
    <div class="campo"><label for="c-email">Email</label><input id="c-email" type="email" name="email" required placeholder="nome@exemplo.com"></div>
    <div class="campo"><label for="c-pass">Palavra-passe</label><input id="c-pass" type="password" name="password" required minlength="4" autocomplete="new-password"></div>
    <div class="campo"><label for="c-tel">Telefone</label><input id="c-tel" type="tel" name="telefone" required placeholder="+258 84 000 0000"></div>
    <div class="campo largo"><label for="c-end">Endereço</label><input id="c-end" type="text" name="endereco" required></div>
    <div class="botao-linha"><button>+ Registar cliente</button></div>
</form>
</section>
<section class="painel sem-padding">
<c:choose>
<c:when test="${empty clientes}"><div class="vazio"><div class="ico"><span class="i i-pessoas"></span></div><p>Nenhum cliente registado.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>ID</th><th>Nome</th><th>Email</th><th>Telefone</th><th>Endereço</th><th class="num">Compras</th><th></th></tr></thead><tbody>
<c:forEach var="cl" items="${clientes}"><tr>
<td class="id">${cl.id}</td><td><strong><c:out value="${cl.nome}"/></strong></td><td><c:out value="${cl.email}"/></td>
<td><c:out value="${cl.telefone}"/></td><td><c:out value="${cl.endereco}"/></td>
<td class="num">${empty compras[cl.id] ? 0 : compras[cl.id]}</td>
<td class="acoes-linha">
    <a class="botao secundario pequeno" href="${ctx}/admin/vendas?cliente=${cl.id}#nova-venda">Nova venda</a>
    <c:if test="${empty compras[cl.id]}"><form method="post" onsubmit="return confirm('Remover este cliente?')"><input type="hidden" name="acao" value="remover"><input type="hidden" name="id" value="${cl.id}"><button class="perigo pequeno">Remover</button></form></c:if>
</td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
</main></div></body></html>
