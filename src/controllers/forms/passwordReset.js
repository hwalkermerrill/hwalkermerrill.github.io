// Imports (Core-Middleware-Models)
import bcrypt from "bcrypt";
import { validationResult } from "express-validator";
import { findUserByNameAndUsername, createResetRequest, findApprovedRequestForUser, completeResetRequest, updateUserPassword }
  from "../../models/forms/passwordReset.js";

// Controller Functions
const showResetForm = (req, res) => {
  res.render("forms/login/resetPassword", {
    title: "Reset Password"
  });
};

// Handle password reset request submissions
const requestReset = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    errors.array().forEach(error => {
      req.flash("error", error.msg);
    });
    return res.redirect("/login");
  }

  const { full_name, username } = req.body;

  try {
    const user = await findUserByNameAndUsername(full_name, username);

    if (!user) {
      // Do not reveal whether the account exists
      req.flash("success", "If this account exists, a password reset request has been submitted.");
      return res.redirect("/login");
    }

    await createResetRequest(user.id);

    req.flash("success", "If this account exists, a password reset request has been submitted.");
    return res.redirect("/login");
  } catch (error) {
    console.error("Error creating password reset request:", error);
    req.flash("error", "An error occurred while processing your request.");
    return res.redirect("/login");
  }
};

// Handle actual password reset using username + reset_code
const handleReset = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    errors.array().forEach(error => {
      req.flash("error", error.msg);
    });
    return res.redirect("/login/reset-password");
  }

  const { username, reset_code, password } = req.body;

  try {
    const request = await findApprovedRequestForUser(username, reset_code);

    if (!request) {
      req.flash("error", "Invalid or expired reset code.");
      return res.redirect("/login/reset-password");
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await updateUserPassword(request.user_id, hashedPassword);
    await completeResetRequest(request.id);

    req.flash("success", "Your password has been updated. You can now log in.");
    return res.redirect("/login");
  } catch (error) {
    console.error("Error completing password reset:", error);
    req.flash("error", "An error occurred while resetting your password.");
    return res.redirect("/login/reset-password");
  }
};

export { showResetForm, requestReset, handleReset };