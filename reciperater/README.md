# Recipe Rater Flask Application

As part of my portfolio for the RGT DevOps bootcamp, this application, Recipe Rater, was developed to showcase the knowledge acquired. The focus, however, is not on this application but on the "DevOps" principles when making software production-ready. This is a Flask web application designed to manage recipe profiles for various cultural cuisines across the world.

## Features 

    Recipe Management: Add, view, update, and delete recipe profiles.
    Search: Search for recipes by name.
    Favorites: Allow users to mark recipes as favorites and view their favorite recipes.
    Metrics: Provides metrics for the number of recipes, number of favorited recipes, most favorited recipe, and number of users among other system metrics to be fetchde by Prometheus and displayed by Grafana.
    Logs: Logs are accessible through the /logs endpoint.
    Integration with EFK Stack: Logs are formatted to work with the Elasticsearch-Fluentd-Kibana (EFK) stack for centralized logging.

## Setup ⚙️

    Clone the repository:

    bash

git clone git@dhoody.aws.chickenkiller.com:dhoody/reciperater.git

Install dependencies:

```

cd reciperater
pip install -r requirements.txt

```

### Set up environment variables:

Create a .env file in the root directory and add the following variables:

plaintext

MONGO_URI=your_mongodb_connection_uri
JWT_SECRET=your_jwt_secret_key
RAPIDAPI_KEY=your_rapidapi_key

Initialize the database:

```

python initializedb.py

```

### Run the Flask app:

```

    python app.py

```

    Access the app in your web browser at http://localhost:5000.

## API Endpoints

    POST /login: User login and JWT generation.
    POST /initdb: Initialize the database (requires authentication).
    POST /recipe: Add a new recipe.
    GET /recipe: Get all recipes.
    GET /search: Search for recipes by name.
    GET /recipe/{id}: Get a recipe by ID.
    PUT /recipe/{id}: Update a recipe's information.
    DELETE /recipe/{id}: Delete a recipe.
    POST /favorites: Add a recipe to favorites (requires authentication).
    DELETE /favorites/{recipe_id}: Remove a recipe from favorites (requires authentication).
    GET /favorites: Get favorite recipes (requires authentication).
    GET /metrics: Fetch metrics.
    GET /logs: Fetch logs.

```

```
