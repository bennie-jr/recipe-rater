from flask_pymongo import PyMongo

mongo = PyMongo()

def initialize_db(app):
    print(app)
    mongo.init_app(app)
