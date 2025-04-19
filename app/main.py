from flask import Flask, redirect, url_for, session, request, render_template
from authlib.integrations.flask_client import OAuth
from config import DISCOVERY_URL, OIDC_CLIENT_ID, REDIRECT_URI
import json

app = Flask(__name__)
app.secret_key =  'secret'

#oauth
oauth = OAuth(app)
oauth.register(
    name = 'keycloak',
    client_id=OIDC_CLIENT_ID,
    client_kwargs={
        'scope': 'openid profile email',
    },
    server_metadata_url=DISCOVERY_URL,
    redirect_uri=REDIRECT_URI,
)

@app.route('/')
def index():
    return '<a href="/login">login com keycloak</a>'

@app.route('/login')
def login():
    redirect_uri = url_for('callback', _external=True)
    return oauth.keycloak.authorize_redirect(redirect_uri)

@app.route('/callback')
def callback():
    token = oauth.keycloak.authorize_access_token()
    userinfo = oauth.keycloak.parse_id_token(token)

    if userinfo.get('acr') == 'high':
        return render_template('totp.html')

    nivel = userinfo.get('nivel_acesso')
    if nivel != 'alto':
        return render_template('denied.html', nivel=nivel)

    session['user'] = userinfo
    return redirect(url_for('home'))

@app.route('/totp', methods=['POST'])
def totp():
    totp_code = request.form.get('totp_code')

    if verify_totp_code(totp_code):
        session['user']['nivel_acesso'] = 'alto'
        return redirect(url_for('home'))
    else:
        return render_template('totp.html', error="Código TOTP inválido")

@app.route('/home')
def home():
    user = session.get('user')
    if not user:
        return redirect(url_for('login'))
    
    return render_template('home.html', user=user)

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

def verify_totp_code(totp_code):
    return True

if __name__ == '__main__':
    app.run(debug=True)
