import os
import sys
# Allow imports from current directory
sys.path.insert(0, os.path.dirname(__file__))
from flask import Flask, send_from_directory, session, redirect, url_for
from flask import Flask, render_template, send_from_directory, session, redirect, url_for
from flask import jsonify  
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
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///cheaperdata.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()
    from models.user import User
    user = 
User.query.filter_by(username='admin').first()
            if not user:
        user =User(
            username='admin',
            email='admin@example.com',
            is_admin=True
        )
        user.set_password('admin123')
        db.session.add(user)
        db.session.commit()
        print('Admin user created.')
    else:
        print("Admin user already exists.")
# Register Blueprints
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(orders_bp, url_prefix='/orders')
app.register_blueprint(settings_bp, url_prefix='/settings')
@app.route("/")
            def home():
    return "<h1>Welcome to CheaperData Admin Panel</h1><p>The backend is running!</p>"


@app.route("/status")
def status():
    return jsonify({
        "status": "ok",
        "message": "Cheaperdata backend is running",
        "version": "1.0"
    })

    return jsonify({
        "status": "ok",
        "message": "Cheaperdata Admin Panel is live",
        "version": "1.0"
    })
   
    
