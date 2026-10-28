<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="pt">
<head><%@ include file="/WEB-INF/views/_partials/head.jspf" %><title>Produtos e Stock — AgroGest</title></head>
<body><div class="app">
<c:set var="ativo" value="produtos"/>
<%@ include file="/WEB-INF/views/_partials/admin-sidebar.jspf" %>
<main class="conteudo">
<c:if test="${not empty flashErro}"><p class="alerta erro"><c:out value="${flashErro}"/></p></c:if>
<div class="cabecalho">
    <div>
        <h2>Catálogo de Produtos e Armazém</h2>
        <p>Gestão de insumos agrícolas, preços, validades e reposição de stock.</p>
    </div>
    <div class="cabecalho-direita">
        <div class="filtros" style="margin:0">
            <a class="chip ${empty param.filtro ? 'ativo' : ''}" href="${ctx}/admin/produtos">Todos</a>
            <a class="chip ${param.filtro == 'armazem' ? 'ativo' : ''}" href="${ctx}/admin/produtos?filtro=armazem">Em Armazém (Stock &gt; 0)</a>
            <a class="chip ${param.ordenar == 'nome' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=nome&amp;filtro=<c:out value='${param.filtro}'/>">Ordenar: Nome</a>
            <a class="chip ${param.ordenar == 'preco' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=preco&amp;filtro=<c:out value='${param.filtro}'/>">Ordenar: Preço</a>
            <a class="chip ${param.ordenar == 'stock' ? 'ativo' : ''}" href="${ctx}/admin/produtos?ordenar=stock&amp;filtro=<c:out value='${param.filtro}'/>">Ordenar: Stock</a>
        </div>
        <button type="button" class="botao" id="btn-abrir-novo-produto" commandfor="modal-novo-produto" command="show-modal">
            + Registar Novo Produto
        </button>
    </div>
</div>

