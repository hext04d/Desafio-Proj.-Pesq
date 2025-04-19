terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
      version = ">=4.0.0"
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
  registration_allowed = true
  login_with_email_allowed = true
  reset_password_allowed   = true
}

#======================================================================
#cria um grupo no realm teste com o nome de admins e nivel de acesso alto.
resource "keycloak_group" "admins" {
  realm_id = keycloak_realm.teste.id
  name = "admins"
  attributes = {
  "nivel_acesso" = "alto"
  }
}

#cria um role no realm teste com o nome de admins e nivel de acesso alto.
resource "keycloak_group_roles" "admins_roles" {
  realm_id = keycloak_realm.teste.id
  group_id = keycloak_group.admins.id
  role_ids = [keycloak_realm.teste.id]
}

#registra o usuario Marcelo no grupo admins.
resource "keycloak_group_memberships" "admins" {
  realm_id = keycloak_realm.teste.id
  group_id = keycloak_group.admins.id
  members = [
    "marcelo"
  ]
}

#cria um grupo no realm teste com o nome de users e nivel de acesso baixo.
resource "keycloak_group" "users" {
  realm_id = keycloak_realm.teste.id
  name = "users"
  attributes = {
  "nivel_acesso" = "baixo"
  }
}

#cria um role no realm teste com o nome de users e nivel de acesso baixo.
resource "keycloak_group_roles" "users_roles" {
  realm_id = keycloak_realm.teste.id
  group_id = keycloak_group.users.id
  role_ids = [keycloak_realm.teste.id]
}

#registra o usuario Rosa no grupo users.
resource "keycloak_group_memberships" "users" {
  realm_id = keycloak_realm.teste.id
  group_id = keycloak_group.users.id
  members = [
    "rosa"
  ]
}

#cria dois usuarios no realm teste com atributos diferentes
resource "keycloak_user" "Marcelo" {
  realm_id = keycloak_realm.teste.id
  username = "marcelo"
  first_name = "Marcelo"
  last_name  = "Um"
  email      = "Marcelo@exemplo.com"
  enabled    = true
}

resource "keycloak_user" "Rosa" {
  realm_id = keycloak_realm.teste.id
  username = "rosa"
  first_name = "Rosa"
  last_name  = "Dois"
  email      = "Rosa@exemplo.com"
  enabled    = true
}
#======================================================================

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
