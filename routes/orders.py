from flask import Blueprint, render_template, request, jsonify, flash, redirect, url_for
from routes.auth import admin_required

orders_bp = Blueprint('orders', __name__)

@orders_bp.route('/')
@admin_required
def index():
    # In a real application, you would fetch actual orders from the database
    # For now, we'll use placeholder data
    orders = [
        {'id': 1, 'user_id': 1, 'username': 'john_doe', 'package': 'MTN 1GB', 'amount': 1000, 'status': 'Completed', 'date': '2025-05-26 14:30:45'},
        {'id': 2, 'user_id': 2, 'username': 'jane_smith', 'package': 'Orange 5GB', 'amount': 4000, 'status': 'Pending', 'date': '2025-05-26 12:15:22'},
        {'id': 3, 'user_id': 3, 'username': 'mike_jones', 'package': 'MTN 500MB', 'amount': 500, 'status': 'Completed', 'date': '2025-05-25 18:45:10'},
        {'id': 4, 'user_id': 4, 'username': 'sarah_williams', 'package': 'Orange 2GB', 'amount': 1800, 'status': 'Completed', 'date': '2025-05-25 16:20:33'},
        {'id': 5, 'user_id': 5, 'username': 'david_brown', 'package': 'MTN 2GB', 'amount': 1800, 'status': 'Failed', 'date': '2025-05-24 09:12:05'},
        {'id': 6, 'user_id': 1, 'username': 'john_doe', 'package': 'Orange 10GB', 'amount': 7500, 'status': 'Pending', 'date': '2025-05-24 08:30:15'},
        {'id': 7, 'user_id': 6, 'username': 'lisa_johnson', 'package': 'MTN 5GB', 'amount': 4500, 'status': 'Completed', 'date': '2025-05-23 17:45:22'},
        {'id': 8, 'user_id': 7, 'username': 'robert_davis', 'package': 'Orange 1GB', 'amount': 1000, 'status': 'Completed', 'date': '2025-05-23 14:10:33'},
        {'id': 9, 'user_id': 8, 'username': 'emily_wilson', 'package': 'MTN 3GB', 'amount': 2500, 'status': 'Failed', 'date': '2025-05-22 11:25:40'},
        {'id': 10, 'user_id': 9, 'username': 'james_taylor', 'package': 'Orange 3GB', 'amount': 2500, 'status': 'Completed', 'date': '2025-05-22 09:05:18'}
    ]
    
    # Get order statistics
    total_orders = len(orders)
    completed_orders = sum(1 for order in orders if order['status'] == 'Completed')
    pending_orders = sum(1 for order in orders if order['status'] == 'Pending')
    failed_orders = sum(1 for order in orders if order['status'] == 'Failed')
    total_revenue = sum(order['amount'] for order in orders if order['status'] == 'Completed')
    
    stats = {
        'total_orders': total_orders,
        'completed_orders': completed_orders,
        'pending_orders': pending_orders,
        'failed_orders': failed_orders,
        'total_revenue': total_revenue
    }
    
    return render_template('orders/index.html', orders=orders, stats=stats)

@orders_bp.route('/view/<int:order_id>')
@admin_required
def view(order_id):
    # In a real application, you would fetch the order from the database
    # For now, we'll use placeholder data
    order = None
    for o in [
        {'id': 1, 'user_id': 1, 'username': 'john_doe', 'package': 'MTN 1GB', 'amount': 1000, 'status': 'Completed', 'date': '2025-05-26 14:30:45', 'phone': '237612345678', 'transaction_id': 'TXN123456789', 'provider': 'MTN', 'data_size': '1GB', 'duration': '30 days'},
        {'id': 2, 'user_id': 2, 'username': 'jane_smith', 'package': 'Orange 5GB', 'amount': 4000, 'status': 'Pending', 'date': '2025-05-26 12:15:22', 'phone': '237698765432', 'transaction_id': 'TXN987654321', 'provider': 'Orange', 'data_size': '5GB', 'duration': '30 days'}
    ]:
        if o['id'] == order_id:
            order = o
            break
    
    if not order:
        flash('Order not found', 'error')
        return redirect(url_for('orders.index'))
    
    return render_template('orders/view.html', order=order)

@orders_bp.route('/update-status/<int:order_id>', methods=['POST'])
@admin_required
def update_status(order_id):
    status = request.form.get('status')
    
    # In a real application, you would update the order status in the database
    # For now, we'll just return a success message
    
    flash(f'Order #{order_id} status updated to {status}', 'success')
    return redirect(url_for('orders.index'))

# API endpoints for AJAX calls
@orders_bp.route('/api/list')
@admin_required
def api_list():
    # In a real application, you would fetch orders from the database
    # For now, we'll use placeholder data
    orders = [
        {'id': 1, 'user_id': 1, 'username': 'john_doe', 'package': 'MTN 1GB', 'amount': 1000, 'status': 'Completed', 'date': '2025-05-26 14:30:45'},
        {'id': 2, 'user_id': 2, 'username': 'jane_smith', 'package': 'Orange 5GB', 'amount': 4000, 'status': 'Pending', 'date': '2025-05-26 12:15:22'}
    ]
    
    return jsonify(orders)
