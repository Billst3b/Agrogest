<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Vendas — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="vendas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho"><div><h2>Vendas</h2><p>Registo de vendas e facturas emitidas.</p></div></div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>

<section class="painel" id="nova-venda">
<h3>Nova venda</h3>
<c:choose>
<c:when test="${empty clientes}"><p class="muted" style="margin:0">Registe primeiro um cliente em <a href="${ctx}/admin/clientes">Clientes</a>.</p></c:when>
<c:when test="${empty produtos}"><p class="muted" style="margin:0">Não há produtos em stock. Adicione produtos em <a href="${ctx}/admin/produtos">Produtos</a>.</p></c:when>
<c:otherwise>
<form method="post" id="form-venda">
    <div class="form-grid">
        <div class="campo largo"><label for="v-cliente">Cliente</label>
            <select id="v-cliente" name="clienteId" required>
                <option value="">Seleccione…</option>
                <c:forEach var="cl" items="${clientes}"><option value="${cl.id}" ${param.cliente == cl.id ? 'selected' : ''}><c:out value="${cl.nome}"/> (<c:out value="${cl.email}"/>)</option></c:forEach>
            </select></div>
    </div>
    <div class="linhas-venda" id="linhas-venda">
        <div class="linha-venda">
            <div class="campo"><label>Produto</label>
                <select name="produtoId" required>
                    <option value="">Seleccione…</option>
                    <c:forEach var="p" items="${produtos}"><option value="${p.id}" data-preco="${p.preco}" data-stock="${p.quantidade}"><c:out value="${p.nome}"/> · <fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN · stock ${p.quantidade} <c:out value="${p.unidade}"/></option></c:forEach>
                </select></div>
            <div class="campo"><label>Quantidade</label><input type="number" name="quantidade" min="1" value="1" required></div>
            <div class="campo"><label>Subtotal</label><output class="subtotal num">0,00 MZN</output></div>
            <button type="button" class="perigo pequeno remover-linha" aria-label="Remover linha"><span class="i i-lixo"></span></button>
        </div>
    </div>
    <div class="acoes" style="justify-content: space-between">
        <button type="button" class="secundario" id="add-linha">+ Adicionar produto</button>
        <div class="total-venda">Total (sem IVA): <strong id="total-venda">0,00 MZN</strong></div>
    </div>
    <div class="acoes"><button type="submit" class="grande"><span class="i i-recibo"></span> Registar venda e emitir factura</button></div>
</form>
</c:otherwise>
</c:choose>
</section>

<section class="painel sem-padding">
<div class="painel-titulo"><h3>Facturas emitidas</h3></div>
<c:choose>
<c:when test="${empty vendas}"><div class="vazio"><div class="ico"><span class="i i-recibo"></span></div><p>Ainda não há vendas.</p></div></c:when>
<c:otherwise><div class="tabela-wrap">
<table><thead><tr><th>Factura</th><th>Cliente</th><th>Data</th><th class="num">Total</th><th></th></tr></thead><tbody>
<c:forEach var="v" items="${vendas}"><tr>
<td><strong>${v.numeroFactura}</strong></td><td><c:out value="${v.clienteNome}"/></td>
<td class="muted">${v.data.toString().substring(0, 16).replace('T', ' ')}</td>
<td class="num"><fmt:formatNumber value="${v.total}" type="currency" currencySymbol="MZN"/></td>
<td class="acoes-linha"><a class="botao secundario pequeno" href="${ctx}/factura?id=${v.id}">Ver factura</a></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
<script>
(function () {
    var form = document.getElementById('form-venda');
    if (!form) return;
    var linhas = document.getElementById('linhas-venda');
    var modelo = linhas.querySelector('.linha-venda').cloneNode(true);
    var fmt = new Intl.NumberFormat('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2, useGrouping: 'always' });
    function recalcular() {
        var total = 0;
        linhas.querySelectorAll('.linha-venda').forEach(function (l) {
            var opt = l.querySelector('select').selectedOptions[0];
            var qtd = l.querySelector('input');
            var preco = opt && opt.dataset.preco ? parseFloat(opt.dataset.preco) : 0;
            if (opt && opt.dataset.stock) qtd.max = opt.dataset.stock; else qtd.removeAttribute('max');
            var sub = preco * (parseInt(qtd.value, 10) || 0);
            total += sub;
            l.querySelector('.subtotal').textContent = fmt.format(sub) + ' MZN';
        });
        document.getElementById('total-venda').textContent = fmt.format(total) + ' MZN';
        var unica = linhas.children.length === 1;
        linhas.querySelectorAll('.remover-linha').forEach(function (b) { b.disabled = unica; });
    }
    document.getElementById('add-linha').addEventListener('click', function () {
        linhas.appendChild(modelo.cloneNode(true)); recalcular();
    });
    linhas.addEventListener('click', function (e) {
        var b = e.target.closest('.remover-linha');
        if (b && linhas.children.length > 1) { b.closest('.linha-venda').remove(); recalcular(); }
    });
    linhas.addEventListener('input', recalcular);
    linhas.addEventListener('change', recalcular);
    recalcular();
})();
</script>
</main></div></body></html>
