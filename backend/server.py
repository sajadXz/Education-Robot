#!/usr/bin/env python3
"""
Backend server for Education Robot App
===================================
Handles:
- JWT authentication
- Form data submission
- Database operations with MySQL
"""

import os
import json
import datetime
import uuid
import hashlib
from functools import wraps

from flask import Flask, request, jsonify
from flask_cors import CORS
import jwt
import mysql.connector
from mysql.connector import pooling

# ==================== Configuration ====================
app = Flask(__name__)
CORS(app)

# JWT Secret Key - In production, use environment variable
JWT_SECRET = os.getenv('JWT_SECRET', 'your-super-secret-key-change-in-production')
JWT_ALGORITHM = 'HS256'
JWT_ACCESS_EXPIRY = 3600  # 1 hour
JWT_REFRESH_EXPIRY = 7 * 24 * 3600  # 7 days

# Database Configuration
DB_HOST = os.getenv('DB_HOST', '161.97.103.48')
DB_PORT = int(os.getenv('DB_PORT', 3306))
DB_USER = os.getenv('DB_USER', 'root')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'my_strong_root_password')
DB_NAME = os.getenv('DB_NAME', 'robot_app_db')

# Create connection pool
db_pool = pooling.MySQLConnectionPool(
    pool_name="robot_pool",
    pool_size=5,
    host=DB_HOST,
    port=DB_PORT,
    user=DB_USER,
    password=DB_PASSWORD,
    database=DB_NAME
)


# ==================== Database Helpers ====================
def get_db_connection():
    """Get database connection from pool."""
    try:
        return db_pool.get_connection()
    except mysql.connector.Error:
        # If pool doesn't exist, create direct connection
        return mysql.connector.connect(
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )


def verify_tables():
    """Verify required tables exist (skip creation since already set up)."""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES")
    tables = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    return tables
            host=DB_HOST,
            port=DB_PORT,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME
        )


def init_database():
    """Verify database connection (tables already exist)."""
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("SHOW TABLES")
    tables = [row[0] for row in cursor.fetchall()]
    cursor.close()
    conn.close()
    print(f"Connected to database. Found {len(tables)} tables: {tables}")


# ==================== Password Helpers ====================
def hash_password(password):
    """Hash password using SHA256."""
    return hashlib.sha256(password.encode()).hexdigest()


def verify_password(password, password_hash):
    """Verify password against hash."""
    return hash_password(password) == password_hash


# ==================== JWT Helpers ====================
def create_access_token(user_id, email):
    """Create JWT access token."""
    payload = {
        'user_id': user_id,
        'email': email,
        'type': 'access',
        'exp': datetime.datetime.utcnow() + datetime.timedelta(seconds=JWT_ACCESS_EXPIRY),
        'iat': datetime.datetime.utcnow()
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


def create_refresh_token(user_id):
    """Create JWT refresh token."""
    token = str(uuid.uuid4())
    expires_at = datetime.datetime.utcnow() + datetime.timedelta(seconds=JWT_REFRESH_EXPIRY)

    # Save to database
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (%s, %s, %s)',
        (user_id, token, expires_at)
    )
    conn.commit()
    cursor.close()
    conn.close()

    return token


def verify_token(token, token_type='access'):
    """Verify JWT token and return payload."""
    try:
        if token_type == 'refresh':
            # For refresh tokens, check database
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute(
                'SELECT * FROM refresh_tokens WHERE token = %s AND expires_at > NOW()',
                (token,)
            )
            result = cursor.fetchone()
            cursor.close()
            conn.close()
            if result:
                return {'user_id': result['user_id']}
            return None

        # For access tokens, verify with JWT
        payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.InvalidTokenError:
        return None


def get_user_from_token(token):
    """Get user ID from access token."""
    payload = verify_token(token, 'access')
    if payload:
        return payload.get('user_id')
    return None


# ==================== Auth Decorator ====================
def token_required(f):
    """Decorator to require valid JWT token."""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None

        if 'Authorization' in request.headers:
            auth_header = request.headers['Authorization']
            try:
                token = auth_header.split(' ')[1]
            except IndexError:
                return jsonify({'error': 'Invalid token format'}), 401

        if not token:
            return jsonify({'error': 'Token is missing'}), 401

        user_id = get_user_from_token(token)
        if not user_id:
            return jsonify({'error': 'Invalid or expired token'}), 401

        # Add user_id to request
        request.user_id = user_id
        return f(*args, **kwargs)

    return decorated


