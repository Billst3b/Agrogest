<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Acesso negado (403) — AgroGest</title></head>
<body class="so-card">
<div class="card isolado">
    <div class="vazio" style="padding:10px 0"><div class="ico"><span class="i i-bloqueio"></span></div></div>
    <h1>Acesso Restrito (403)</h1>
    <p class="sub">Não tem permissão de Administrador para aceder a esta rota protegida.</p>
    <a class="botao bloco" href="${pageContext.request.contextPath}/login.jsp">Voltar ao Início</a>
</div>
</body></html>
