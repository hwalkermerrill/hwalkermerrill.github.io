//Error Handling Middleware
const NODE_ENV = process.env.NODE_ENV?.toLowerCase() || "production";

const error404Router = (req, res, next) => {
  // Catch-all route for 404 errors
  const err = new Error("Page Not Found");
  err.status = 404;
  next(err);
};

// Global error handler
const globalErrorHandler = (err, req, res, next) => {
  // Self-heal missing locals so the 500 page can fail gracefully
  if (!res.locals.renderStyles) {
    res.locals.styles = [];
    res.locals.renderStyles = () => "";
  }
  if (!res.locals.renderScripts) {
    res.locals.scripts = [];
    res.locals.renderScripts = () => "";
  }
  if (!res.locals.title) {
    res.locals.title = "Server Error";
  }

  // Prevent infinite loops, if a response has already been sent, do nothing
  if (res.headersSent || res.finished) {
    return next(err);
  }

  const status = err.status || 500;
  let template = status === 404 ? "404" :
    status === 401 ? "401" :
      status === 403 ? "403" :
        status === 500 ? "500" :
          "error";

  // Prepare data for the template
  const context = {
    title: status === 404 ? "Page Not Found" :
      status === 401 ? "You Are Not Logged In. Please Log In to Access this Page" :
        status === 403 ? "You Don't Have the Keys to Access this Page" :
          status === 500 ? "Server Error" :
            "Unexpected Error",
    error: NODE_ENV === "production" ? "An error occurred" : err.message,
    stack: NODE_ENV === "production" ? null : err.stack,
    NODE_ENV,
    activePage: null
  };

  // Render the appropriate error template with fallback
  try {
    res.status(status).render(`errors/${template}`, context);
  } catch (renderErr) { // eslint-disable-line no-unused-vars
    if (!res.headersSent) {
      res.status(status).send(`<h1>Error ${status}</h1><p>An error occurred.</p>`);
    }
  }
};

export { error404Router, globalErrorHandler };