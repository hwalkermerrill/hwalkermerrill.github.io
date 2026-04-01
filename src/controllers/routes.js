// Imports (Core-Middleware-Routes)
import { Router } from "express";
import { requireLogin } from "../middleware/auth.js";
import { registrationValidation, loginValidation, updateAccountValidation, contactValidation } from "../middleware/validation/forms.js";
// import { catalogPage, courseDetailPage, randomCoursePage } from "./catalog/catalog.js";
// import { facultyListPage, facultyDetailPage } from "./faculty/faculty.js";
import { homePage, creationPage, resourcesPage, heroPage, npcPage, mapPage, journalPage, rulesPage, testErrorPage, testUnexpectedError, testNotLoggedInError, testForbiddenError } from "./index.js";
import { processLogin, processLogout, showLoginForm, showDashboard } from "./forms/login.js";
// import { showContactForm, handleContactSubmission, showContactResponses } from "./forms/contact.js";
import { showRegistrationForm, processRegistration, showAllUsers, showEditAccountForm, processEditAccount, processDeleteAccount } from "./forms/registration.js";

// Constants
const router = Router();

// Router-level CSS Middleware
router.use("/login", (req, res, next) => {
	res.addStyle("<link rel=\"stylesheet\" href=\"/css/login.css\">");
	next();
});
router.use("/register", (req, res, next) => {
	res.addStyle("<link rel=\"stylesheet\" href=\"/css/registration.css\">");
	next();
});
router.use("/catalog", (req, res, next) => {
	res.addStyle("<link rel=\"stylesheet\" href=\"/css/catalog.css\">");
	next();
});
router.use("/faculty", (req, res, next) => {
	res.addStyle("<link rel=\"stylesheet\" href=\"/css/faculty.css\">");
	next();
});
router.use("/contact", (req, res, next) => {
	res.addStyle("<link rel=\"stylesheet\" href=\"/css/contact.css\">");
	next();
});

// Routes.get
router.get("/", homePage);
router.get("/creation", creationPage);
router.get("/resources", resourcesPage);
router.get("/heroes", heroPage);
router.get("/npcs", npcPage);
router.get("/maps", mapPage);
router.get("/journal", journalPage);
router.get("/rules", rulesPage);

// Routes.get that requireLogin
// router.get("/contact/responses", requireLogin, showContactResponses);
router.get("/dashboard", requireLogin, showDashboard);
// router.get("/register/list", requireLogin, showAllUsers);
// router.get("/register/:id/edit", requireLogin, showEditAccountForm);

// Development Only Routes
if (process.env.NODE_ENV === "development") {
	router.get("/test-error", testErrorPage);
	router.get("/test-unexpected", testUnexpectedError);
	router.get("/test-logged", testNotLoggedInError);
	router.get("/test-forbidden", testForbiddenError);
}

// Routes.post
// router.post("/contact", contactValidation, handleContactSubmission);
router.post("/login", loginValidation, processLogin);
router.post("/register", registrationValidation, processRegistration);

// Routes.post that requireLogin
router.post("/register/:id/edit", requireLogin, updateAccountValidation, processEditAccount);
router.post("/register/:id/delete", requireLogin, processDeleteAccount);
router.post("/logout", requireLogin, processLogout);

export default router;