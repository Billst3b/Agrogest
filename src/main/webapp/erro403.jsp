<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Acesso negado — AgroGest</title></head>
<body class="so-card">
<div class="card isolado">
    <div class="ico-grande"><span class="i i-bloqueio"></span></div>
    <h1>Acesso negado</h1>
    <p class="sub">Não tem permissão para aceder a esta página.</p>
    <a class="botao bloco" href="${pageContext.request.contextPath}/login.jsp">Voltar ao login</a>
</div>
</body></html>
