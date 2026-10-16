<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Acesso negado — AgroGest</title></head>
<body class="so-card">
<div class="card isolado">
    <div class="ico-grande">&#x1F6AB;</div>
    <h1>Acesso negado</h1>
    <p class="sub">Não tem permissão para aceder a esta página.</p>
    <a class="botao bloco" href="${pageContext.request.contextPath}/login.jsp">Voltar ao login</a>
</div>
</body></html>
