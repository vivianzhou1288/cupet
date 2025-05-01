from flask import Flask, request
from db import db, User, Pet
import json

app = Flask(__name__)
db_filename = "cupet.db"

app.config["SQLALCHEMY_DATABASE_URI"] = f"sqlite:///{db_filename}"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

db.init_app(app)
with app.app_context():
    db.create_all()

def success_response(body, code=200):
    return json.dumps(body), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# --- User endpoints ---

@app.route("/signup/", methods=["POST"])
def signup():
    body = json.loads(request.data)
    name = body.get("name")
    email = body.get("email")
    password = body.get("password")
    role = body.get("role")

    if not (name and email and password and role):
        return failure_response("Missing required fields", 400)

    if User.query.filter_by(email=email).first():
        return failure_response("Email already registered", 400)

    user = User(name=name, email=email, password=password, role=role)
    db.session.add(user)
    db.session.commit()
    return success_response(user.serialize(), 201)

@app.route("/login/", methods=["POST"])
def login():
    body = json.loads(request.data)
    
    email = body.get("email")
    password = body.get("password")

    if not email or not password:
        return failure_response("Missing email or password", 400)

    user = User.query.filter_by(email=email).first()

    if user is None or not user.check_password(password):
        return failure_response("Invalid email or password", 401)

    return success_response(user.serialize())

@app.route("/users/<int:user_id>/", methods=["GET"])
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found", 404)
    return success_response(user.serialize())

# --- Pet endpoints ---

@app.route("/pets/", methods=["GET"])
def get_all_pets():
    pets = []
    for pet in Pet.query.all():
        pets.append(pet.serialize())
    return success_response({"pet-postings": pets})

@app.route("/pets/<int:pet_id>/", methods=["GET"])
def get_pet(pet_id):
    pet = Pet.query.get(pet_id)
    if not pet:
        return failure_response("Pet not found", 404)
    return success_response(pet.serialize())

@app.route("/pets/", methods=["POST"])
def create_pet():
    body = json.loads(request.data)
    owner_id = body.get("owner_id")
    name = body.get("name")
    pet_type = body.get("pet_type")
    activeness = body.get("activeness")
    description = body.get("description")
    start_date = body.get("start_date")
    end_date = body.get("end_date")
    location = body.get("location")

    if not all([owner_id, name, pet_type, activeness, description, start_date, end_date, location]):
        return failure_response("Missing required fields", 400)
    
    owner = User.query.get(owner_id)
    if not owner or owner.role != "owner":
        return failure_response("Invalid owner", 400)

    pet = Pet(
        owner=owner,
        name=name,
        pet_type=pet_type,
        activeness=activeness,
        description=description,
        start_date=start_date,
        end_date=end_date,
        location=location
    )

    db.session.add(pet)
    db.session.commit()
    return success_response(pet.serialize(), 201)

@app.route("/pets/<int:pet_id>/", methods=["DELETE"])
def delete_pet(pet_id):    
    pet = Pet.query.filter_by(id=pet_id).first()
    if pet is None:
        return failure_response("Pet not found", 404)

    serialized_pet = pet.serialize()

    db.session.delete(pet)
    db.session.commit()
    return success_response(serialized_pet)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)