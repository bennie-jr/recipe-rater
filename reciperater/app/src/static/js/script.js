function fetchRecipes() {
    fetch('/recipes')
        .then(response => response.json())
        .then(recipes => {
            const recipeContainer = document.getElementById('recipeContainer');
            recipeContainer.innerHTML = ''; // Clear previous recipes

            recipes.forEach(recipe => {
                // Code to display random recipes (if needed)
            });
        })
        .catch(error => console.error('Error fetching recipes:', error));
}

// Fetch recipes when the page loads
fetchRecipes();

// Search functionality
const searchInput = document.getElementById('searchInput');
searchInput.addEventListener('input', function() {
    const query = searchInput.value.trim().toLowerCase();

    if (query.length === 0) {
        // If search input is empty, fetch all recipes
        fetchRecipes();
    } else {
        // Otherwise, fetch recipes matching the search query
        fetch(`/recipes/search?query=${query}`)
            .then(response => response.json())
            .then(recipes => {
                const searchResultsContainer = document.getElementById('searchResults');
                searchResultsContainer.innerHTML = ''; // Clear previous search results

                recipes.forEach(recipe => {
                    const recipeItem = document.createElement('a');
                    recipeItem.href = '/recipes/' + recipe._id;
                    recipeItem.classList.add('player-item');

                    const name = document.createElement('h3');
                    name.innerText = recipe.recipeName;

                    const category = document.createElement('p');
                    category.innerText = 'Category: ' + recipe.category;

                    const area = document.createElement('p');
                    area.innerText = 'Country of Origin: ' + recipe.area;

                    recipeItem.appendChild(name);
                    recipeItem.appendChild(category);
                    recipeItem.appendChild(area);

                    searchResultsContainer.appendChild(recipeItem);
                });
            })
            .catch(error => console.error('Error searching recipes:', error));
    }
});
