<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Vendas e Facturação — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="vendas"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<div class="cabecalho">
    <div>
        <h2>Vendas e Compras Detalhadas</h2>
        <p>Emissão transaccional de facturas com desconto atómico de stock e cálculo de IVA (16%).</p>
    </div>
    <div class="cabecalho-direita">
        <div class="filtros" style="margin:0">
            <a class="chip ${empty param.ordenar || param.ordenar == 'data' ? 'ativo' : ''}" href="${ctx}/admin/vendas?ordenar=data">Ordenar: Mais Recentes</a>
            <a class="chip ${param.ordenar == 'valor' ? 'ativo' : ''}" href="${ctx}/admin/vendas?ordenar=valor">Ordenar: Maior Valor</a>
            <a class="chip ${param.ordenar == 'nome' ? 'ativo' : ''}" href="${ctx}/admin/vendas?ordenar=nome">Ordenar: Cliente (A–Z)</a>
        </div>
        <button type="button" class="botao" id="btn-abrir-nova-venda" commandfor="modal-nova-venda" command="show-modal">
            + Nova Venda Balcão
        </button>
    </div>
</div>
<c:if test="${not empty erro}"><p class="alerta erro"><c:out value="${erro}"/></p></c:if>

<!-- Modal Popup para Registar Nova Venda Balcão -->
<dialog id="modal-nova-venda" class="modal-glass modal-venda-box" closedby="any" aria-labelledby="titulo-nova-venda">
    <div class="modal-cab">
        <div>
            <span class="etiqueta-modal">Ponto de Venda · IVA 16% Incluído na Factura</span>
            <h3 id="titulo-nova-venda">Registar Nova Venda Balcão</h3>
        </div>
        <button type="button" class="btn-fechar-modal" commandfor="modal-nova-venda" command="close" onclick="this.closest('dialog').close()" aria-label="Fechar janela"></button>
    </div>
    <c:choose>
    <c:when test="${empty clientes}"><p class="muted" style="margin:0">Registe primeiro um cliente em <a href="${ctx}/admin/clientes">Clientes</a>.</p></c:when>
    <c:when test="${empty produtos}"><p class="muted" style="margin:0">Não há produtos em stock. Adicione produtos em <a href="${ctx}/admin/produtos">Produtos</a>.</p></c:when>
    <c:otherwise>
    <form method="post" id="form-venda">
        <div class="form-grid">
            <div class="campo largo"><label for="v-cliente">Seleccionar Cliente</label>
                <select id="v-cliente" name="clienteId" required autofocus>
                    <option value="">Seleccione o cliente…</option>
                    <c:forEach var="cl" items="${clientes}"><option value="${cl.id}" ${param.cliente == cl.id ? 'selected' : ''}><c:out value="${cl.nome}"/> (<c:out value="${cl.email}"/> · <c:out value="${cl.endereco}"/>)</option></c:forEach>
                </select></div>
        </div>
        <div class="linhas-venda" id="linhas-venda">
            <div class="linha-venda">
                <div class="campo"><label>Produto em Stock</label>
                    <select name="produtoId" required>
                        <option value="">Seleccione o produto…</option>
                        <c:forEach var="p" items="${produtos}"><option value="${p.id}" data-preco="${p.preco}" data-stock="${p.quantidade}"><c:out value="${p.nome}"/> · <fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN · stock ${p.quantidade} <c:out value="${p.unidade}"/></option></c:forEach>
                    </select></div>
                <div class="campo"><label>Quantidade</label><input type="number" name="quantidade" min="1" value="1" required></div>
                <div class="campo"><label>Subtotal</label><output class="subtotal num">0,00 MZN</output></div>
                <button type="button" class="perigo pequeno remover-linha" aria-label="Remover linha"><span class="i i-lixo"></span></button>
            </div>
        </div>
        <div class="acoes" style="justify-content: space-between">
            <button type="button" class="secundario" id="add-linha">+ Adicionar Outro Produto</button>
            <div class="total-venda">Subtotal (sem IVA 16%): <strong id="total-venda" style="color:var(--lima)">0,00 MZN</strong></div>
        </div>
        <div class="modal-rodape">
            <button type="button" class="secundario" commandfor="modal-nova-venda" command="close" onclick="this.closest('dialog').close()">Cancelar</button>
            <button type="submit" class="grande"><span class="i i-recibo"></span> Confirmar Venda e Emitir Factura</button>
        </div>
    </form>
    </c:otherwise>
    </c:choose>
</dialog>

<section class="painel sem-padding">
<div class="painel-titulo"><h3>Histórico de Compras Detalhadas e Facturas Emitidas</h3></div>
<c:choose>
<c:when test="${empty vendas}"><div class="vazio"><div class="ico"><span class="i i-recibo"></span></div><p>Ainda não há vendas registadas.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Facturas e compras detalhadas">
<table class="tabela-vendas">
<thead>
    <tr>
        <th>Factura &amp; Data</th>
        <th>Cliente &amp; Contacto</th>
        <th>Artigos Adquiridos</th>
        <th class="num">Total Facturado</th>
        <th class="num">Acção</th>
    </tr>
</thead>
<tbody>
<c:forEach var="v" items="${vendas}"><tr>
<td class="cel-factura">
    <span class="badge aberta">${v.numeroFactura}</span>
    <span class="data-sub">${v.data.toString().substring(0, 16).replace('T', ' · ')}</span>
</td>
<td class="cel-cliente">
    <strong><c:out value="${v.clienteNome}"/></strong>
    <small class="muted"><c:out value="${v.clienteTelefone}"/> · <c:out value="${v.clienteEndereco}"/></small>
</td>
<td class="cel-artigos">
    <div class="vendas-itens-lista">
        <c:forEach var="it" items="${v.itens}">
            <div class="venda-item-pill">
                <span class="qtd-pill">${it.quantidade}×</span>
                <span class="nome-pill"><c:out value="${it.produtoNome}"/></span>
                <span class="preco-un-pill"><fmt:formatNumber value="${it.precoUnitario}" minFractionDigits="2" maxFractionDigits="2"/> MZN/un</span>
            </div>
        </c:forEach>
    </div>
</td>
<td class="num cel-totais">
    <strong class="valor-total-cel"><fmt:formatNumber value="${v.total}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong>
    <span class="sub-iva-cel">Sub: <fmt:formatNumber value="${v.subtotal}" minFractionDigits="2" maxFractionDigits="2"/> · IVA: <fmt:formatNumber value="${v.iva}" minFractionDigits="2" maxFractionDigits="2"/></span>
</td>
<td class="acoes-linha"><a class="botao secundario pequeno" href="${ctx}/factura?id=${v.id}">Ver Factura</a></td>
</tr></c:forEach></tbody></table></div></c:otherwise>
</c:choose>
</section>
<script>
(function () {
    var modalVenda = document.getElementById('modal-nova-venda');
    var btnAbrirVenda = document.getElementById('btn-abrir-nova-venda');
    if (btnAbrirVenda && modalVenda) {
        btnAbrirVenda.addEventListener('click', function () {
            if (!modalVenda.open) modalVenda.showModal();
        });
    }
    if (modalVenda && (window.location.hash === '#nova-venda' || '${not empty param.cliente}' === 'true' || '${not empty erro}' === 'true')) {
        if (!modalVenda.open) modalVenda.showModal();
    }
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
