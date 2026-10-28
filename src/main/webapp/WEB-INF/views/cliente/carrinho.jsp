<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Carrinho de Compras — AgroGest</title></head>
<body>
<c:set var="ativo" value="carrinho"/>
<%@ include file="/WEB-INF/views/_partials/cliente-topbar.jspf" %>
<main class="pagina">
<div class="cabecalho">
    <div>
        <h2>O Meu Carrinho de Compras</h2>
        <p>Reveja as quantidades seleccionadas antes de confirmar a emissão da factura.</p>
    </div>
</div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>
<c:choose>
<c:when test="${empty carrinho}">
    <div class="painel vazio">
        <div class="ico"><span class="i i-carrinho"></span></div>
        <p>O seu carrinho de compras está vazio.</p>
        <a class="botao" href="${ctx}/catalogo">Explorar Catálogo de Insumos</a>
    </div>
</c:when>
<c:otherwise>
<c:set var="soma" value="${0}"/>
<div class="resumo">
    <div class="painel sem-padding">
        <div class="tabela-wrap" tabindex="0" role="region" aria-label="Itens no carrinho de compras">
            <table>
                <thead>
                    <tr>
                        <th>Produto / Insumo</th>
                        <th class="num">Quantidade</th>
                        <th class="num">Preço Unit.</th>
                        <th class="num">Subtotal</th>
                        <th class="num">Acções</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${carrinho}" varStatus="s">
                    <c:set var="soma" value="${soma + item.subtotal}"/>
                    <tr>
                        <td><strong><c:out value="${item.produtoNome}"/></strong></td>
                        <td class="num">
                            <form method="post" action="${ctx}/carrinho" style="display:inline-flex; align-items:center; gap:6px">
                                <input type="hidden" name="acao" value="atualizar">
                                <input type="hidden" name="index" value="${s.index}">
                                <input type="number" name="quantidade" value="${item.quantidade}" min="1" style="width:74px; padding:6px 8px; text-align:center" aria-label="Nova quantidade">
                                <button type="submit" class="secundario pequeno" title="Actualizar quantidade">Actualizar</button>
                            </form>
                        </td>
                        <td class="num"><fmt:formatNumber value="${item.precoUnitario}" minFractionDigits="2" maxFractionDigits="2"/> MZN</td>
                        <td class="num"><strong><fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
                        <td class="acoes-linha">
                            <form method="post" action="${ctx}/carrinho">
                                <input type="hidden" name="acao" value="remover">
                                <input type="hidden" name="index" value="${s.index}">
                                <button type="submit" class="perigo pequeno" title="Remover item">Remover</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <aside class="painel totais">
        <h3>Resumo da Encomenda</h3>
        <div class="linha"><span class="muted">Subtotal</span><span class="num"><fmt:formatNumber value="${soma}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
        <div class="linha"><span class="muted">IVA (16%)</span><span class="num"><fmt:formatNumber value="${soma * 0.16}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
        <div class="linha total"><span>Total a Pagar</span><span class="num"><fmt:formatNumber value="${soma * 1.16}" minFractionDigits="2" maxFractionDigits="2"/> MZN</span></div>
        <form method="post" action="${ctx}/compra">
            <button type="submit" class="grande bloco"><span class="i i-recibo"></span> Confirmar e Emitir Factura</button>
        </form>
        <form method="post" action="${ctx}/carrinho" onsubmit="return confirm('Esvaziar todo o carrinho?')">
            <input type="hidden" name="acao" value="limpar">
            <button type="submit" class="secundario bloco">Esvaziar Carrinho</button>
        </form>
        <a class="botao secundario bloco" style="margin-top:12px" href="${ctx}/catalogo">← Continuar a Comprar</a>
    </aside>
</div>
</c:otherwise>
</c:choose>
</main></body></html>
