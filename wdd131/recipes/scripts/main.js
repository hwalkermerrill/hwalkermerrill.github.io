// Import recipes asynchronously with dynamic import
document.addEventListener('DOMContentLoaded', () => {
  (async () => {
    // Import the default export from recipes.mjs
    const recipes = (await import('./recipes.mjs')).default;
    // console.log(recipes);
    // populateRecipes(recipes); THIS CALLS ALL RECIPES
    initialRandomRecipe(recipes);
  })();
});

function randNum(number) {
  return Math.floor(Math.random() * number);
}

// Isolate recipe HTML generation into a separate function
function recipeTemplate(recipe) {
  return `
    <div class="recipe-main">
      <div class="recipe-image">
        <img src="${recipe.image}" alt="${recipe.name}">
      </div>
      <div class="recipe-info">
        <p class="recipe-tags">
          ${recipe.tags.map(tag => `<span class="tag">${tag}</span>`).join(' ')}
        </p>
        <h2>${recipe.name}</h2>
        <p class="recipe-rating">
          Rating: ${generateRatingHTML(recipe.rating)}
        </p>
        <p class="recipe-description">${recipe.description}</p>
      </div>
    </div>
    <!-- Initially hidden details that will be toggled on click -->
    <div class="recipe-details" style="display: none;">
      <!-- Top Line: Times and Yield -->
      <div class="details-top">
        ${recipe.prepTime ? `<span class="prep-time">Prep Time: ${recipe.prepTime},</span>` : ''}
        ${recipe.cookTime ? `<span class="cook-time">Cook Time: ${recipe.cookTime}</span>` : ''}
        ${recipe.recipeYield ? `<span class="yield"> (Yield: ${recipe.recipeYield})</span>` : ''}
      </div>

      <!-- Middle Section: Ingredients and Instructions -->
      <div class="ingredients-section">
        ${recipe.recipeIngredient && recipe.recipeIngredient.length > 0
      ? `<p>Ingredients:</p><ul>${recipe.recipeIngredient.map(item => `<li>${item}</li>`).join('')}</ul>`
      : ''}
        ${recipe.recipeInstructions && recipe.recipeInstructions.length > 0
      ? `<p>Instructions:</p><ol>${recipe.recipeInstructions.map(step => `<li>${step}</li>`).join('')}</ol>`
      : ''}
      </div>

      <!-- Bottom Line: Based On, Author, Published Date & URL -->
      <div class="details-bottom">
        ${recipe.isBasedOn ? `<span class="isBasedOn">Based on: ${recipe.isBasedOn},</span>` : ''}
        ${recipe.author ? `<span class="author">Author: ${recipe.author},</span>` : ''}
        ${recipe.datePublished ? `<span class="datePublished">Published on: ${recipe.datePublished}</span>` : ''}
        ${recipe.url ? `<span class="url"><a href="${recipe.url}" target="_blank">View Recipe</a></span>` : ''}
      </div>
    </div>
  `;
}

// Function to populate recipes on the page
function populateRecipes(recipeList) {
  // Sort recipes alphabetically by name:
  const sortedRecipes = recipeList.sort((a, b) => a.name.localeCompare(b.name));
  const container = document.getElementById('recipe');

  // Clear any previous content (in case of re-rendering)
  container.innerHTML = '';

  sortedRecipes.forEach(recipe => {
    const card = document.createElement('div');
    card.classList.add('recipe-card');

    // Set the inner HTML of the card to the recipe template using separated function
    card.innerHTML = recipeTemplate(recipe);

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

function generateRatingHTML(rating) {
  // These constants handle .5 star ratings
  const fullStars = Math.floor(rating);
  const hasHalfStar = (rating - fullStars) >= 0.5 ? 1 : 0;
  const emptyStars = 5 - fullStars - hasHalfStar;

  let starsHTML = '';

  // Loop for filled stars (using icon-star)
  for (let i = 0; i < fullStars; i++) {
    starsHTML += `<span aria-hidden="true" class="icon-star">⭐</span>`;
  }

  // Loop checks if a half star needs to b e awarded
  if (hasHalfStar) {
    starsHTML += `<span aria-hidden="true" class="icon-star-half">⯨</span>`;
  }

  // Loop for empty stars (using icon-star-empty)
  for (let i = rating; i < emptyStars; i++) {
    starsHTML += `<span aria-hidden="true" class="icon-star-empty">☆</span>`;
  }

  // Wrap the stars in the outer span with aria-label for accessibility
  return `<span class="rating" role="img" aria-label="Rating: ${rating} out of 5 stars">${starsHTML}</span>`;
}

function initialRandomRecipe(recipes) {
  const randomIndex = randNum(recipes.length);
  const randomRecipe = recipes[randomIndex];
  populateRecipes([randomRecipe]);
}