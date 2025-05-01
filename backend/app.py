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
    user.create_user()
    return success_response(user.serialize(), 201)

@app.route("/users/<int:user_id>/", methods=["GET"])
def get_user(user_id):
    user = User.get_user_by_id(user_id)
    if not user:
        return failure_response("User not found", 404)
    return success_response(user.serialize())

# --- Pet endpoints ---

@app.route("/pets/", methods=["GET"])
def get_all_pets():
    pets = Pet.get_get_all_pets()
    return success_response([p.serialize() for p in pets])

@app.route("/pets/<int:pet_id>/", methods=["GET"])
def get_pet(pet_id):
    pet = Pet.get_pets_by_id(pet_id)
    if not pet:
        return failure_response("Pet not found", 404)
    return success_response(pet.serialize())

@app.route("/pets/", methods=["POST"])
def create_pet():
    body = json.loads(request.data)
    required = ("owner_id", "name", "pet_type", "activeness",
                "description", "start_date", "end_date", "location")
    if not all(body.get(k) for k in required):
        return failure_response("Missing required fields", 400)

    owner = User.get_user_by_id(body["owner_id"])
    if not owner or owner.role != "owner":
        return failure_response("Invalid owner", 400)

    pet = Pet(
        owner=owner,
        name=body["name"],
        pet_type=body["pet_type"],
        activeness=body["activeness"],
        description=body["description"],
        start_date=body["start_date"],
        end_date=body["end_date"],
        location=body["location"]
    )
    pet.post_pet()
    return success_response(pet.serialize(), 201)

@app.route("/pets/<int:pet_id>/", methods=["DELETE"])
def delete_pet(pet_id):
    if not Pet.del_pet_by_id(pet_id):
        return failure_response("Pet not found", 404)
    return success_response({"message": "Pet deleted"}, 200)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)