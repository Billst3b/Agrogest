# 🌱 AgroGest — Sistema de Gestão Agrícola

**Curso:** Engenharia Informática · **Disciplina:** Sistemas Distribuídos  
**Tema:** Desenvolvimento Web com Java (Jakarta Servlets 6.0 + Apache Tomcat 10.1)  
**Contexto:** Gestão integrada de produção agrícola, fornecedores, insumos, campanhas, cultivos, colheitas e facturação comercial (com IVA a 16%) na **Província de Nampula, Moçambique**.

---

## 🔑 Credenciais de Teste (Pré-carregadas no Arranque)

| Perfil | Nome | Email | Palavra-passe | Localização |
| :--- | :--- | :--- | :--- | :--- |
| **Administrador** | Administrador | `admin@agro.mz` | `admin234` | Nampula |
| **Cliente** | João Silva | `joao@teste.mz` | `1234` | Av. Eduardo Mondlane, Nampula |
| **Cliente** | Cliente Demo | `cliente@agro.mz` | `cliente123` | Av. 24 de Julho, Maputo |
| **Cliente** | Amina Momade | `amina@agro.mz` | `1234` | Muhala Expansão, Nampula |
| **Cliente** | Carlos Mucavele | `carlos@cooperativa.mz` | `1234` | Nacala-Porto |

---

## 🏗️ Descrição da Arquitetura (Padrão MVC)

A aplicação segue rigorosamente a arquitetura **MVC (Model-View-Controller)** sobre **Jakarta EE 10**:

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
│  │ • RelatorioService (rankings por volume, assiduidade, A-Z)│  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ REPO & PERSISTÊNCIA:                                      │  │
│  │ • DataStore (Collections.synchronizedList + AtomicInteger)│  │
│  │ • PersistenciaUtil (agrogest_state.ser — escrita atómica) │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │ VIEWS: JSP + JSTL 3.0 + Expression Language (EL)          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Estrutura de Pacotes (`mz.ac.istcem.agrogest`)
* `model`: POJOs `Serializable` (`Utilizador`, `Administrador`, `Cliente`, `Fornecedor`, `Produto`, `Campanha`, `Cultivo`, `Colheita`, `Venda`, `VendaItem`).
* `repo`: `DataStore` (Singleton em memória com listas sincronizadas e `AtomicInteger`) e `EstadoSistema`.
* `service`: `VendaService` (desconto atómico de stock e emissão de factura `FT-YYYY-N` com IVA de 16%) e `RelatorioService`.
* `servlet` & `servlet.admin`: Controladores HTTP anotados com `@WebServlet`.
* `filter`: `AuthFilter` — protege `/admin/*` (exige perfil `ADMIN`, retorna HTTP 403 caso contrário) e rotas de cliente.
* `listener`: `AppListener` (`@WebListener`) — carrega o estado de `agrogest_state.ser` no arranque, inicializa dados de demonstração caso vazio, e grava automaticamente no encerramento do Tomcat.
* `util`: `PasswordUtil` (SHA-256), `PersistenciaUtil` (escrita atómica via ficheiro `.tmp`), `GraficoUtil`.

---

## 🚀 Instruções de Instalação e Deploy

### Pré-requisitos
* **Java JDK 17** ou superior (compatível com JDK 21/25)
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
 E aceder a: **[http://localhost:8080/agrogest/](http://localhost:8080/agrogest/)**

### 3. Deploy em Servidor Linux com `systemd`
1. Copiar o ficheiro WAR para o Tomcat:
   ```bash
   sudo cp target/agrogest.war /opt/tomcat/webapps/
   ```
2. Gerir o serviço Tomcat via `systemd`:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable tomcat
   sudo systemctl restart tomcat
   sudo systemctl status tomcat
   ```
