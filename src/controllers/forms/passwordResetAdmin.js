// Imports (Core-Middleware-Models)
import crypto from "crypto";
import { getAllResetRequestsWithUser, approveResetRequest, denyResetRequest } from "../../models/forms/passwordReset.js";

// Helper Functions - Generate simple reset code
const generateResetCode = () => {
  // 8-character hex code
  return crypto.randomBytes(4).toString("hex").toUpperCase();
};

// Controller Functions
const listRequests = async (req, res) => {
  try {
    const requests = await getAllResetRequestsWithUser();

    res.render("forms/registration/passwordReset", {
      title: "Password Reset Requests",
      requests
    });
  } catch (error) {
    console.error("Error retrieving password reset requests:", error);
    req.flash("error", "An error occurred while loading password reset requests.");
    return res.redirect("/register/account");
  }
};

const approveRequest = async (req, res) => {
  const requestId = parseInt(req.params.id, 10);

  try {
    const resetCode = generateResetCode();
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours
    const updated = await approveResetRequest(requestId, resetCode, expiresAt);

    if (!updated) {
      req.flash("error", "Password reset request not found.");
      return res.redirect("/register/password-resets");
    }

    req.flash("success", `Request approved. Share this reset code with the user: ${resetCode}`);
    return res.redirect("/register/password-resets");
  } catch (error) {
    console.error("Error approving password reset request:", error);
    req.flash("error", "An error occurred while approving the request.");
    return res.redirect("/register/password-resets");
  }
};

const denyRequest = async (req, res) => {
  const requestId = parseInt(req.params.id, 10);

  try {
    const updated = await denyResetRequest(requestId);

    if (!updated) {
      req.flash("error", "Password reset request not found.");
      return res.redirect("/register/password-resets");
    }

    req.flash("success", "Password reset request denied.");
    return res.redirect("/register/password-resets");
  } catch (error) {
    console.error("Error denying password reset request:", error);
    req.flash("error", "An error occurred while denying the request.");
    return res.redirect("/register/password-resets");
  }
};

export { listRequests, approveRequest, denyRequest };