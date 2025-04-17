import requests
import json

KEYCLOAK_URL = "http://localhost:8080"
REALM = "teste"
CLIENT_ID = "registrador"
CLIENT_SECRET = "segredo123"

#obter token
token_resp = requests.post(
    f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token",
    data={
        "grant_type": "client_credentials",
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET
    },
    headers={"Content-Type": "application/x-www-form-urlencoded"}
)

if token_resp.status_code != 200:
    print("Erro ao obter token.")
    print(token_resp.text)
    exit()

access_token = token_resp.json()["access_token"]

#registrar novo client com o token
registration_url = f"{KEYCLOAK_URL}/realms/{REALM}/clients-registrations/openid-connect"
client_data = {
    "client_name": "novo-client",
    "redirect_uris": ["http://localhost:3000/callback"],
    "grant_types": ["authorization_code"],
    "response_types": ["code"],
    "token_endpoint_auth_method": "none"
}

response = requests.post(
    registration_url,
    headers={
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    },
    data=json.dumps(client_data)
)

if response.status_code == 201:
    print("Registro autenticado com sucesso!Yipeeee")
    print(json.dumps(response.json(), indent=2))
else:
    print("Erro ao registrar client. Socorro")
    print(f"Status Code: {response.status_code}")
    print(response.text)
