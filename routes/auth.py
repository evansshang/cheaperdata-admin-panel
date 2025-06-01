from flask import Blueprint, request, jsonify, session, redirect, url_for, render_template, flash
from models.user import User, db
from functools import wraps

auth_bp = Blueprint('auth', __name__)

# Authentication decorator
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please log in to access this page', 'error')
            return redirect(url_for('auth.login'))
        
        user = User.query.get(session['user_id'])
        if not user or not user.is_admin:
            flash('You do not have permission to access this page', 'error')
            return redirect(url_for('auth.login'))
            
        return f(*args, **kwargs)
    return decorated_function

@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        
        user = User.query.filter_by(username=username).first()
        
        if user and user.check_password(password) and user.is_admin:
            session['user_id'] = user.id
            session['username'] = user.username
            session['is_admin'] = user.is_admin
            flash('Login successful', 'success')
            return redirect(url_for('dashboard.index'))
        else:
            flash('Invalid username or password', 'error')
    
    return render_template('auth/login.html')

@auth_bp.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out', 'info')
    return redirect(url_for('auth.login'))

# API endpoint for authentication (for AJAX calls)
@auth_bp.route('/api/login', methods=['POST'])
def api_login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')
    
    user = User.query.filter_by(username=username).first()
    
    if user and user.check_password(password) and user.is_admin:
        session['user_id'] = user.id
        session['username'] = user.username
        session['is_admin'] = user.is_admin
        return jsonify({'success': True, 'message': 'Login successful'})
    else:
        return jsonify({'success': False, 'message': 'Invalid username or password'}), 401

# Initialize admin user
@auth_bp.route('/init-admin', methods=['GET'])
def init_admin():
    # Check if admin already exists
    admin = User.query.filter_by(is_admin=True).first()
    if admin:
        return jsonify({'message': 'Admin already exists'})
    
    # Create admin user
    admin = User(
        username='admin',
        email='admin@cheaperdata.com',
        is_admin=True
    )
    admin.set_password('admin123')
    
    db.session.add(admin)
    db.session.commit()
    
    return jsonify({'message': 'Admin user created successfully', 'username': 'admin', 'password': 'admin123'})
