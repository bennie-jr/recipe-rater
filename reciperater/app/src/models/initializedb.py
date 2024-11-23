import requests
from pymongo import MongoClient
import os

# Define the counter

def initialize_database(recipe_counter):
    # Connect to MongoDB
    mongo_uri = os.getenv("MONGO_URI")
    
    client = MongoClient(mongo_uri)
    db = client['FoodDatabase']
    collection = db['recipe']

    # API endpoint and headers
    url = "https://www.themealdb.com/api/json/v1/1/search.php?f=a"
    querystring = {"f": "b"}


    # Fetch data from the API
    response = requests.get(url,params=querystring)
    api_data = response.json()
    print(response.json())
    # Check if data is a dictionary with a 'data' key
    if isinstance(api_data, dict) and 'meals' in api_data:
        recipes_data = api_data['meals']
        # Iterate over each recipe in the array
        for recipe_data in recipes_data:
            # Extract recipe information

            recipe_info = {
                "recipeName": recipe_data.get("strMeal"),
                "category": recipe_data.get("strCategory"),
                "area": recipe_data.get("strArea"),
                "instructions": recipe_data.get("strInstructions"),
                "thumbnail": recipe_data.get("strMealThumb"),
                "ingredients": [
                    recipe_data.get("strIngredient1"),
                    recipe_data.get("strIngredient2"),
                    recipe_data.get("strIngredient3"),
                    recipe_data.get("strIngredient4"),
                    recipe_data.get("strIngredient5"),
                ]
            }
            # Insert recipe data into MongoDB collection
            result = collection.insert_one(recipe_info)
            # Increment the counter
            recipe_counter.inc()
            # Print out the result of the insertion
            print("Inserted document ID:", result.inserted_id)
    else:
        # If response data is not in expected format, print it out for debugging
        print(f"Unexpected response data format: {api_data}")