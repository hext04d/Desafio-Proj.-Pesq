resource "keycloak_authentication_flow" "auth_e_pass" {
  realm_id    = keycloak_realm.teste.id
  alias       = "auth e pass"
  description = "Fluxo com autenticação baseada em senha e TOTP opcional"
  provider_id = "basic-flow"
}

resource "keycloak_authentication_execution" "username_password" {
  realm_id          = keycloak_realm.teste.id
  parent_flow_alias = keycloak_authentication_flow.auth_e_pass.alias
  authenticator     = "auth-username-password-form"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution_config" "username_password" {
  realm_id     = keycloak_realm.teste.id
  alias        = "username-password-context"
  execution_id = keycloak_authentication_execution.username_password.id

  config = {
    authnContextClassRef = "1"
  }
}

resource "keycloak_authentication_subflow" "totp_optional" {
  realm_id          = keycloak_realm.teste.id
  parent_flow_alias = keycloak_authentication_flow.auth_e_pass.alias
  alias             = "totp-subflow"
  provider_id       = "basic-flow"
  requirement       = "ALTERNATIVE"
  description       = "Subfluxo TOTP opcional"
}

resource "keycloak_authentication_execution" "totp_in_subflow" {
  realm_id          = keycloak_realm.teste.id
  parent_flow_alias = keycloak_authentication_subflow.totp_optional.alias
  authenticator     = "auth-otp-form"
  requirement       = "REQUIRED"
}

resource "keycloak_authentication_execution_config" "totp" {
  realm_id     = keycloak_realm.teste.id
  alias        = "totp-context"
  execution_id = keycloak_authentication_execution.totp_in_subflow.id

  config = {
    authnContextClassRef = "2"
  }
}
