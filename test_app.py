import requests

# Configurações
KEYCLOAK_URL = "http://keycloak:8080/realms/teste/protocol/openid-connect/token"
CLIENT_ID = "client_registrador"
CLIENT_SECRET = "client_secret"
USERNAME = "usuario_teste"
PASSWORD = "senha_teste"

APP_URL = "http://python:5000"  # URL interna do serviço Flask no Docker Compose

def test_login_and_token():
    # Primeiro, tentar pegar um token com username/senha
    payload = {
        'grant_type': 'password',
        'client_id': 'registrador',
        'client_secret': 'segredo123',
        'username': 'rosa',
        'password': 'rosa',
    }
    response = requests.post(KEYCLOAK_URL, data=payload)
    assert response.status_code == 200, f"Erro no login: {response.text}"
    token = response.json().get('access_token')
    assert token is not None, "Access token não recebido"

    print("Login bem-sucedido e token recebido.")

def test_acesso_flask():
    # Acessar a aplicação Flask após login
    session = requests.Session()
    r = session.get(f"{APP_URL}/login")
    assert r.status_code == 200, "Falha ao acessar /login"

    print("Acesso inicial à aplicação Flask OK.")

if __name__ == "__main__":
    test_login_and_token()
    test_acesso_flask()
    print("Todos os testes passaram com sucesso!")
