# AgroGest — Sistema de Gestão Agrícola

**Instituição:** Instituto Superior de Ciências e Tecnologia de Moçambique (ISCTEM)  
**Curso:** Engenharia Informática (3.º Ano — Turma A) · **Disciplina:** Sistemas Distribuídos  
**Tema:** Desenvolvimento Web com Java (Jakarta Servlets 6.0 + JSP 3.1 + Apache Tomcat 10.1)  
**Contexto:** Gestão integrada de produção agrícola, fornecedores, insumos, campanhas, cultivos, colheitas e facturação comercial (com IVA a 16%) na **Província de Nampula, Moçambique**.

### Autores do Grupo
| Nome do Estudante | Código |
| :--- | :--- |
| **Muhamad Shahin Riaz** | `20240568` |
| **Adayl Rafik Amad Seni** | `20240330` |
| **Kenny Matsule** | `20240908` |

---

## Documentação e Entregáveis no Repositório

* **[`docs/MANUAL_DE_UTILIZACAO.pdf`](docs/MANUAL_DE_UTILIZACAO.pdf)** — Manual de Utilização passo a passo para Administrador e Cliente (versão PDF pronta para impressão e entrega ao docente).
* **[`docs/RELATORIO_TRABALHO_PRATICO.pdf`](docs/RELATORIO_TRABALHO_PRATICO.pdf)** — Relatório Técnico completo do Trabalho Prático (arquitectura MVC, modelo de domínio, concorrência, persistência e regras de negócio).
* **[`docs/ENUNCIADO_TRABALHO_PRATICO.md`](docs/ENUNCIADO_TRABALHO_PRATICO.md)** — Enunciado oficial do trabalho prático.
* **[`docs/tomcat.service`](docs/tomcat.service)** — Unidade `systemd` para gestão do serviço Apache Tomcat 10.1 em Linux.
* **`target/agrogest.war`** — Pacote WAR pronto a publicar no Apache Tomcat 10.1.

---

## Credenciais de Teste (Pré-carregadas no Arranque)

| Perfil | Nome | Email | Palavra-passe | Localização |
| :--- | :--- | :--- | :--- | :--- |
| **Administrador** | Administrador | `admin@agro.mz` | `admin234` | Nampula |
| **Cliente** | João Silva | `joao@teste.mz` | `1234` | Av. Eduardo Mondlane, Nampula |
| **Cliente** | Cliente Demo | `cliente@agro.mz` | `cliente123` | Av. 24 de Julho, Maputo |
| **Cliente** | Amina Momade | `amina@agro.mz` | `1234` | Muhala Expansão, Nampula |
| **Cliente** | Carlos Mucavele | `carlos@cooperativa.mz` | `1234` | Nacala-Porto |
| **Cliente** | Fátima Ussene | `fatima@ribaueterras.mz` | `1234` | Distrito de Ribáuè, Nampula |
| **Cliente** | Bernardo Chissano | `bernardo@malema.mz` | `1234` | Vila de Malema, Nampula |
| **Cliente (Sem Compras)** | Helena Nhantumbo | `helena@monapo.mz` | `1234` | Vila de Monapo, Nampula |
| **Cliente (Sem Compras)** | Celso Matsinhe | `celso@meconta.mz` | `1234` | Distrito de Meconta, Nampula |

---

## Descrição da Arquitetura (Padrão MVC)

A aplicação segue rigorosamente a arquitetura **MVC (Model-View-Controller)** sobre **Jakarta EE 10**, sem recurso a bases de dados relacionais (todas as entidades residem em listas sincronizadas em memória e são persistidas em ficheiro binário `agrogest_state.ser`):

