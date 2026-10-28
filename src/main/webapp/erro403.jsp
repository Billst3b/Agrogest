<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% response.setStatus(HttpServletResponse.SC_FORBIDDEN); %>
<!DOCTYPE html>
<html lang="pt">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>403 — Acesso Negado</title>
<link rel="icon" type="image/svg+xml" href="${pageContext.request.contextPath}/img/favicon.svg">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"></head>
<body class="so-card">
<div class="card isolado">
    <div class="vazio"><span class="ico"><span class="i i-bloqueio"></span></span></div>
    <h1>403 — Acesso Negado</h1>
    <p class="sub">Esta área é exclusiva para o perfil <strong>Administrador</strong>.</p>
    <c:choose>
        <c:when test="${not empty sessionScope.utilizador}">
            <a class="botao bloco" href="${pageContext.request.contextPath}/catalogo">Voltar ao Catálogo</a>
        </c:when>
        <c:otherwise>
            <a class="botao bloco" href="${pageContext.request.contextPath}/login.jsp">Voltar ao Início</a>
        </c:otherwise>
    </c:choose>
</div>
</body></html>
