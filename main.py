import os
from flask import Flask, render_template, send_from_directory, session, redirect, url_for, jsonify
from flask_sqlalchemy import SQLAlchemy

# Setup DB (but do not import models yet)
db = SQLAlchemy()

# Initialize app
app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "defaultsecret")

# Configuration
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///cheaperdata.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

# Bind db to app
db.init_app(app)

# Only now: import models (AFTER db.init_app)
with app.app_context():
    from models.user import User

    db.create_all()

    user = User.query.filter_by(username="admin").first()
    if not user:
        user = User(
            username="admin",
            email="admin@example.com",
            is_admin=True
        )
        user.set_password("admin123")
        db.session.add(user)
        db.session.commit()

# Blueprints (must be registered after app is ready)
from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.settings import settings_bp

app.register_blueprint(auth_bp, url_prefix="/auth")
app.register_blueprint(dashboard_bp, url_prefix="/dashboard")
app.register_blueprint(users_bp, url_prefix="/users")
app.register_blueprint(settings_bp, url_prefix="/settings")

@app.route("/")
def home():
    return "<h1>Welcome to Cheaperdata Admin Panel</h1><p>The backend is running.</p>"

@app.route("/status")
def status():
    return jsonify({
        "status": "ok",
        "message": "Cheaperdata Admin Panel is live",
        "version": "1.0"
    })
