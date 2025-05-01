from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

db = SQLAlchemy()

class User(db.Model):
    """
    User model
    One to many relationship with pets for owners
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    role = db.Column(db.String, nullable=False)

    pets_posting = db.relationship("Pet", cascade="delete", backref="owner")

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name", "").strip()
        self.email = kwargs.get("email", "").lower().strip()
        self.role = kwargs.get("role", "").lower().strip()
        raw_password = kwargs.get("password")
        if raw_password:
            self.set_password(raw_password)

    def serialize(self):
        data = {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "role": self.role
        }
        if self.role == "owner":
            data["pets_posting"] = [pet.serialize(include_owner=False) for pet in self.pets_posting]
        return data

    @classmethod
    def get_user_by_id(cls, user_id):
        return cls.query.get(user_id)

    def create_user(self):
        db.session.add(self)
        db.session.commit()
        return self


class Pet(db.Model):
    """
    Pet model
    Linked to an owner via owner_id
    """
    __tablename__ = "pets"

    id = db.Column(db.Integer, primary_key=True)
    owner_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    name = db.Column(db.String, nullable=False)
    pet_type = db.Column(db.String, nullable=False)
    activeness = db.Column(db.String, nullable=False)
    description = db.Column(db.Text, nullable=False)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    location = db.Column(db.String, nullable=False)
    email_contact = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        owner = kwargs.get("owner")
        if owner:
            self.owner = owner
            self.owner_id = owner.id
            # auto-fill owner's email if not passed
            self.email_contact = owner.email
        else:
            self.owner_id = kwargs.get("owner_id")
            self.email_contact = kwargs.get("email_contact", "").lower().strip()

        self.name = kwargs.get("name", "").strip()
        self.pet_type = kwargs.get("pet_type", "").strip()
        self.activeness = kwargs.get("activeness", "").strip()
        self.description = kwargs.get("description", "").strip()

        start_date_str = kwargs.get("start_date")
        end_date_str = kwargs.get("end_date")
        if start_date_str:
            self.start_date = datetime.strptime(start_date_str, "%Y-%m-%d").date()
        if end_date_str:
            self.end_date = datetime.strptime(end_date_str, "%Y-%m-%d").date()

        self.location = kwargs.get("location", "").strip()

    def serialize(self, include_owner=True):
        data = {
            "id": self.id,
            "name": self.name,
            "pet_type": self.pet_type,
            "activeness": self.activeness,
            "description": self.description,
            "start_date": self.start_date.strftime("%Y-%m-%d") if self.start_date else None,
            "end_date": self.end_date.strftime("%Y-%m-%d") if self.end_date else None,
            "location": self.location,
            "email_contact": self.email_contact
        }
        if include_owner:
            data["owner"] = {
                "id": self.owner.id,
                "name": self.owner.name,
                "email": self.owner.email,
                "role": self.owner.role
            }
        return data

    @classmethod
    def get_get_all_pets(cls):
        return cls.query.all()

    @classmethod
    def get_pets_by_id(cls, pet_id):
        return cls.query.get(pet_id)

    def post_pet(self):
        db.session.add(self)
        db.session.commit()
        return self

    @classmethod
    def del_pet_by_id(cls, pet_id):
        pet = cls.query.get(pet_id)
        if pet:
            db.session.delete(pet)
            db.session.commit()
            return True
        return False