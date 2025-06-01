from flask import Blueprint, render_template, session, redirect, url_for
from src.routes.auth import admin_required

dashboard_bp = Blueprint('dashboard', __name__)

@dashboard_bp.route('/')
@admin_required
def index():
    # In a real application, you would fetch actual data from the database
    # For now, we'll use placeholder data
    stats = {
        'total_users': 1250,
        'active_users': 875,
        'total_orders': 3420,
        'pending_orders': 42,
        'revenue': 15750.50,
        'growth': 12.5
    }
    
    recent_orders = [
        {'id': 1, 'user': 'john_doe', 'package': 'MTN 1GB', 'amount': 1000, 'status': 'Completed', 'date': '2025-05-26'},
        {'id': 2, 'user': 'jane_smith', 'package': 'Orange 5GB', 'amount': 4000, 'status': 'Pending', 'date': '2025-05-26'},
        {'id': 3, 'user': 'mike_jones', 'package': 'MTN 500MB', 'amount': 500, 'status': 'Completed', 'date': '2025-05-25'},
        {'id': 4, 'user': 'sarah_williams', 'package': 'Orange 2GB', 'amount': 1800, 'status': 'Completed', 'date': '2025-05-25'},
        {'id': 5, 'user': 'david_brown', 'package': 'MTN 2GB', 'amount': 1800, 'status': 'Failed', 'date': '2025-05-24'}
    ]
    
    return render_template('dashboard/index.html', stats=stats, recent_orders=recent_orders, username=session.get('username', 'Admin'))
