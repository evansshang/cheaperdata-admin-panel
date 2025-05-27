from flask import Blueprint, render_template, request, jsonify, flash, redirect, url_for
from src.routes.auth import admin_required

settings_bp = Blueprint('settings', __name__)

@settings_bp.route('/')
@admin_required
def index():
    # In a real application, you would fetch actual settings from the database
    # For now, we'll use placeholder data
    
    # Pricing data
    pricing = [
        {'id': 1, 'provider': 'MTN', 'package': '500MB', 'price': 500, 'duration': '30 days', 'status': 'Active'},
        {'id': 2, 'provider': 'MTN', 'package': '1GB', 'price': 1000, 'duration': '30 days', 'status': 'Active'},
        {'id': 3, 'provider': 'MTN', 'package': '2GB', 'price': 1800, 'duration': '30 days', 'status': 'Active'},
        {'id': 4, 'provider': 'MTN', 'package': '5GB', 'price': 4500, 'duration': '30 days', 'status': 'Active'},
        {'id': 5, 'provider': 'Orange', 'package': '1GB', 'price': 1000, 'duration': '30 days', 'status': 'Active'},
        {'id': 6, 'provider': 'Orange', 'package': '2GB', 'price': 1800, 'duration': '30 days', 'status': 'Active'},
        {'id': 7, 'provider': 'Orange', 'package': '5GB', 'price': 4000, 'duration': '30 days', 'status': 'Active'},
        {'id': 8, 'provider': 'Orange', 'package': '10GB', 'price': 7500, 'duration': '30 days', 'status': 'Active'}
    ]
    
    # Wallet settings
    wallet_settings = {
        'min_deposit': 500,
        'max_deposit': 50000,
        'transaction_fee': 1.5,
        'payment_methods': ['Mobile Money', 'Bank Transfer', 'Credit Card']
    }
    
    # System settings
    system_settings = {
        'maintenance_mode': False,
        'registration_enabled': True,
        'api_rate_limit': 100,
        'notification_email': 'admin@cheaperdata.com'
    }
    
    return render_template('settings/index.html', 
                           pricing=pricing, 
                           wallet_settings=wallet_settings,
                           system_settings=system_settings)

@settings_bp.route('/update-pricing', methods=['POST'])
@admin_required
def update_pricing():
    pricing_id = request.form.get('id')
    price = request.form.get('price')
    status = request.form.get('status')
    
    # In a real application, you would update the pricing in the database
    # For now, we'll just return a success message
    
    flash(f'Pricing updated successfully', 'success')
    return redirect(url_for('settings.index'))

@settings_bp.route('/update-wallet-settings', methods=['POST'])
@admin_required
def update_wallet_settings():
    min_deposit = request.form.get('min_deposit')
    max_deposit = request.form.get('max_deposit')
    transaction_fee = request.form.get('transaction_fee')
    
    # In a real application, you would update the wallet settings in the database
    # For now, we'll just return a success message
    
    flash(f'Wallet settings updated successfully', 'success')
    return redirect(url_for('settings.index'))

@settings_bp.route('/update-system-settings', methods=['POST'])
@admin_required
def update_system_settings():
    maintenance_mode = 'maintenance_mode' in request.form
    registration_enabled = 'registration_enabled' in request.form
    api_rate_limit = request.form.get('api_rate_limit')
    notification_email = request.form.get('notification_email')
    
    # In a real application, you would update the system settings in the database
    # For now, we'll just return a success message
    
    flash(f'System settings updated successfully', 'success')
    return redirect(url_for('settings.index'))
