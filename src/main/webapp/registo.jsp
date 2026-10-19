<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Criar conta — AgroGest</title></head>
<body class="centro">
<section class="hero">
    <span class="marca"><span class="logo"><span class="i i-folha"></span></span> AgroGest</span>
    <div>
        <h2>Compre insumos agrícolas com facilidade.</h2>
        <p>Crie a sua conta de cliente para consultar o catálogo, encomendar e receber a factura no momento.</p>
    </div>
    <small>ISTCEM · AgroGest</small>
</section>
<section class="lado-form">
    <div class="card">
        <h1>Criar conta</h1>
        <p class="sub">Preencha os seus dados para começar.</p>
        <c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
        <form method="post" action="${pageContext.request.contextPath}/registo">
            <div class="campo"><label for="nome">Nome completo</label>
                <input id="nome" type="text" name="nome" required autocomplete="name"></div>
            <div class="campo"><label for="email">Email</label>
                <input id="email" type="email" name="email" required autocomplete="email" placeholder="nome@exemplo.com"></div>
            <div class="campo"><label for="password">Palavra-passe</label>
                <input id="password" type="password" name="password" required minlength="4" autocomplete="new-password" placeholder="Mínimo 4 caracteres"></div>
            <div class="campo"><label for="telefone">Telefone</label>
                <input id="telefone" type="tel" name="telefone" required autocomplete="tel" placeholder="+258 84 000 0000"></div>
            <div class="campo"><label for="endereco">Endereço</label>
                <input id="endereco" type="text" name="endereco" required autocomplete="street-address"></div>
            <button type="submit" class="grande bloco">Registar</button>
        </form>
        <p class="rodape-card">Já tem conta? <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sessão</a></p>
    </div>
</section>
</body></html>
