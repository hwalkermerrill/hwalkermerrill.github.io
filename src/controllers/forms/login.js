// Imports
import { validationResult } from "express-validator";
import { findUserByEmail, verifyPassword } from "../../models/forms/login.js";

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
  const { email, password } = req.body;

  try {
    const user = await findUserByEmail(email);
    if (!user) {
      req.flash("error", "Invalid Email or Password");
      return res.redirect("/login");
    }

    const verified = await verifyPassword(password, user.password);
    if (!verified) {
      req.flash("error", "Invalid Email or Password");
      return res.redirect("/login");
    }

    // SECURITY: Remove password from user object before storing in session
    delete user.password;
    req.session.user = user;
    req.flash("success", `Welcome, ${user.name}!`);
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
  if (user && user.password) {
    console.error("Security error: password found in user object");
    delete user.password;
  }
  if (sessionData.user && sessionData.user.password) {
    console.error("Security error: password found in sessionData.user");
    delete sessionData.user.password;
  }

  res.render("dashboard", {
    title: "User Dashboard",
    user,
    sessionData
  });
};

export { processLogin, processLogout, showLoginForm, showDashboard };