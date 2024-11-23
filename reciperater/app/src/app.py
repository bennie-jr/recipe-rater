import os
from flask import Flask, make_response, redirect, request, jsonify, render_template, url_for
from .models.recipemodel import RecipeModel
from prometheus_client import Counter, Histogram, generate_latest, REGISTRY
from flask_jwt_extended import jwt_required, get_jwt_identity, JWTManager, create_access_token, verify_jwt_in_request
from .models.initializedb import initialize_database
import logging

app = Flask(__name__)
app.static_folder = 'static'
recipe_model = RecipeModel()

# Define Prometheus metrics
recipe_counter = Counter('flask_app_recipes_total', 'Total number of recipes')
recipe_search_counter = Counter('flask_app_recipe_search_total', 'Total number of recipe searches')
recipe_update_counter = Counter('flask_app_recipe_update_total', 'Total number of recipe updates')
recipe_delete_counter = Counter('flask_app_recipe_delete_total', 'Total number of recipe deletions')
recipe_add_counter = Counter('flask_app_recipe_add_total', 'Total number of recipe additions')

# Define logging configuration
logging.basicConfig(filename='app.log', level=logging.DEBUG, format='%(asctime)s - %(levelname)s - [recipes] - %(message)s')

jwt_secret = os.getenv("JWTSECRET")
app.config['JWT_SECRET_KEY'] = jwt_secret
jwt = JWTManager(app)

users = {
    'admin': 'admin_password',
    'user1': 'password1',
    'user2': 'password2'
}

@app.route("/initdb", methods=["POST"])
@jwt_required()
def initialize_db():
    current_user = get_jwt_identity()
    if current_user != "admin":
        return jsonify({"message": "Unauthorized"}), 401
    initialize_database(recipe_counter)
    return jsonify({"message": "Database initialized successfully"}), 200

@app.route('/login', methods=['POST','GET'])
def login():
    if request.method == "GET":
        # csrf_token = generate_csrf()
        return render_template("login.html")
    elif request.method == "POST":
        username = request.form.get('username')
        password = request.form.get('password')
        if username in users and users[username] == password:
            # Create JWT token
            access_token = create_access_token(identity=username)
            response = make_response(redirect(url_for('index')))  # Redirect to homepage
            # Set JWT token in response cookies
            response.set_cookie('access_token_cookie', value=access_token)
            return response
        else:
            return jsonify({'message': 'Invalid credentials'}), 401
        
@app.route('/', methods=['GET'])
def index():
    recipe = recipe_model.get_random_recipes()
    return render_template('index.html',recipes = recipe)


@app.route('/recipe/<recipe_id>', methods=['GET'])
def get_recipe_by_id(recipe_id):
    """
    Get a recipe by its ID from the database and render the template with the recipe data.
    """
    recipe = recipe_model.get_recipe_by_id(recipe_id)
    if recipe:
        return render_template('recipe.html', recipe=recipe)
    else:
        return render_template('recipe_not_found.html'), 404
    

@app.route('/recipes', methods=['GET'])
def get_all_recipes():
    """
    Get all recipes from the database.
    """
    recipes = recipe_model.get_all_recipes()
    recipe_counter.inc(len(recipes))
    return jsonify(recipes), 200


# @app.route('/recipes/random', methods=['GET'])
# def get_random_recipes():
#     """
#     Get 10 random recipes from the database.
#     """
#     random_recipes = recipe_model.get_random_recipes()
#     recipe_counter.inc(len(random_recipes))
    # return jsonify(random_recipes), 200

@app.route('/recipes/search', methods=['GET'])
def search_recipes():
    """
    Find recipes matching the given query.
    """
    query = request.args.get('query')
    if not query:
        return jsonify({"message": "Query parameter 'query' is required"}), 400
    
    matching_recipes = recipe_model.find_recipes(query)
    recipe_search_counter.inc()
    return jsonify(matching_recipes), 200


@app.route('/recipes', methods=['POST'])
def add_recipe():
    """
    Add a new recipe to the database.
    """
    recipe_data = request.get_json()
    try:
        result = recipe_model.add_recipe(recipe_data)
        recipe_add_counter.inc()
        return jsonify({"message": "Recipe added successfully", "recipe_id": str(result.inserted_id)}), 201
    except ValueError as e:
        return jsonify({"message": str(e)}), 400

@app.route('/recipes/<recipe_id>', methods=['PUT'])
def update_recipe(recipe_id):
    """
    Update a recipe's information in the database.
    """
    updated_data = request.get_json()
    try:
        result = recipe_model.update_recipe(recipe_id, updated_data)
        if result.modified_count == 1:
            recipe_update_counter.inc()
            return jsonify({"message": "Recipe updated successfully"}), 200
        else:
            return jsonify({"message": "Recipe not found"}), 404
    except ValueError as e:
        return jsonify({"message": str(e)}), 400

@app.route('/recipes/<recipe_id>', methods=['DELETE'])
def delete_recipe(recipe_id):
    """
    Delete a recipe from the database.
    """
    result = recipe_model.delete_recipe(recipe_id)
    if result.deleted_count == 1:
        recipe_delete_counter.inc()
        return jsonify({"message": "Recipe deleted successfully"}), 200
    else:
        return jsonify({"message": "Recipe not found"}), 404

@app.route("/metrics", methods=["GET"])
def get_metrics():
    """
    Get Prometheus metrics.
    """
    return generate_latest(REGISTRY), 200

@app.route("/logs", methods=["GET"])
def get_logs():
    """
    Get application logs.
    """
    try:
        with open('app.log', 'r') as log_file:
            logs = log_file.read()
        return logs
    except Exception as e:
        return str(e)

if __name__ == "__main__":
    app.run(debug=True)