<!-- Modal Popup Natural para Registar Novo Produto -->
<dialog id="modal-novo-produto" class="modal-glass modal-produto-studio" closedby="any" aria-labelledby="titulo-novo-produto">
    <div class="modal-cab">
        <div>
            <span class="etiqueta-modal">Catálogo AgroGest · Nampula</span>
            <h3 id="titulo-novo-produto">Novo Insumo ou Equipamento</h3>
        </div>
        <button type="button" class="btn-fechar-modal" commandfor="modal-novo-produto" command="close" onclick="this.closest('dialog').close()" aria-label="Fechar janela"></button>
    </div>

    <form method="post" id="form-novo-produto" class="studio-grid">
        <input type="hidden" name="acao" value="criar">
        <input type="hidden" name="categoria" id="p-cat-val" value="SEMENTE">

        <!-- Coluna Esquerda: Pré-visualização ao Vivo + Galeria Instantânea -->
        <div class="studio-preview-col">
            <div class="produto preview-live-card">
                <div class="foto">
                    <img id="prev-img" src="${ctx}/img/produtos/feijao.jpg" alt="Pré-visualização do produto">
                </div>
                <div class="corpo">
                    <div style="display:flex; justify-content:space-between; align-items:center; gap:8px">
                        <span id="prev-cat" class="badge aberta">SEMENTE</span>
                        <span id="prev-stock" class="badge aberta">100 kg</span>
                    </div>
                    <h3 id="prev-nome">Semente Feijão Nhemba</h3>
                    <p class="desc" id="prev-desc">Variedade certificada adaptada ao clima de Nampula.</p>
                    <div class="linha">
                        <span class="preco" id="prev-preco">320,00 MZN</span>
                        <small class="muted" id="prev-val">Val.: —</small>
                    </div>
                </div>
            </div>

            <div class="galeria-rapida">
                <span class="galeria-titulo">Escolha uma fotografia rápida ou cole um link:</span>
                <div class="galeria-thumbs">
                    <button type="button" class="thumb-item ativo" data-foto="img/produtos/feijao.jpg" title="Feijão Nhemba"><img src="${ctx}/img/produtos/feijao.jpg" alt="Feijão"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/milho.jpg" title="Milho Matuba"><img src="${ctx}/img/produtos/milho.jpg" alt="Milho"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/soja.jpg" title="Soja TGx"><img src="${ctx}/img/produtos/soja.jpg" alt="Soja"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/gergelim.jpg" title="Gergelim Lindi"><img src="${ctx}/img/produtos/gergelim.jpg" alt="Gergelim"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/npk.jpg" title="Adubo NPK"><img src="${ctx}/img/produtos/npk.jpg" alt="NPK"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/ureia.jpg" title="Ureia Agrícola"><img src="${ctx}/img/produtos/ureia.jpg" alt="Ureia"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/rega.jpg" title="Kit de Rega"><img src="${ctx}/img/produtos/rega.jpg" alt="Rega"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/pulverizador.jpg" title="Pulverizador"><img src="${ctx}/img/produtos/pulverizador.jpg" alt="Pulverizador"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/tractor.jpg" title="Motocultivador"><img src="${ctx}/img/produtos/tractor.jpg" alt="Tractor"></button>
                    <button type="button" class="thumb-item" data-foto="img/produtos/enxada.jpg" title="Enxada Forjada"><img src="${ctx}/img/produtos/enxada.jpg" alt="Enxada"></button>
                </div>
                <input id="p-foto" type="text" name="fotoUrl" value="img/produtos/feijao.jpg" placeholder="Ou introduza URL / caminho da foto…" aria-label="Caminho ou URL da fotografia">
            </div>
        </div>

        <!-- Coluna Direita: Passos Naturais -->
        <div class="studio-campos-col">
            <div class="passo-bloco">
                <span class="passo-etiqueta">1. Que tipo de produto pretende adicionar?</span>
                <div class="cat-pills" role="radiogroup" aria-label="Categoria do produto">
                    <button type="button" class="cat-pill ativo" data-cat="SEMENTE" data-badge="aberta"><span class="i i-folha"></span> Semente</button>
                    <button type="button" class="cat-pill" data-cat="FERTILIZANTE" data-badge="azul"><span class="i i-caixa"></span> Fertilizante</button>
                    <button type="button" class="cat-pill" data-cat="MAQUINARIA" data-badge="aviso"><span class="i i-camiao"></span> Maquinaria</button>
                    <button type="button" class="cat-pill" data-cat="FERRAMENTA" data-badge="aviso"><span class="i i-check"></span> Ferramenta</button>
                </div>
            </div>

            <div class="passo-bloco">
                <span class="passo-etiqueta">2. Identificação e características</span>
                <div class="campo">
                    <label for="p-nome">Designação Comercial</label>
                    <input id="p-nome" type="text" name="nome" placeholder="Ex.: Semente Feijão Nhemba (Macia)" required autofocus>
                </div>
                <div class="campo" style="margin-top:10px">
                    <label for="p-desc">Breve Descrição Técnica</label>
                    <input id="p-desc" type="text" name="descricao" placeholder="Ex.: Ciclo curto adaptado ao clima de Nampula, elevada resistência">
                </div>
            </div>

            <div class="passo-bloco">
                <span class="passo-etiqueta">3. Preço, stock inicial e unidade</span>
                <div class="studio-linha-3">
                    <div class="campo">
                        <label for="p-preco">Preço Unitário (MZN)</label>
                        <input id="p-preco" type="number" step="0.01" min="0" name="preco" placeholder="320.00" required>
                    </div>
                    <div class="campo">
                        <label for="p-qtd">Stock Inicial</label>
                        <input id="p-qtd" type="number" min="0" name="quantidade" placeholder="100" required>
                    </div>
                    <div class="campo">
                        <label for="p-un">Unidade</label>
                        <input id="p-un" type="text" name="unidade" value="kg" placeholder="kg, saco, un…" required>
                    </div>
                </div>
                <div class="un-chips">
                    <span>Unidade rápida:</span>
                    <button type="button" class="un-chip ativo" data-un="kg">kg</button>
                    <button type="button" class="un-chip" data-un="saco">saco</button>
                    <button type="button" class="un-chip" data-un="un">un</button>
                    <button type="button" class="un-chip" data-un="kit">kit</button>
                    <button type="button" class="un-chip" data-un="L">litro</button>
                </div>
            </div>

            <div class="passo-bloco">
                <span class="passo-etiqueta">4. Fornecedor e validade do lote</span>
                <div class="studio-linha-2">
                    <div class="campo">
                        <label for="p-forn">Fornecedor Parceiro</label>
                        <select id="p-forn" name="fornecedorId" required>
                            <c:forEach var="f" items="${fornecedores}"><option value="${f.id}"><c:out value="${f.nome}"/></option></c:forEach>
                        </select>
                    </div>
                    <div class="campo">
                        <label for="p-val">Validade (opcional)</label>
                        <input id="p-val" type="date" name="validade">
                    </div>
                </div>
            </div>

            <div class="modal-rodape">
                <button type="button" class="secundario" commandfor="modal-novo-produto" command="close" onclick="this.closest('dialog').close()">Cancelar</button>
                <button type="submit" class="grande">+ Adicionar ao Catálogo</button>
            </div>
        </div>
    </form>
