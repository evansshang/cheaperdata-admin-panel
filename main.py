from flask import Flask, render_template, request, redirect, url_for, session, send_from_directory, jsonify
from flask_sqlalchemy import SQLAlchemy
import os

from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.settings import settings_bp
from models.user import User

db = SQLAlchemy()  # Global declaration before anything else

app = Flask(__name__)
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')
app.template_folder = os.path.join(os.path.dirname(__file__), 'templates')
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'asd##fG5gvagsf555JWGT')

# Database configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cheaperdata.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()
    user = User.query.filter_by(username='admin').first()
    if not user:
        user = User(
            username='admin',
            email='admin@example.com',
            is_admin=True
        )
        user.set_password('admin123')
        db.session.add(user)
        db.session.commit()
        print('Admin user created.')
    else:
        print('Admin user already exists.')

# Register Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(settings_bp, url_prefix='/settings')

@app.route("/")
def home():
    return "<h1>Welcome to CheaperData Admin Panel</h1><p>The backend is running.</p>"

@app.route("/status")
def status():
    return jsonify({
        "status": "ok",
        "message": "CheaperData Admin Panel is live",
        "version": "1.0"
    })
