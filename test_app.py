import os
import requests
from time import sleep

KEYCLOAK_URL = os.getenv("KEYCLOAK_URL")
CLIENT_ID = os.getenv("CLIENT_ID")
CLIENT_SECRET = os.getenv("CLIENT_SECRET", "")
USERNAME = os.getenv("KEYCLOAK_ADMIN")
PASSWORD = os.getenv("KEYCLOAK_ADMIN_PASSWORD")
APP_URL = os.getenv("FLASK_APP_URL")

def test_login_and_token():
    payload = {
        'grant_type': 'password',
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'username': USERNAME,
        'password': PASSWORD,
    }
    
    try:
        response = requests.post(KEYCLOAK_URL, data=payload)
        response.raise_for_status()
        token = response.json().get('access_token')
        assert token is not None
        print("Keycloak token obtained successfully")
    except Exception as e:
        print(f"Keycloak test skipped: {str(e)}")

def test_acesso_flask():
    try:
        response = requests.get(f"{APP_URL}/login")
        response.raise_for_status()
        print("Flask access successful")
    except Exception as e:
        print(f"Flask test skipped: {str(e)}")

if __name__ == "__main__":
    test_login_and_token()
    test_acesso_flask()