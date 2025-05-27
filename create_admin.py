import os
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from flask import Flask
from src.models.user import User, db

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://root:password@localhost:3306/mydb"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    # Check if admin already exists
    admin = User.query.filter_by(username='admin').first()
    
    if admin:
        print("Admin user already exists. Resetting password...")
        admin.set_password('admin123')
    else:
        print("Creating new admin user...")
        admin = User(
            username='admin',
            email='admin@cheaperdata.com',
            is_admin=True
        )
        admin.set_password('admin123')
        db.session.add(admin)
    
    db.session.commit()
    print("Admin user created/updated successfully!")
    print("Username: admin")
    print("Password: admin123")
