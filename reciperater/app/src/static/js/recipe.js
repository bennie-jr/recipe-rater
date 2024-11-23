document.addEventListener('DOMContentLoaded', function() {
    const recipeId = 'PLACEHOLDER'; // Replace 'PLACEHOLDER' with the actual recipe ID

    fetch(`/recipes/${recipeId}`)
        .then(response => response.json())
        .then(recipe => {
            document.getElementById('recipeName').innerText = recipe.recipeName;
            document.getElementById('recipeCategory').innerText = recipe.category;
            document.getElementById('recipeArea').innerText = recipe.area;
            document.getElementById('recipeInstructions').innerText = recipe.instructions;

            const ingredientList = document.getElementById('ingredientList');
            ingredientList.innerHTML = '';
            recipe.ingredients.forEach(ingredient => {
                const li = document.createElement('li');
                li.innerText = ingredient;
                ingredientList.appendChild(li);
            });

            document.getElementById('recipeImage').src = recipe.thumbnail;
        })
        .catch(error => console.error('Error fetching recipe:', error));
});
