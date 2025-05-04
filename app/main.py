from flask import Flask, redirect, url_for, session, request, render_template
from authlib.integrations.flask_client import OAuth
from config import DISCOVERY_URL, OIDC_CLIENT_ID, REDIRECT_URI
import secrets

app = Flask(__name__)
app.secret_key = 'secret'

oauth = OAuth(app)
oauth.register(
    name='keycloak',
    client_id=OIDC_CLIENT_ID,
    client_kwargs={
        'scope': 'openid profile email',
    },
    server_metadata_url=DISCOVERY_URL,
    redirect_uri=REDIRECT_URI,
)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login')
def login():
    redirect_uri = url_for('callback', _external=True)
    nonce = secrets.token_urlsafe()
    session['nonce'] = nonce
    return oauth.keycloak.authorize_redirect(redirect_uri, nonce=nonce)

@app.route('/callback')
def callback():
    token = oauth.keycloak.authorize_access_token()
    nonce = session.pop('nonce', None)
    userinfo = oauth.keycloak.parse_id_token(token, nonce=nonce)

    print("ACR recebido:", userinfo.get('acr'))

    # Armazenar o token de acesso na sessão
    session['access_token'] = token.get('access_token')
    session['user'] = userinfo
    print("Userinfo completo:", userinfo)

    acr = userinfo.get('acr', '0')
    if acr == '2':
        return render_template('nivel_alto.html', user=userinfo)
    else:
        return render_template('nivel_baixo.html', user=userinfo)


@app.route('/home')
def home():
    user = session.get('user')
    if not user:
        return redirect(url_for('login'))
    return render_template('home.html', user=user)

@app.route('/conta')
def conta():
    # Redireciona para a tela de configurações do Keycloak
    return redirect("http://localhost:8080/realms/teste/account")

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True)
