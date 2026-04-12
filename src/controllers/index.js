// Route index for static controllers
const homePage = (req, res) => {
  res.render("home", { title: "Welcome Home" });
};

const creationPage = (req, res) => {
  res.render("creation", { title: "Character Creation - Step by Step Guide" });
};

const resourcesPage = (req, res) => {
  res.render("resources", { title: "Resources, Artifacts, Relics, Magical Items, and Favors" });
};

const heroPage = (req, res) => {
  res.render("heroes", { title: "Player Explorers and Companions" });
}

const npcPage = (req, res) => {
  res.render("npcs", { title: "Notable NPC and Faction Profiles" });
}

// const mapPage = (req, res) => {
//   res.render("maps/maps", { title: "Surveys and Maps" });
// }

// const journalPage = (req, res) => {
//   res.render("journal", { title: "Travel Log and Expedition Journals" });
// }

const rulesPage = (req, res) => {
  res.render("rules", { title: "House Rules, Rulings, Explanations, and Guidelines" });
}

// Development test routes
const testErrorPage = (req, res, next) => {
  const err = new Error("This is a test error");
  err.status = 500;
  next(err);
};

const testUnexpectedError = (req, res, next) => {
  const err = new Error("This is an unexpected test error");
  err.status = 418;
  next(err);
};

const testNotLoggedInError = (req, res, next) => {
  const err = new Error("You are not logged in");
  err.status = 401;
  next(err);
}

const testForbiddenError = (req, res, next) => {
  const err = new Error("You don't have permission to access this page");
  err.status = 403;
  next(err);
}

export { homePage, creationPage, resourcesPage, heroPage, npcPage, rulesPage, testErrorPage, testUnexpectedError, testNotLoggedInError, testForbiddenError };