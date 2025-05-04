# Desafio da bolsa GT-Baita IFRS
## Autenticação via OIDC com Keycloak e Flask

Projeto completo que demonstra como implementar um ecossistema de autenticação baseado em **OpenID Connect (OIDC)**, utilizando **Keycloak** como Provedor de Identidade (IdP) e uma aplicação **Flask** como Provedor de Serviço (SP). Toda a infraestrutura é gerenciada via **Docker Compose**, com automação e testes contínuos integrados ao **GitLab CI/CD**.


## Componentes

- **Keycloak** — Servidor de identidade e gerenciamento de acesso.
- **Flask** — Framework web leve em Python.
- **OIDC** — Protocolo de autenticação baseado em OAuth 2.0.
- **Docker + Docker Compose** — Containerização e orquestração dos serviços.
- **GitLab CI/CD** — Automação de build, testes e deploy.

---
## Arquitetura

```
Usuário
    ↓
[ Flask App ] ←→ [ Keycloak ]
    ↑                ↑
Docker Compose   Terraform
```

---

## Estrutura geral 
```
.
├── app               # Aplicação Flask
│    └── main.py
│    └── config.py
│    └── requirements.txt
│     │
│    └── static/       #CSS para o Flask
│    └── templates/    #HTMLs
│
├── docker/ # Orquestração dos serviços
│   └── docker-compose.yml
│    └── Dockerfile      # Flask App container
│
├── infra
│    └── terraform/
│        └── auth.tf
│        └── client.tf
│        └── main.tf
│        └── realm.tf
│        └── users.tf
│
├── scripts/
│    └── client_registro.py
│
├── test_app.py             # Testes automatizados
├── requirements.txt        # Dependências Python
├── 
│
│
├── .gitlab-ci.yml          # Pipeline GitLab
└── README.md               # Documentação
```

## Funcionalidades Implementadas

- ✅ Registro dinâmico de clientes no Keycloak

- ✅ Login com autenticação OIDC (senha ou senha + TOTP)

- ✅ Controle de acesso via atributo nivel_acesso

- ✅ Redirecionamento baseado no acr (nível de autenticação)

- ✅ Exibição de informações do usuário autenticado

- ✅ Testes automatizados via Python (test_app.py)

- ✅ Pipeline GitLab com build, testes e teardown automático

---
##  Como Executar Localmente
### Requisitos

- Docker

- Docker Compose

- Git

### Passos

#### Clone o repositório
```
git clone https://github.com/hext04d/Desafio-Proj.-Pesq.git
cd \Desafio-Proj.-Pesq
```

#### Construa e inicie os containers

```
docker compose up
```

### Inicie e aplique o Terraform

```
cd infra/terraform
terraform init
terraform apply
```

### Inicie a aplicação Flask
F5 ou botão "Run File"

ou

```
python main.py
```

### Acessos

Keycloak: http://localhost:8080

Flask App: http://localhost:5000/login

---

## Testes Automatizados

### Manualmente

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

python test_app.py
```

### Variações de Teste

- Login sem TOTP → acesso negado (`nivel_acesso: baixo`)
- Login com TOTP → acesso permitido (`nivel_acesso: alto`)
- Registro dinâmico do cliente → sucesso esperado
- Token OIDC → atributos `acr`, `nivel_acesso`, `email`, etc.

---

##  CI/CD com GitLab

Pipeline automatizado no arquivo `.gitlab-ci.yml`

---
## Controle de Acesso e Segurança

- **Autenticação OIDC**: via fluxo Authorization Code.
- **TOTP opcional no Keycloak**: configurado via autenticação com subflow `ALTERNATIVE`.
- **Verificação de `acr`**: identifica se o usuário usou MFA.
- **Atributo personalizado `nivel_acesso`**:
  - `baixo` → somente senha
  - `alto` → senha + TOTP

---

## Referências

- [Keycloak Docs](https://www.keycloak.org/documentation)
- [OpenID Connect Specification](https://openid.net/connect/)
- [RFC 7591 - Dynamic Client Registration](https://tools.ietf.org/html/rfc7591)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

## 📄 Licença

Este projeto está licenciado sob a MIT License.

---