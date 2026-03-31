// Route index for static controllers
const homePage = (req, res) => {
  res.render("home", { title: "Welcome Home" });
};

const aboutPage = (req, res) => {
  res.render("about", { title: "About Me" });
};

const demoPage = (req, res) => {
  res.render("demo", { title: "Middleware Demo Page" });
};

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

export { homePage, aboutPage, demoPage, testErrorPage, testUnexpectedError, testNotLoggedInError, testForbiddenError };