</dialog>

<section class="painel sem-padding">
<c:choose>
<c:when test="${empty produtos}"><div class="vazio"><div class="ico"><span class="i i-caixa"></span></div><p>Nenhum produto registado.</p></div></c:when>
<c:otherwise>
<div class="tabela-wrap" tabindex="0" role="region" aria-label="Tabela de produtos em catálogo">
<table>
<thead>
    <tr>
        <th>ID</th>
        <th>Produto / Insumo</th>
        <th>Categoria</th>
        <th>Fornecedor</th>
        <th>Validade</th>
        <th class="num">Preço</th>
        <th class="num">Stock</th>
        <th class="num">Acções / Repor Stock</th>
    </tr>
</thead>
<tbody>
<c:forEach var="p" items="${produtos}">
<c:set var="fotoP" value="${empty p.fotoUrl ? '' : (p.fotoUrl.startsWith('http') ? p.fotoUrl : ctx.concat('/').concat(p.fotoUrl))}"/>
<tr>
    <td class="id">#${p.id}</td>
    <td>
        <div class="item-prod-info">
            <c:if test="${not empty fotoP}">
                <div class="item-prod-thumb"><img src="<c:out value='${fotoP}'/>" alt="<c:out value='${p.nome}'/>" loading="lazy"></div>
            </c:if>
            <div class="item-prod-texto">
                <strong><c:out value="${p.nome}"/></strong>
                <small><c:out value="${p.descricao}"/></small>
            </div>
        </div>
    </td>
    <td><span class="badge ${p.categoria == 'SEMENTE' ? 'aberta' : p.categoria == 'FERTILIZANTE' ? 'azul' : 'aviso'}">${p.categoria}</span></td>
    <td><c:out value="${p.fornecedorNome}"/></td>
    <td class="muted" style="white-space:nowrap">${empty p.validade ? '—' : p.validade}</td>
    <td class="num"><strong><fmt:formatNumber value="${p.preco}" minFractionDigits="2" maxFractionDigits="2"/> MZN</strong></td>
    <td class="num">
        <c:choose>
            <c:when test="${p.quantidade == 0}"><span class="badge alerta">Esgotado</span></c:when>
            <c:when test="${p.quantidade < 10}"><span class="badge aviso">${p.quantidade} ${p.unidade}</span></c:when>
            <c:otherwise><span class="badge aberta">${p.quantidade} ${p.unidade}</span></c:otherwise>
        </c:choose>
    </td>
    <td class="acoes-linha">
        <form method="post">
            <input type="hidden" name="acao" value="repor">
            <input type="hidden" name="id" value="${p.id}">
            <input type="number" name="quantidade" placeholder="+Qtd" min="1" required aria-label="Quantidade a repor">
            <button type="submit" class="secundario pequeno">+ Repor</button>
        </form>
        <form method="post" onsubmit="return confirm('Remover este produto do catálogo?')">
            <input type="hidden" name="acao" value="remover">
            <input type="hidden" name="id" value="${p.id}">
            <button type="submit" class="perigo pequeno">Remover</button>
        </form>
    </td>