```
┌─────────────────────────────────────────────────────────────────┐
│                        BROWSER (Cliente)                        │
│              HTML5 + CSS3 Glassmorphism + SVG JS                │
└───────────────────────────────┬─────────────────────────────────┘
                                │ HTTP :8080 /agrogest
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                       APACHE TOMCAT 10.1                        │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ FILTERS: AuthFilter (@WebFilter — Sessão + Perfil RBAC)   │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ SERVLETS (Controllers):                                   │  │
│  │ • Autenticação: LoginServlet, RegistoServlet, Logout      │  │
│  │ • Cliente: CatalogoServlet, CarrinhoServlet, Checkout,    │  │
│  │            FacturaServlet, MinhasComprasServlet           │  │
│  │ • Admin: AdminDashboardServlet, ProdutoServlet,           │  │
│  │          FornecedorServlet, CampanhaServlet,              │  │
│  │          CultivoServlet, ColheitaServlet,                 │  │
│  │          VendaAdminServlet, ClienteAdminServlet,          │  │
│  │          RelatorioServlet, PersistenciaServlet            │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ SERVICES (Regras de Negócio):                             │  │
│  │ • VendaService (synchronized — transacção atómica stock)  │  │
│  │ • RelatorioService (rankings por nome, volume, assíduos)  │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ REPO & PERSISTÊNCIA:                                      │  │
│  │ • DataStore (Collections.synchronizedList + AtomicInteger)│  │
│  │ • PersistenciaUtil (agrogest_state.ser + backup .bak)     │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ VIEWS: JSP + JSTL 3.0 + Expression Language (EL)          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Estrutura de Pacotes (`mz.ac.istcem.agrogest`)
* `model`: 10 POJOs `Serializable` (`Utilizador`, `Administrador`, `Cliente`, `Fornecedor`, `Produto`, `Campanha`, `Cultivo`, `Colheita`, `Venda`, `VendaItem`).
* `repo`: `DataStore` (Singleton em memória com `Collections.synchronizedList` e contadores `AtomicInteger`) e `EstadoSistema` (snapshot serializável).
* `service`: `VendaService` (desconto atómico de stock em duas passagens sob `synchronized (store)` e emissão de factura `FT-AAAA-N` com IVA de 16%) e `RelatorioService`.
* `servlet` & `servlet.admin`: 18 Controladores HTTP anotados com `@WebServlet`, seguindo o padrão Post-Redirect-Get (PRG).
* `filter`: `AuthFilter` — protege `/admin/*` (exige perfil `ADMIN`, encaminha para `erro403.jsp` com HTTP 403 caso contrário) e exige sessão activa para `/catalogo`, `/carrinho/*`, `/compra`, `/factura`, `/minhas-compras`.
* `listener`: `AppListener` (`@WebListener`) — carrega o estado de `agrogest_state.ser` no arranque, inicializa o administrador e os dados de demonstração caso vazio, e grava automaticamente no encerramento do Tomcat.
* `util`: `PasswordUtil` (hash SHA-256), `PersistenciaUtil` (escrita atómica via `.tmp` e cópia de segurança `.bak`), `GraficoUtil`.

---

## Instruções de Instalação, Configuração de Portas e Deploy

### Pré-requisitos
* **Java JDK 17** ou superior (compatível com JDK 17/21/25)
* **Apache Maven 3.9+**
* **Apache Tomcat 10.1.x**

### 1. Compilar e Empacotar o WAR
```bash
mvn clean package
```
O pacote final é gerado em `target/agrogest.war`.

### 2. Executar em Ambiente Windows (Atalho Rápido)
Basta executar o script incluído na raiz do projeto:
```cmd
run.bat
```
Para encerrar o servidor gravando o estado:
```cmd
stop.bat
```
Aceder no navegador a: **[http://localhost:8080/agrogest/](http://localhost:8080/agrogest/)**

### 3. Configurar Portas no Apache Tomcat (Objectivo 8)
Por omissão, o Tomcat escuta na porta `8080`. Para alterar a porta HTTP (por exemplo, para `8081` conforme o diagrama do enunciado):
1. Abrir o ficheiro `$CATALINA_HOME/conf/server.xml`.
2. Localizar o elemento `<Connector port="8080" protocol="HTTP/1.1" ... />` e alterar para:
   ```xml
   <Connector port="8081" protocol="HTTP/1.1"
              connectionTimeout="20000"
              redirectPort="8443"
              URIEncoding="UTF-8" />
   ```
3. Reiniciar o Tomcat (`systemctl restart tomcat` ou `stop.bat` + `run.bat`).

### 4. Deploy em Servidor Linux com `systemd`
1. Copiar o ficheiro WAR para o Tomcat:
   ```bash
   sudo cp target/agrogest.war /opt/tomcat/webapps/
   ```
2. Instalar a unidade systemd fornecida em [`docs/tomcat.service`](docs/tomcat.service):
   ```bash
   sudo cp docs/tomcat.service /etc/systemd/system/tomcat.service
   ```
3. Gerir o serviço Tomcat via `systemd`:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable tomcat
   sudo systemctl restart tomcat
   sudo systemctl status tomcat
   ```

---

## Resumo do Manual de Utilização

> O manual detalhado passo a passo encontra-se em **[`docs/MANUAL_DE_UTILIZACAO.pdf`](docs/MANUAL_DE_UTILIZACAO.pdf)**.

### Módulo Administrador (`admin@agro.mz` / `admin234`)
1. **Dashboard (`/admin/dashboard`)** — Indicadores de receita, IVA (16%), colheitas, stock e gráficos analíticos; botões de **Persistência em Ficheiro** no topo (*Gravar Estado (.ser)* para forçar serialização imediata e *Eliminar Ficheiro* para repor o estado em disco).
2. **Produtos (`/admin/produtos`)** — Clicar em *+ Registar Novo Produto* abre o estúdio modal com pré-visualização em tempo real, galeria rápida de fotografias e selecção das 4 categorias oficiais (`SEMENTE`, `FERTILIZANTE`, `MAQUINARIA`, `FERRAMENTA`). Permite filtrar por *Em Armazém (Stock > 0)*, ordenar por Nome, Preço ou Stock, repor quantidades (`+ Repor`) e remover produtos.
3. **Fornecedores (`/admin/fornecedores`)** — Criar e listar fornecedores (`SEMENTES`, `MAQUINARIA`, `FERTILIZANTES`), ordenar por nome ou província, e remover fornecedores sem produtos associados.
4. **Campanhas (`/admin/campanhas`)** — Criar campanhas com validação de datas (fim ≥ início), fechar/reabrir campanhas e impedir remoção quando possuem cultivos associados.
5. **Cultivos (`/admin/cultivos`)** — Registar cultivos associados a uma campanha (cultura, variedade, hectares, data de plantio) e impedir remoção quando possuem colheitas.
6. **Colheitas (`/admin/colheitas`)** — Registar colheitas por cultivo (valida que a data da colheita é igual ou posterior à data de plantio) com cálculo automático do valor total (`quantidadeKg × precoPorKg`).
7. **Vendas e Compras Detalhadas (`/admin/vendas`)** — Clicar em *+ Nova Venda Balcão* para emitir uma venda multi-item em nome de um cliente com desconto atómico de stock, e consultar a listagem de compras detalhadas (ordenada por data, valor ou cliente) com acesso directo a cada factura.
8. **Clientes (`/admin/clientes`)** — Registar novos clientes, ordenar por nome ou número de compras, e impedir remoção de clientes com histórico de compras.
9. **Relatórios (`/admin/relatorios`)** — Apresenta os 4 relatórios exigidos pelo enunciado:
   * *Clientes ordenados por nome (crescente A–Z)*;
   * *Clientes que compraram (ordenados por volume em MZN)*;
   * *Clientes mais assíduos (ranking por número de compras)*;
   * *(Extra) Clientes registados sem compras*.

### Módulo Cliente (`joao@teste.mz` / `1234`)
1. **Auto-registo (`/registo.jsp`)** — Criar conta com nome, email único, palavra-passe (mínimo 4 caracteres), telefone e endereço.
2. **Catálogo (`/catalogo`)** — Consultar produtos com fotografia, descrição, validade, fornecedor, preço e stock disponível; filtrar por categoria (`SEMENTE`, `FERTILIZANTE`, `MAQUINARIA`, `FERRAMENTA`), pesquisar por texto e ordenar.
3. **Carrinho (`/carrinho`)** — Adicionar produtos com validação imediata de stock, alterar quantidades, remover linhas ou esvaziar o carrinho (persistido em `HttpSession`).
4. **Checkout e Emissão de Factura (`/compra` → `/factura`)** — Confirma a compra, desconta atomicamente o stock de todos os itens e emite a factura oficial (`FT-AAAA-N`) com dados do cliente, subtotal, IVA (16%) e total, pronta a imprimir (`window.print()`).
5. **Histórico (`/minhas-compras`)** — Consultar todas as compras anteriores do cliente autenticado e abrir as respectivas facturas.
