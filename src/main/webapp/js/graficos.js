/* AgroGest — gráficos simples em SVG/HTML, sem dependências.
 * Uso: <div data-grafico="colunas|barras" data-fonte="idDoScriptJSON" data-formato="moeda|kg|inteiro"></div>
 * O JSON é uma lista [{r: "rótulo", v: número}]. */
(function () {
    var SVG = 'http://www.w3.org/2000/svg';
    var nf = new Intl.NumberFormat('pt-PT', { maximumFractionDigits: 0, useGrouping: 'always' });
    var nf2 = new Intl.NumberFormat('pt-PT', { minimumFractionDigits: 2, maximumFractionDigits: 2, useGrouping: 'always' });

    function formatar(v, formato, curto) {
        if (curto && Math.abs(v) < 1000) return nf.format(v);
        if (curto) {
            var s = Math.abs(v) >= 1e6 ? nf2.format(v / 1e6).replace(/,00$/, '') + ' M' : nf.format(v / 1000) + ' mil';
            return formato === 'kg' ? s + ' kg' : s;
        }
        if (formato === 'moeda') return nf2.format(v) + ' MZN';
        if (formato === 'kg') return nf.format(v) + ' kg';
        return nf.format(v);
    }

    function el(tag, attrs, ns) {
        var e = ns ? document.createElementNS(SVG, tag) : document.createElement(tag);
        for (var k in attrs || {}) e.setAttribute(k, attrs[k]);
        return e;
    }

    // Tooltip partilhado
    var tip;
    function mostrarTip(evt, titulo, valor) {
        if (!tip) { tip = el('div', { 'class': 'g-tip', role: 'status' }); document.body.appendChild(tip); }
        tip.innerHTML = '';
        var t = el('div', { 'class': 'g-tip-r' }); t.textContent = titulo;
        var v = el('div', { 'class': 'g-tip-v' }); v.textContent = valor;
        tip.appendChild(t); tip.appendChild(v);
        tip.style.display = 'block';
        var x = evt.clientX + 14, y = evt.clientY + 14;
        var w = tip.offsetWidth, h = tip.offsetHeight;
        if (x + w > window.innerWidth - 8) x = evt.clientX - w - 14;
        if (y + h > window.innerHeight - 8) y = evt.clientY - h - 14;
        tip.style.left = x + 'px'; tip.style.top = y + 'px';
    }
    function esconderTip() { if (tip) tip.style.display = 'none'; }

    function passoBonito(max, n) {
        if (max <= 0) return 1;
        var bruto = max / n, mag = Math.pow(10, Math.floor(Math.log10(bruto)));
        var r = bruto / mag;
        return (r <= 1 ? 1 : r <= 2 ? 2 : r <= 2.5 ? 2.5 : r <= 5 ? 5 : 10) * mag;
    }

    function vazio(alvo) {
        alvo.innerHTML = '<p class="g-vazio">Sem dados para mostrar.</p>';
    }

    /* Colunas verticais (série temporal / categorias ordenadas) */
    function colunas(alvo, dados, formato) {
        alvo.innerHTML = '';
        if (!dados.length) return vazio(alvo);
        var W = alvo.clientWidth || 600, H = 240;
        var m = { t: 12, r: 8, b: 28, l: 64 };
        var max = Math.max.apply(null, dados.map(function (d) { return d.v; }));
        var ref = max > 0 ? max : 1000;
        var passo = passoBonito(ref, 4), topo = Math.ceil(ref / passo) * passo;
        var iw = W - m.l - m.r, ih = H - m.t - m.b;
        var svg = el('svg', { viewBox: '0 0 ' + W + ' ' + H, width: W, height: H, role: 'img',
            'aria-label': alvo.getAttribute('aria-label') || 'Gráfico de colunas' }, true);

        for (var g = 0; g <= topo + 1e-9; g += passo) {
            var y = m.t + ih - (g / topo) * ih;
            svg.appendChild(el('line', { x1: m.l, x2: W - m.r, y1: y, y2: y, 'class': g === 0 ? 'g-base' : 'g-grelha' }, true));
            var tl = el('text', { x: m.l - 8, y: y + 4, 'text-anchor': 'end', 'class': 'g-eixo' }, true);
            tl.textContent = formatar(g, formato, true);
            svg.appendChild(tl);
        }

        var banda = iw / dados.length, bw = Math.min(48, banda * 0.6);
        dados.forEach(function (d) {
            var i = dados.indexOf(d);
            var cx = m.l + banda * i + banda / 2;
            var h = (d.v / topo) * ih, x = cx - bw / 2, y0 = m.t + ih;
            if (h > 0) {
                var r = Math.min(4, h, bw / 2);
                var p = 'M' + x + ',' + y0 + 'V' + (y0 - h + r) + 'Q' + x + ',' + (y0 - h) + ' ' + (x + r) + ',' + (y0 - h) +
                        'H' + (x + bw - r) + 'Q' + (x + bw) + ',' + (y0 - h) + ' ' + (x + bw) + ',' + (y0 - h + r) + 'V' + y0 + 'Z';
                svg.appendChild(el('path', { d: p, 'class': 'g-marca' }, true));
            }
            var lbl = el('text', { x: cx, y: H - 8, 'text-anchor': 'middle', 'class': 'g-eixo' }, true);
            lbl.textContent = d.r;
            svg.appendChild(lbl);
            // alvo de hover maior do que a marca
            var hit = el('rect', { x: m.l + banda * i, y: m.t, width: banda, height: ih, 'class': 'g-hit' }, true);
            hit.addEventListener('mousemove', function (e) { hit.classList.add('ativo'); mostrarTip(e, d.r, formatar(d.v, formato)); });
            hit.addEventListener('mouseleave', function () { hit.classList.remove('ativo'); esconderTip(); });
            svg.insertBefore(hit, svg.firstChild);
        });
        alvo.appendChild(svg);
    }

    /* Barras horizontais (ranking) — rótulo e valor sempre visíveis */
    function barras(alvo, dados, formato) {
        alvo.innerHTML = '';
        if (!dados.length) return vazio(alvo);
        var max = Math.max.apply(null, dados.map(function (d) { return d.v; })) || 1;
        var lista = el('div', { 'class': 'g-barras', role: 'list' });
        dados.forEach(function (d) {
            var linha = el('div', { 'class': 'g-linha', role: 'listitem' });
            var r = el('span', { 'class': 'g-rot' }); r.textContent = d.r; r.title = d.r;
            var trilho = el('span', { 'class': 'g-trilho' });
            var barra = el('span', { 'class': 'g-barra' });
            barra.style.width = Math.max(d.v > 0 ? 1.5 : 0, (d.v / max) * 100) + '%';
            trilho.appendChild(barra);
            var v = el('span', { 'class': 'g-val' }); v.textContent = formatar(d.v, formato);
            linha.appendChild(r); linha.appendChild(trilho); linha.appendChild(v);
            linha.addEventListener('mousemove', function (e) { mostrarTip(e, d.r, formatar(d.v, formato)); });
            linha.addEventListener('mouseleave', esconderTip);
            lista.appendChild(linha);
        });
        alvo.appendChild(lista);
    }

    var tipos = { colunas: colunas, barras: barras };

    function desenharTodos() {
        document.querySelectorAll('[data-grafico]').forEach(function (alvo) {
            var fonte = document.getElementById(alvo.getAttribute('data-fonte'));
            var dados = [];
            try { dados = JSON.parse(fonte ? fonte.textContent : '[]'); } catch (e) { /* mantém vazio */ }
            var fn = tipos[alvo.getAttribute('data-grafico')];
            if (fn) fn(alvo, dados, alvo.getAttribute('data-formato'));
        });
    }

    document.addEventListener('DOMContentLoaded', desenharTodos);
    var t;
    window.addEventListener('resize', function () { clearTimeout(t); t = setTimeout(desenharTodos, 120); });
})();
