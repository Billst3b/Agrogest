<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Entrar — AgroGest</title></head>
<body class="centro">
<section class="hero">
    <div style="margin-bottom:14px">
        <img src="${pageContext.request.contextPath}/img/logo-full.svg" alt="AgroGest — Gestão Agrícola Integrada" class="logo-full-img">
    </div>
    <div>
        <span class="badge aberta" style="margin-bottom:14px">Província de Nampula · Moçambique</span>
        <h2>Gestão agrícola integrada, do campo à factura.</h2>
        <p>Plataforma unificada para fornecedores, sementes certificadas, fertilizantes, maquinaria, controlo de campanhas, cultivos, colheitas e facturação com IVA (16%).</p>
    </div>
    <div style="display:flex; gap:18px; flex-wrap:wrap; align-items:center; justify-content:space-between">
        <small class="muted">ISTCEM · Engenharia Informática · Sistemas Distribuídos</small>
        <span class="badge">Apache Tomcat 10.1 · Jakarta EE</span>
    </div>
</section>
<section class="lado-form">
    <div class="card">
        <h1>Iniciar sessão</h1>
        <p class="sub">Introduza as suas credenciais ou utilize um acesso rápido de demonstração.</p>
        <c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
        <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
            <div class="campo"><label for="email">Email</label>
                <input id="email" type="email" name="email" required autofocus autocomplete="email" placeholder="nome@agro.mz"></div>
            <div class="campo"><label for="password">Palavra-passe</label>
                <input id="password" type="password" name="password" required autocomplete="current-password" placeholder="••••••••"></div>
            <button type="submit" class="grande bloco">Entrar na Plataforma</button>
        </form>

        <div style="margin-top:18px; padding-top:16px; border-top:1px solid rgba(255,255,255,0.1)">
            <div style="font-size:0.76rem; color:var(--texto-3); margin-bottom:8px; text-transform:uppercase; letter-spacing:0.05em; font-weight:700">Acesso Rápido (Demo):</div>
            <div style="display:flex; gap:8px; flex-wrap:wrap">
                <button type="button" class="secundario pequeno" onclick="document.getElementById('email').value='admin@agro.mz';document.getElementById('password').value='admin234';">🔑 Admin</button>
                <button type="button" class="secundario pequeno" onclick="document.getElementById('email').value='joao@teste.mz';document.getElementById('password').value='1234';">👤 João Silva</button>
                <button type="button" class="secundario pequeno" onclick="document.getElementById('email').value='cliente@agro.mz';document.getElementById('password').value='cliente123';">🛒 Cliente Demo</button>
            </div>
        </div>

        <p class="rodape-card">Ainda não tem conta? <a href="${pageContext.request.contextPath}/registo.jsp">Criar conta de cliente</a></p>
    </div>
</section>
</body></html>
