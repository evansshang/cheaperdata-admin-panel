import os
import sys
sys.path.insert(0, os.path.abspath(os.path.dirname(__file__)))

from flask import Flask, render_template, send_from_directory, session, redirect, url_for, jsonify
from models import db
from models.user import User

from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.settings import settings_bp

app = Flask(__name__)

# Configuration
app.static_folder = os.path.join(os.path.dirname(__file__), 'static')
app.template_folder = os.path.join(os.path.dirname(__file__), 'templates')
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'asd##f#G5gvagsf$55JWG!')

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cheaperdata.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# Create database tables and admin user
with app.app_context():
    db.create_all()
    admin = User.query.filter_by(username='admin').first()
    if not admin:
        admin = User(
            username='admin',
            email='admin@example.com',
            is_admin=True
        )
        admin.set_password('admin123')
        db.session.add(admin)
        db.session.commit()

# Register blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(settings_bp, url_prefix='/settings')

@app.route('/')
def home():
    return "<h1>Welcome to CheaperData Admin Panel</h1><p>The backend is running.</p>"

@app.route('/status')
def status():
    return jsonify({
        "status": "ok",
        "message": "CheaperData backend is live",
        "version": "1.0"
    })
@app.route('/users-debug')
def users_debug():
    users = User.query.all()
    user_data = [{'id': u.id, 'username': u.username, 'email': u.email} for u in users]
    return jsonify(user_data)
if __name__ == '__main__':
    app.run(debug=True)
