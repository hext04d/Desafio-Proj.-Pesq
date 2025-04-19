import os

KEYCLOAK_BASE_URL = os.getenv("KEYCLOAK_BASE_URL", "http://localhost:8080")
REALM = os.getenv("KEYCLOAK_REALM", "teste")

OIDC_CLIENT_ID = "0784b2e3-9405-41cf-b227-1c26c2c4d23b"

DISCOVERY_URL = "http://localhost:8080/realms/teste/.well-known/openid-configuration"
REDIRECT_URI = "http://localhost:5000/callback"
