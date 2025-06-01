import os
import sys

# Allow imports from current directory
sys.path.insert(0, os.path.dirname(__file__))

from flask import Flask, send_from_directory, session, redirect, url_for
from models.user import db
from routes.users import users_bp
from routes.auth import auth_bp
from routes.dashboard import dashboard_bp
from routes.users import users_bp
from routes.orders import orders_bp
from routes.settings import settings_bp
app = Flask(__name__, 
            static_folder=os.path.join(os.path.dirname(__file__), 'static'),
            template_folder=os.path.join(os.path.dirname(__file__), 'templates'))
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'asdf#FGSgvasgf$5$WGT')

# Enable database - Using SQLite for Render deployment
database_url = os.environ.get('DATABASE_URL', 'sqlite:///cheaperdata.db')
# Handle potential postgres:// URL format from Render
if database_url.startswith("postgres://"):
    database_url = database_url.replace("postgres://", "postgresql://", 1)

app.config['SQLALCHEMY_DATABASE_URI'] = database_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

# Register blueprints
app.register_blueprint(user_bp, url_prefix='/api/users')
app.register_blueprint(auth_bp, url_prefix='/auth')
app.register_blueprint(dashboard_bp, url_prefix='/dashboard')
app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(orders_bp, url_prefix='/orders')
app.register_blueprint(settings_bp, url_prefix='/settings')

# Create database tables
with app.app_context():
    db.create_all()

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve(path):
    # Check if user is logged in, redirect to login if not
    if 'user_id' not in session and path != 'auth/login':
        return redirect(url_for('auth.login'))
        
    # If path is empty, redirect to dashboard
    if path == '':
        return redirect(url_for('dashboard.index'))
        
    static_folder_path = app.static_folder
    if static_folder_path is None:
            return "Static folder not configured", 404

    if path != "" and os.path.exists(os.path.join(static_folder_path, path)):
        return send_from_directory(static_folder_path, path)
    else:
        index_path = os.path.join(static_folder_path, 'index.html')
        if os.path.exists(index_path):
            return send_from_directory(static_folder_path, 'index.html')
        else:
            return "index.html not found", 404


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)
