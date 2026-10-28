<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Criar conta — AgroGest</title></head>
<body class="centro">
<section class="hero">
    <span class="marca"><span class="logo"><span class="i i-folha"></span></span> AgroGest</span>
    <div>
        <span class="badge aberta" style="margin-bottom:14px">Auto-Registo de Clientes</span>
        <h2>Adquira insumos agrícolas com emissão imediata de factura.</h2>
        <p>Crie a sua conta de cliente para aceder ao catálogo completo de sementes, fertilizantes, maquinaria e ferramentas com stock garantido em Nampula.</p>
    </div>
    <small class="muted">ISTCEM · AgroGest — Sistema de Gestão Agrícola</small>
</section>
<section class="lado-form">
    <div class="card">
        <h1>Criar conta</h1>
        <p class="sub">Preencha os seus dados para começar a comprar.</p>
        <c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
        <form method="post" action="${pageContext.request.contextPath}/registo">
            <div class="campo"><label for="nome">Nome completo</label>
                <input id="nome" type="text" name="nome" required autocomplete="name" placeholder="Ex.: João Silva"></div>
            <div class="campo"><label for="email">Email</label>
                <input id="email" type="email" name="email" required autocomplete="email" placeholder="joao@teste.mz"></div>
            <div class="campo"><label for="password">Palavra-passe</label>
                <input id="password" type="password" name="password" required minlength="4" autocomplete="new-password" placeholder="Mínimo 4 caracteres"></div>
            <div class="campo"><label for="telefone">Telefone</label>
                <input id="telefone" type="tel" name="telefone" required autocomplete="tel" placeholder="+258 84 000 0000"></div>
            <div class="campo"><label for="endereco">Endereço / Província</label>
                <input id="endereco" type="text" name="endereco" required autocomplete="street-address" placeholder="Av. Eduardo Mondlane, Nampula"></div>
            <button type="submit" class="grande bloco">Registar Conta</button>
        </form>
        <p class="rodape-card">Já tem conta? <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sessão</a></p>
    </div>
</section>
</body></html>
