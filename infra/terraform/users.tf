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