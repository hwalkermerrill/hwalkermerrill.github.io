// Import recipes asynchronously with dynamic import
document.addEventListener('DOMContentLoaded', () => {
  (async () => {
    // Import the default export from recipes.mjs
    const recipes = (await import('./recipes.mjs')).default;
    console.log(recipes);
    populateRecipes(recipes);
  })();
});

// Function to populate recipes on the page
function populateRecipes(recipes) {
  // Sort recipes alphabetically by name:
  const sortedRecipes = recipes.sort((a, b) => a.name.localeCompare(b.name));

  // Get the container element in your HTML where recipe cards will be placed.
  // Make sure you have an element with id="recipesContainer" in your markup.
  const container = document.getElementById('recipe');

  // Iterate over each recipe entry
  sortedRecipes.forEach(recipe => {
    // Create a card to hold the recipe
    const card = document.createElement('div');
    card.classList.add('recipe-card');

    // Construct the card’s inner HTML:
    card.innerHTML = `
      <div class="recipe-main">
        <div class="recipe-image">
          <img src="${recipe.image}" alt="${recipe.name}">
        </div>
        <div class="recipe-info">
          <p class="recipe-tags">
            ${recipe.tags.map(tag => `<span class="tag">${tag}</span>`).join(' ')}
          </p>
          <h2>${recipe.name}</h2>
          <p class="recipe-rating">Rating: ${recipe.rating}</p>
          <p class="recipe-description">${recipe.description}</p>
        </div>
      </div>
      <!-- Initially hidden details that will be toggled on click -->
      <div class="recipe-details" style="display: none;">
        ${recipe.author ? `<p>Author: ${recipe.author}</p>` : ''}
        ${recipe.cookTime ? `<p>Cook Time: ${recipe.cookTime}</p>` : ''}
        ${recipe.prepTime ? `<p>Prep Time: ${recipe.prepTime}</p>` : ''}
        ${recipe.recipeYield ? `<p>Yield: ${recipe.recipeYield}</p>` : ''}
        ${recipe.datePublished ? `<p>Published on: ${recipe.datePublished}</p>` : ''}
        ${recipe.recipeIngredient && recipe.recipeIngredient.length > 0
        ? `<p>Ingredients:</p><ul>${recipe.recipeIngredient.map(item => `<li>${item}</li>`).join('')}</ul>`
        : ''}
        ${recipe.recipeInstructions && recipe.recipeInstructions.length > 0
        ? `<p>Instructions:</p><ol>${recipe.recipeInstructions.map(step => `<li>${step}</li>`).join('')}</ol>`
        : ''}
      </div>
    `;

    // When the recipe card is clicked, toggle the visibility of the additional details.
    card.addEventListener('click', () => {
      const details = card.querySelector('.recipe-details');
      // Toggle display between none and block
      details.style.display = details.style.display === 'none' ? 'block' : 'none';
    });

    // Append the recipe card to the container
    container.appendChild(card);
  });
}
