import os
import sys

# Allow imports from current directory
sys.path.insert(0, os.path.dirname(__file__))

from flask import Flask, send_from_directory, session, redirect, url_for

# ✅ Corrected Blueprint imports
from models.user import db
from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.orders import orders_bp
from routes.settings import settings_bp

app = Flask(__name__)

# Configuration
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')
app.template_folder = os.path.join(os.path.dirname(__file__), 'templates')
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'asdf#FGSgvasgf$55JWGT')

# Enable database
database_url = os.environ.get('DATABASE_URL', 'postgresql:///cheaperdata_db')
app.config['SQLALCHEMY_DATABASE_URI'] = database_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Register Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(orders_bp, url_prefix='/orders')
app.register_blueprint(settings_bp, url_prefix='/settings')
