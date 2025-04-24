#criacao do realm
resource "keycloak_realm" "teste" {
  realm   = "teste"
  enabled = true
  display_name = "Teste Realm"
  ssl_required = "none"
  registration_allowed = true
  login_with_email_allowed = false
  reset_password_allowed   = false
  remember_me = true

  internationalization {
    supported_locales = [
      "en",
      "pt-BR",
      "es"
    ]
    default_locale    = "pt-BR"
  }
}