</tr>
</c:forEach>
</tbody>
</table>
</div>
</c:otherwise>
</c:choose>
</section>
<script>
(function () {
    var modal = document.getElementById('modal-novo-produto');
    var btnAbrir = document.getElementById('btn-abrir-novo-produto');
    if (btnAbrir && modal) {
        btnAbrir.addEventListener('click', function () {
            if (!modal.open) modal.showModal();
        });
    }
    if (!modal) return;
    var ctx = '${ctx}';
    var fmt = new Intl.NumberFormat('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2, useGrouping: 'always' });

    var inpNome = document.getElementById('p-nome');
    var inpDesc = document.getElementById('p-desc');
    var inpPreco = document.getElementById('p-preco');
    var inpQtd = document.getElementById('p-qtd');
    var inpUn = document.getElementById('p-un');
    var inpVal = document.getElementById('p-val');
    var inpFoto = document.getElementById('p-foto');
    var inpCat = document.getElementById('p-cat-val');

    var prevImg = document.getElementById('prev-img');
    var prevCat = document.getElementById('prev-cat');
    var prevStock = document.getElementById('prev-stock');
    var prevNome = document.getElementById('prev-nome');
    var prevDesc = document.getElementById('prev-desc');
    var prevPreco = document.getElementById('prev-preco');
    var prevVal = document.getElementById('prev-val');

    function atualizarPreview() {
        prevNome.textContent = inpNome.value.trim() || 'Semente Feijão Nhemba';
        prevDesc.textContent = inpDesc.value.trim() || 'Variedade certificada adaptada ao clima de Nampula.';
        var pr = parseFloat(inpPreco.value);
        prevPreco.textContent = (isNaN(pr) ? '320,00' : fmt.format(pr)) + ' MZN';
        var qt = inpQtd.value.trim() || '100';
        var un = inpUn.value.trim() || 'kg';
        prevStock.textContent = qt + ' ' + un;
        prevVal.textContent = inpVal.value ? ('Val.: ' + inpVal.value) : 'Val.: —';
        var f = inpFoto.value.trim();
        if (f) {
            prevImg.src = f.indexOf('http') === 0 ? f : (ctx + '/' + f.replace(/^\/+/, ''));
        }
    }

    [inpNome, inpDesc, inpPreco, inpQtd, inpUn, inpVal, inpFoto].forEach(function (el) {
        if (el) el.addEventListener('input', atualizarPreview);
    });

    modal.querySelectorAll('.cat-pill').forEach(function (btn) {
        btn.addEventListener('click', function () {
            modal.querySelectorAll('.cat-pill').forEach(function (b) { b.classList.remove('ativo'); });
            btn.classList.add('ativo');
            var cat = btn.getAttribute('data-cat');
            var badge = btn.getAttribute('data-badge');
            inpCat.value = cat;
            prevCat.textContent = cat;
            prevCat.className = 'badge ' + badge;
        });
    });

    modal.querySelectorAll('.un-chip').forEach(function (btn) {
        btn.addEventListener('click', function () {
            modal.querySelectorAll('.un-chip').forEach(function (b) { b.classList.remove('ativo'); });
            btn.classList.add('ativo');
            inpUn.value = btn.getAttribute('data-un');
            atualizarPreview();
        });
    });

    modal.querySelectorAll('.thumb-item').forEach(function (btn) {
        btn.addEventListener('click', function () {
            modal.querySelectorAll('.thumb-item').forEach(function (b) { b.classList.remove('ativo'); });
            btn.classList.add('ativo');
            inpFoto.value = btn.getAttribute('data-foto');
            atualizarPreview();
        });
    });
})();
</script>
</main></div></body></html>
