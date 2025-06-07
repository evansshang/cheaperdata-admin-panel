
import os
import sys
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from flask import Flask, render_template, send_from_directory, session, redirect, url_for, jsonify
from flask_sqlalchemy import SQLAlchemy
from models.user import User

from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.settings import settings_bp

app = Flask(__name__,
            static_folder=os.path.join(os.path.dirname(__file__), 'static'),
            template_folder=os.path.join(os.path.dirname(__file__), 'templates'))

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'asd##f#G5gvvasgf$55JWGt')
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cheaperdata.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Create DB and admin user if not exists
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
        print("Admin user created.")
    else:
        print("Admin user already exists.")

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(settings_bp, url_prefix='/settings')

@app.route('/')
def home():
    return "<h1>Welcome to Cheaperdata Admin Panel</h1><p>The backend is running.</p>"

@app.route('/status')
def status():
    return jsonify({
        "status": "ok",
        "message": "Cheaperdata Admin Panel is live",
        "version": "1.0"
    })
