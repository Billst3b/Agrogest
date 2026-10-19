<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Entrar — AgroGest</title></head>
<body class="centro">
<section class="hero">
    <span class="marca"><span class="logo"><span class="i i-folha"></span></span> AgroGest</span>
    <div>
        <h2>Gestão agrícola, do campo à factura.</h2>
        <p>Sementes, fertilizantes e maquinaria — campanhas, cultivos e colheitas num só lugar.</p>
    </div>
    <small>ISTCEM · AgroGest</small>
</section>
<section class="lado-form">
    <div class="card">
        <h1>Iniciar sessão</h1>
        <p class="sub">Bem-vindo de volta. Introduza as suas credenciais.</p>
        <c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="campo"><label for="email">Email</label>
                <input id="email" type="email" name="email" required autofocus autocomplete="email" placeholder="nome@exemplo.com"></div>
            <div class="campo"><label for="password">Palavra-passe</label>
                <input id="password" type="password" name="password" required autocomplete="current-password"></div>
            <button type="submit" class="grande bloco">Entrar</button>
        </form>
        <p class="rodape-card">Ainda não tem conta? <a href="${pageContext.request.contextPath}/registo.jsp">Criar conta de cliente</a></p>
    </div>
</section>
</body></html>