# ==================== Routes: Authentication ====================
@app.route('/auth/register', methods=['POST'])
def register():
    """Register new user."""
    data = request.get_json()

    email = data.get('email')
    password = data.get('password')
    name = data.get('name')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400

    # Hash password
    password_hash = hash_password(password)

    # Insert into database
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            'INSERT INTO users (email, password_hash, name) VALUES (%s, %s, %s)',
            (email, password_hash, name)
        )
        conn.commit()
        user_id = cursor.lastrowid
    except mysql.connector.IntegrityError:
        return jsonify({'error': 'Email already exists'}), 400
    finally:
        cursor.close()
        conn.close()

    # Create tokens
    access_token = create_access_token(user_id, email)
    refresh_token = create_refresh_token(user_id)

    return jsonify({
        'user_id': user_id,
        'email': email,
        'access_token': access_token,
        'refresh_token': refresh_token
    }), 201


@app.route('/auth/login', methods=['POST'])
def login():
    """Login user."""
    data = request.get_json()

    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400

    # Find user
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE email = %s', (email,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if not user or not verify_password(password, user['password_hash']):
        return jsonify({'error': 'Invalid email or password'}), 401

    # Create tokens
    access_token = create_access_token(user['id'], email)
    refresh_token = create_refresh_token(user['id'])

    return jsonify({
        'user_id': user['id'],
        'email': email,
        'access_token': access_token,
        'refresh_token': refresh_token
    })


@app.route('/auth/refresh', methods=['POST'])
def refresh():
    """Refresh access token."""
    data = request.get_json()
    refresh_token = data.get('refresh_token')

    if not refresh_token:
        return jsonify({'error': 'Refresh token is required'}), 400

    payload = verify_token(refresh_token, 'refresh')
    if not payload:
        return jsonify({'error': 'Invalid or expired refresh token'}), 401

    user_id = payload['user_id']

    # Get user email
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM users WHERE id = %s', (user_id,))
    user = cursor.fetchone()
    cursor.close()
    conn.close()

    if not user:
        return jsonify({'error': 'User not found'}), 404

    # Create new access token
    access_token = create_access_token(user_id, user['email'])

    return jsonify({
        'user_id': user_id,
        'access_token': access_token
    })


@app.route('/auth/logout', methods=['POST'])
@token_required
def logout():
    """Logout user."""
    # Remove refresh tokens for this user
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM refresh_tokens WHERE user_id = %s', (request.user_id,))
    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Logged out successfully'})


# ==================== Routes: Child Information ====================
@app.route('/api/child-info', methods=['POST'])
@token_required
def create_child_info():
    """Create child information."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO child_info (
            user_id, name, gender, age, birth_date, school_grade,
            wake_time, sleep_time, likes, dislikes, fears, notes
        ) VALUES (
            %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s
        )
    ''', (
        request.user_id,
        data.get('name'),
        data.get('gender'),
        data.get('age'),
        data.get('birth_date'),
        data.get('school_grade'),
        data.get('wake_time'),
        data.get('sleep_time'),
        data.get('likes'),
        data.get('dislikes'),
        data.get('fears'),
        data.get('notes')
    ))

    conn.commit()
    child_id = cursor.lastrowid
    cursor.close()
    conn.close()

    return jsonify({'id': child_id, 'message': 'Child info created'}), 201


@app.route('/api/child-info', methods=['GET'])
@token_required
def get_child_info():
    """Get child information."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM child_info WHERE user_id = %s', (request.user_id,))
    child = cursor.fetchone()
    cursor.close()
    conn.close()

    if not child:
        return jsonify({'error': 'Child info not found'}), 404

    # Convert date/time objects to strings
    if child.get('birth_date'):
        child['birth_date'] = child['birth_date'].isoformat()
    if child.get('wake_time'):
        child['wake_time'] = str(child['wake_time'])
    if child.get('sleep_time'):
        child['sleep_time'] = str(child['sleep_time'])

    return jsonify(child)


