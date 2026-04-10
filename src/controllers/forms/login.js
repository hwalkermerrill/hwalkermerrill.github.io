// Imports
import { validationResult } from "express-validator";
import { findUserByUsername, verifyPassword } from "../../models/forms/login.js";

// Controller Functions
const showLoginForm = (req, res) => {
  res.render("forms/login/form", {
    title: "User Login"
  });
};

const processLogin = async (req, res) => {
  // Handle Login form submission
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    // Log validation errors for developer debugging
    errors.array().forEach((error) => {
      req.flash("error", error.msg);
    });
    return res.redirect("/login");
  }

  // Constants
  const { username, password } = req.body;

  try {
    const user = await findUserByUsername(username);
    if (!user) {
      req.flash("error", "Invalid User Name or Password");
      return res.redirect("/login");
    }

    const verified = await verifyPassword(password, user.password_hash);
    if (!verified) {
      req.flash("error", "Invalid User Name or Password");
      return res.redirect("/login");
    }

    // SECURITY: Remove password from user object before storing in session
    delete user.password_hash;
    req.session.user = user;
    req.flash("success", `Welcome, ${user.full_name}!`);
    return res.redirect("/dashboard");

  } catch (error) {
    console.error("Error during login process:", error);
    req.flash("error", "An error occurred during login. Please try again later.");
    return res.redirect("/login");
  }
};

const processLogout = (req, res) => {
  // NOTE: connect.sid is the default session cookie name since we did not specify a custom name
  if (!req.session) {
    // If no session exists, there's nothing to destroy, so we just return
    return res.redirect("/");
  }

  req.session.destroy((err) => {
    // destroy() removes the session from the store (PostgreSQL)
    if (err) {
      console.error("Error destroying session:", err);

      // Clear invalid session cookie 
      res.clearCookie("connect.sid");

      return res.status(500).send("Error logging out");
      // return res.redirect("/");
    }

    res.clearCookie("connect.sid");
    res.redirect("/");
  });
};

const showDashboard = (req, res) => {
  const user = req.session.user;
  const sessionData = req.session;

  // SECURITY: Ensure user and sessionData do not contain password field
  if (user && user.password_hash) {
    console.error("Security error: password found in user object, deleting now...");
    delete user.password_hash;
  }
  if (sessionData.user && sessionData.user.password_hash) {
    console.error("Security error: password found in sessionData.user, deleting now...");
    delete sessionData.user.password_hash;
  }

  res.render("dashboard", {
    title: "User Dashboard",
    user,
    sessionData
  });
};

export { processLogin, processLogout, showLoginForm, showDashboard };