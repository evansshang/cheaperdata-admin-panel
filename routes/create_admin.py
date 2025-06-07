from main import app
from models.user import db, User

with app.app_context():
    db.create_all()  # This ensures the table is created

    # Create a test admin user
    admin = User(
        username='admin',
        email='admin@example.com',
        is_admin=True
    )
    admin.set_password('adminpass123')  # You can set any password

    db.session.add(admin)
    db.session.commit()
    print("Test admin user created!")
