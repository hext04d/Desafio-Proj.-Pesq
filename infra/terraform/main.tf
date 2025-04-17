terraform {
    required_providers {
        keycloak = {
            source = "mrparkers/keycloak"
            version = ">=4.1.0"
        }
    }
}

provider "keycloak" {
    client_id       = "admin-cli"
    username        = "admin"
    password        = "admin"
    url             = "http://localhost:8080"
    realm           = "master"
}
#permite terraform conectar ao keycloak local rodando via docker.

#criacao do realm

resource "keycloak_realm" "teste" {
  realm   = "teste"
  enabled = true
  display_name = "Teste Realm"
  ssl_required = "none"
}

#cria dois usuarios no realm teste com atributos diferentes

resource "keycloak_user" "user1" {
  realm_id = keycloak_realm.teste.id
  username = "user1"
  first_name = "User"
  last_name  = "Um"
  email      = "user1@exemplo.com"
  enabled    = true
  attributes = {
    "nivel_acesso" = "alto"
  }
}

resource "keycloak_user" "user2" {
  realm_id = keycloak_realm.teste.id
  username = "user2"
  first_name = "User"
  last_name  = "Dois"
  email      = "user2@exemplo.com"
  enabled    = true
  attributes = {
    "nivel_acesso" = "baixo"
  }
}

#cria um client no realm teste com acesso publico e habilitado para fluxo padrao e concessao de acesso direto.
resource "keycloak_openid_client" "dynamic_client_registration" {
  realm_id                         = keycloak_realm.teste.id
  client_id                        = "dynamic-client-registration"
  name                             = "Dynamic Client Registration"
  enabled                          = true
  access_type                      = "PUBLIC"
  standard_flow_enabled            = true
  direct_access_grants_enabled     = true
  valid_redirect_uris              = ["http://localhost:3000/callback"]
}

#cria um client no realm teste com o nome de registrador, com acesso confidencial, fluxo padrao desabilitado e concessao de acesso direto desabilitada. O segredo do cliente é "segredo123".
resource "keycloak_openid_client" "client_registrador" {
  realm_id                    = keycloak_realm.teste.id
  client_id                   = "registrador"
  name                        = "Client Registrador"
  access_type                 = "CONFIDENTIAL"
  enabled                     = true
  service_accounts_enabled    = true
  standard_flow_enabled       = false
  direct_access_grants_enabled = false
  client_secret               = "segredo123"
}
