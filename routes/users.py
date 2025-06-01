from flask import Blueprint, render_template, request, jsonify, flash, redirect, url_for
from src.models.user import User, db
from src.routes.auth import admin_required

users_bp = Blueprint('users', __name__)

@users_bp.route('/')
@admin_required
def index():
    # Get all users from the database
    users = User.query.all()
    
    # Convert users to a list of dictionaries for the template
    users_list = [user.to_dict() for user in users]
    
    # In a real application, you would fetch actual user activity data
    # For now, we'll use placeholder data
    user_activities = [
        {'user_id': 1, 'username': 'john_doe', 'action': 'Purchased MTN 1GB', 'timestamp': '2025-05-26 14:30:45'},
        {'user_id': 2, 'username': 'jane_smith', 'action': 'Account created', 'timestamp': '2025-05-26 12:15:22'},
        {'user_id': 3, 'username': 'mike_jones', 'action': 'Updated profile', 'timestamp': '2025-05-25 18:45:10'},
        {'user_id': 1, 'username': 'john_doe', 'action': 'Added funds to wallet', 'timestamp': '2025-05-25 16:20:33'},
        {'user_id': 4, 'username': 'sarah_williams', 'action': 'Purchased Orange 2GB', 'timestamp': '2025-05-24 09:12:05'}
    ]
    
    return render_template('users/index.html', users=users_list, activities=user_activities)

@users_bp.route('/view/<int:user_id>')
@admin_required
def view(user_id):
    user = User.query.get_or_404(user_id)
    return render_template('users/view.html', user=user)

@users_bp.route('/create', methods=['GET', 'POST'])
@admin_required
def create():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        is_admin = request.form.get('is_admin') == 'on'
        
        # Check if user already exists
        existing_user = User.query.filter((User.username == username) | (User.email == email)).first()
        if existing_user:
            flash('Username or email already exists', 'error')
            return render_template('users/create.html')
        
        # Create new user
        new_user = User(username=username, email=email, is_admin=is_admin)
        new_user.set_password(password)
        
        db.session.add(new_user)
        db.session.commit()
        
        flash('User created successfully', 'success')
        return redirect(url_for('users.index'))
    
    return render_template('users/create.html')

@users_bp.route('/edit/<int:user_id>', methods=['GET', 'POST'])
@admin_required
def edit(user_id):
    user = User.query.get_or_404(user_id)
    
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        is_admin = request.form.get('is_admin') == 'on'
        
        # Check if username or email already exists for another user
        existing_user = User.query.filter(
            ((User.username == username) | (User.email == email)) & 
            (User.id != user_id)
        ).first()
        
        if existing_user:
            flash('Username or email already exists', 'error')
            return render_template('users/edit.html', user=user)
        
        # Update user
        user.username = username
        user.email = email
        user.is_admin = is_admin
        
        if password:
            user.set_password(password)
        
        db.session.commit()
        
        flash('User updated successfully', 'success')
        return redirect(url_for('users.index'))
    
    return render_template('users/edit.html', user=user)

@users_bp.route('/delete/<int:user_id>', methods=['POST'])
@admin_required
def delete(user_id):
    user = User.query.get_or_404(user_id)
    
    db.session.delete(user)
    db.session.commit()
    
    flash('User deleted successfully', 'success')
    return redirect(url_for('users.index'))

# API endpoints for AJAX calls
@users_bp.route('/api/list')
@admin_required
def api_list():
    users = User.query.all()
    return jsonify([user.to_dict() for user in users])