@app.route('/api/child-info/<int:child_id>', methods=['PUT'])
@token_required
def update_child_info(child_id):
    """Update child information."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        UPDATE child_info SET
            name = %s, gender = %s, age = %s, birth_date = %s,
            school_grade = %s, wake_time = %s, sleep_time = %s,
            likes = %s, dislikes = %s, fears = %s, notes = %s
        WHERE id = %s AND user_id = %s
    ''', (
        data.get('name'),
        data.get('gender'),
        data.get('age'),
        data.get('birth_date'),
        data.get('school_grade'),
        data.get('wake_time'),
        data.get('sleep_time'),
        data.get('likes'),
        data.get('dislikes'),
        data.get('fears'),
        data.get('notes'),
        child_id,
        request.user_id
    ))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Child info updated'})


# ==================== Routes: Parent Information ====================
@app.route('/api/parent-info', methods=['POST'])
@token_required
def create_parent_info():
    """Create parent information."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO parent_info (user_id, name, phone, relationship, job_title)
        VALUES (%s, %s, %s, %s, %s)
    ''', (
        request.user_id,
        data.get('name'),
        data.get('phone'),
        data.get('relationship'),
        data.get('job_title')
    ))

    conn.commit()
    parent_id = cursor.lastrowid
    cursor.close()
    conn.close()

    return jsonify({'id': parent_id, 'message': 'Parent info created'}), 201


@app.route('/api/parent-info', methods=['GET'])
@token_required
def get_parent_info():
    """Get parent information."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM parent_info WHERE user_id = %s', (request.user_id,))
    parent = cursor.fetchone()
    cursor.close()
    conn.close()

    if not parent:
        return jsonify({'error': 'Parent info not found'}), 404

    return jsonify(parent)


@app.route('/api/parent-info/<int:parent_id>', methods=['PUT'])
@token_required
def update_parent_info(parent_id):
    """Update parent information."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        UPDATE parent_info SET
            name = %s, phone = %s, relationship = %s, job_title = %s
        WHERE id = %s AND user_id = %s
    ''', (
        data.get('name'),
        data.get('phone'),
        data.get('relationship'),
        data.get('job_title'),
        parent_id,
        request.user_id
    ))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Parent info updated'})


# ==================== Routes: Robot Settings ====================
@app.route('/api/robot-settings', methods=['POST'])
@token_required
def create_robot_settings():
    """Create robot settings."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO robot_settings (user_id, robot_name, robot_id, voice_type, sound_enabled, volume)
        VALUES (%s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            robot_name = VALUES(robot_name),
            robot_id = VALUES(robot_id),
            voice_type = VALUES(voice_type),
            sound_enabled = VALUES(sound_enabled),
            volume = VALUES(volume)
    ''', (
        request.user_id,
        data.get('robot_name'),
        data.get('robot_id'),
        data.get('voice_type'),
        data.get('sound_enabled', True),
        data.get('volume', 50)
    ))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Robot settings saved'}), 201


@app.route('/api/robot-settings', methods=['GET'])
@token_required
def get_robot_settings():
    """Get robot settings."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM robot_settings WHERE user_id = %s', (request.user_id,))
    settings = cursor.fetchone()
    cursor.close()
    conn.close()

    if not settings:
        return jsonify({'error': 'Robot settings not found'}), 404

    return jsonify(settings)


# ==================== Routes: Alerts ====================
@app.route('/api/alerts', methods=['POST'])
@token_required
def create_alerts():
    """Create alerts settings."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('''
        INSERT INTO alerts_settings (user_id, sleep_monitoring, activity_alerts, alert_phone)
        VALUES (%s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            sleep_monitoring = VALUES(sleep_monitoring),
            activity_alerts = VALUES(activity_alerts),
            alert_phone = VALUES(alert_phone)
    ''', (
        request.user_id,
        data.get('sleep_monitoring', True),
        data.get('activity_alerts', True),
        data.get('alert_phone')
    ))

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Alerts settings saved'}), 201


@app.route('/api/alerts', methods=['GET'])
@token_required
def get_alerts():
    """Get alerts settings."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM alerts_settings WHERE user_id = %s', (request.user_id,))
    alerts = cursor.fetchone()
    cursor.close()
    conn.close()

    if not alerts:
        return jsonify({'error': 'Alerts settings not found'}), 404

    return jsonify(alerts)


# ==================== Items (Legacy) ====================
@app.route('/items', methods=['GET'])
def get_items():
    """Get items list."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT id, title, description FROM items')
    items = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(items)


@app.route('/items', methods=['POST'])
@token_required
def create_item():
    """Create new item."""
    data = request.get_json()

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        'INSERT INTO items (title, description) VALUES (%s, %s)',
        (data.get('title'), data.get('description'))
    )

    conn.commit()
    cursor.close()
    conn.close()

    return jsonify({'message': 'Item created'}), 201


# ==================== Main ====================
if __name__ == '__main__':
    # Initialize database
    init_database()

    # Run server
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)