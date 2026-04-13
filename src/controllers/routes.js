// Imports (Core-Middleware-Routes)
import { Router } from "express";
import { requireLogin, requireRole, requirePermission } from "../middleware/auth.js";
import { registrationValidation, loginValidation, updateAccountValidation, contactValidation, resetRequestValidation, resetPasswordValidation } from "../middleware/validation/forms.js";
import { homePage, creationPage, resourcesPage, heroPage, npcPage, rulesPage, testErrorPage, testUnexpectedError, testNotLoggedInError, testForbiddenError } from "./index.js";
import { journalPage } from "./pages/journal.js";
import { mapPage } from "./pages/maps.js";
import { processLogin, processLogout, showLoginForm, showDashboard } from "./forms/login.js";
// import { showContactForm, handleContactSubmission, showContactResponses } from "./forms/contact.js";
import { showRegistrationForm, processRegistration, showAllUsers, showEditAccountForm, processEditAccount, processDeleteAccount } from "./forms/registration.js";
import { showResetForm, requestReset, handleReset } from "./forms/passwordReset.js";
import { listRequests, approveRequest, denyRequest } from "./forms/passwordResetAdmin.js";

// Constants
const router = Router();

// Router-level CSS Middleware
// router.use("/login", (req, res, next) => {
// 	res.addStyle("<link rel=\"stylesheet\" href=\"/css/login.css\">");
// 	next();
// });
// router.use("/register", (req, res, next) => {
// 	res.addStyle("<link rel=\"stylesheet\" href=\"/css/registration.css\">");
// 	next();
// });
// router.use("/catalog", (req, res, next) => {
// 	res.addStyle("<link rel=\"stylesheet\" href=\"/css/catalog.css\">");
// 	next();
// });
// router.use("/faculty", (req, res, next) => {
// 	res.addStyle("<link rel=\"stylesheet\" href=\"/css/faculty.css\">");
// 	next();
// });
// router.use("/contact", (req, res, next) => {
// 	res.addStyle("<link rel=\"stylesheet\" href=\"/css/contact.css\">");
// 	next();
// });

// Router-level JS Middleware
router.use("/journal", (req, res, next) => {
	res.addScript("<script src=\"/js/journal.js\"></script>");
	next();
});
router.use("/maps", (req, res, next) => {
	res.addScript("<script src=\"/js/lightzoom.js\"></script>");
	res.addScript("<script src=\"/js/maps.js\"></script>");
	next();
});


// Routes.get
router.get("/", homePage);
router.get("/resources", resourcesPage);
router.get("/heroes", heroPage);
router.get("/npcs", npcPage);
router.get("/maps", mapPage);
router.get("/journal", journalPage);
router.get("/rules", rulesPage);
router.get("/login", showLoginForm);
router.get("/login/reset-password", showResetForm);
router.get("/logout", processLogout);
router.get("/register", showRegistrationForm);

// Routes.get that requireLogin
// router.get("/contact/responses", requireLogin, showContactResponses);
router.get("/creation", requireLogin, creationPage);
router.get("/rules", requireLogin, rulesPage);
router.get("/dashboard", requireLogin, showDashboard);
router.get("/register/account", requireLogin, showAllUsers);
router.get("/register/:id/edit", requireLogin, showEditAccountForm);
router.get("/register/password-resets", requireLogin, listRequests);

// Development Only Get Routes
if (process.env.NODE_ENV === "development") {
	router.get("/test-error", requirePermission("manage_dev"), testErrorPage);
	router.get("/test-unexpected", requirePermission("manage_dev"), testUnexpectedError);
	router.get("/test-logged", requirePermission("manage_dev"), testNotLoggedInError);
	router.get("/test-forbidden", requirePermission("manage_dev"), testForbiddenError);
}

// Routes.post
// router.post("/contact", contactValidation, handleContactSubmission);
router.post("/login", loginValidation, processLogin);
router.post("/register", registrationValidation, processRegistration);
router.post("/register/reset-password/request", resetRequestValidation, requestReset);
router.post("/register/reset-password", resetPasswordValidation, handleReset);

// Routes.post that requireLogin
router.post("/register/:id/edit", requireLogin, updateAccountValidation, processEditAccount);
router.post("/logout", requireLogin, processLogout);

// Routes.post that requireRole
router.post("/register/:id/delete", requireLogin, requireRole("gm_admin"), processDeleteAccount);
router.post("/register/password-resets/:id/approve", requireLogin, requireRole("gm_admin"), approveRequest);
router.post("/register/password-resets/:id/deny", requireLogin, requireRole("gm_admin"), denyRequest);

export default router;