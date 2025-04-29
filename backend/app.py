from db import db
from flask import Flask, request
from db import db, User, Pet
import json

app = Flask(__name__)
db_filename = "cupet.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

# generalized response formats
def success_response(body, code=200):
    """
    Returns a standardized JSON-formatted success response
    """
    return json.dumps(body), code

def failure_response(message, code=404):
    """
    Returns a standardized JSON-formatted error response
    """
    return json.dumps({"error": message}), code

# routes
@app.route("/signup/", methods=["POST"])
def signup():
    """
    Endpoint for to sign up and create a user
    """
    body = json.loads(request.data)
    name = body.get("name")
    email = body.get("email")
    password = body.get("password")
    role = body.get("role")

    if not name or not email or not password or not role:
        return failure_response("Missing required fields", 400)

    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return failure_response("Email already registered", 400)

    user = User(name=name, email=email, password=password, role=role)
    db.session.add(user)
    db.session.commit()
    return success_response(user.serialize(), 201)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)