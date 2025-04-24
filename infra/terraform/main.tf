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
