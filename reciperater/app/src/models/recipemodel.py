from datetime import datetime
import os
import random
from bson import ObjectId, json_util
from pymongo import MongoClient
from ..config.dbconnect import mongo
from bson.errors import InvalidId

mongo_uri = os.getenv("MONGO_URI")
class RecipeModel:
    def __init__(self):
        self.mongo = mongo
        client = MongoClient(mongo_uri)
        self.db = client['FoodDatabase']
        self.collection = self.db['recipe']
    
    def count_recipes(self):
        """
        Count the number of recipes in the database.
        """
        return self.collection.count_documents({})
        
    def add_recipe(self, recipe_data):
        """
        Add a new recipe to the database.
        """
        # Validate recipe data
        if not self._is_valid_recipe_data(recipe_data):
            raise ValueError("Invalid recipe data provided")
        
        # Add timestamp
        recipe_data["created_at"] = datetime.utcnow()
        
        # Insert recipe data into the collection
        return self.collection.insert_one(recipe_data)
    
    def _is_valid_recipe_data(self, recipe_data):
        """
        Validate recipe data.
        """
        # Perform data validation checks here
        # For example, check if required fields are present and have correct types
        
        required_fields = ["recipeName", "category", "area", "instructions", "thumbnail"]
        for field in required_fields:
            if field not in recipe_data:
                return False
        
        if not isinstance(recipe_data["recipeName"], str):
            return False
        
        if not isinstance(recipe_data["category"], str):
            return False
        
        # Add more validation checks as needed
        
        return True
    
    def get_all_recipes(self):
        """
        Get all recipes from the database.
        """
        print(self.mongo.db)
        recipes = self.collection.find()
        # Convert ObjectId to string for each recipe
        recipe_list = [{**recipe, "_id": str(recipe["_id"])} for recipe in recipes]
        # Return the list of recipes
        return recipe_list
    
    def get_random_recipes(self):
        """
        Get 10 random recipes from the database.
        """
        recipes = list(self.collection.find())
        # Shuffle the recipes list
        random.shuffle(recipes)
        # Get the first 10 recipes from the shuffled list
        random_recipes = recipes[:10]
        # Convert ObjectId to string for each recipe
        recipe_list = [{**recipe, "_id": str(recipe["_id"])} for recipe in random_recipes]
        # Return the list of random recipes
        return recipe_list
    
    def find_recipes(self, query):
        """
        Find recipes matching the given query.
        """
        recipes = self.collection.find({"recipeName": {"$regex": query, "$options": "i"}})
        # Convert ObjectId to string for each recipe
        recipe_list = [{**recipe, "_id": str(recipe["_id"])} for recipe in recipes]
        # Return the list of recipes
        return recipe_list
    
    def get_recipe_by_id(self, recipe_id):
        """
        Get a recipe by its ID from the database.
        """
        try:
            recipe = self.collection.find_one({"_id": ObjectId(recipe_id)})
            if recipe:
                # Convert ObjectId to string
                recipe["_id"] = str(recipe["_id"])
            return recipe
        except InvalidId:
            return None

    def update_recipe(self, recipe_id, updated_data):
        """
        Update a recipe's information in the database.
        """
        # You may want to perform validation on updated_data before updating
        
        # Update timestamp
        updated_data["updated_at"] = datetime.utcnow()
        
        # Perform update operation
        return self.collection.update_one({"_id": ObjectId(recipe_id)}, {"$set": updated_data})
    
    def delete_recipe(self, recipe_id):
        """
        Delete a recipe from the database.
        """
        return self.collection.delete_one({"_id": ObjectId(recipe_id)})
