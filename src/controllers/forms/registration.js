// Imports (Core-Middleware-Helpers- Models)
import bcrypt from "bcrypt";
import { validationResult } from "express-validator";
import { hasPermission } from "../../utils/permissions.js";
import { usernameExists, saveUser, getAllUsers, getUserById, updateUser, deleteUser } from "../../models/forms/registration.js";

// CONTROLLER FUNCTIONS
// Handle user registration with validation and password hashing.
const processRegistration = async (req, res) => {
	// Check for validation errors
	const errors = validationResult(req);

	if (!errors.isEmpty()) {
		// Flash validation errors
		errors.array().forEach((error) => {
			req.flash("error", error.msg);
		});
		return res.redirect("/register");
	}

	// Extract validated data from request body
	const { name, username, password } = req.body;

	try {
		if (await usernameExists(username)) {
			// Check if username already exists in database
			req.flash("warning", `Username ${username} already exists`);
			return res.redirect("/register");
		}

		// SECURITY NOTE: Hash the password before saving to database
		const hashedPassword = await bcrypt.hash(password, 10);
		await saveUser(name, username, hashedPassword);
		req.flash("success", `Successfully registered user: ${name} (${username})`);
		return res.redirect("/login");

	} catch (error) {
		console.error("Failed to register user:", error);
		req.flash("error", "An error occurred while registering the user");
		// Redirect back to form without saving
		return res.redirect("/register");
	}
};

// Display all registered users.
const showAllUsers = async (req, res) => {
	// Initialize allUsers as empty array at top
	let allUsers = [];

	try {
		allUsers = await getAllUsers();
	} catch (error) {
		console.error("Error retrieving users:", error);
		req.flash("error", "An error occurred while retrieving users.");
	}

	return res.render("forms/registration/list", {
		title: "Account Management",
		activePage: "register",
		users: allUsers
	});
};

// Start account edit block
const showEditAccountForm = async (req, res) => {
	// Allow editing of existing accounts
	const targetUserId = parseInt(req.params.id);
	const targetUser = await getUserById(targetUserId);
	const currentUser = req.session.user;

	// Permission checks
	if (!targetUser) {
		req.flash("error", "User not found.");
		return res.redirect("/register/account");
	}

	const isSelf = currentUser.id === targetUserId;

	if (!isSelf && !hasPermission(currentUser, "edit_users")) {
		req.flash("error", "You do not have permission to edit this account.");
		return res.redirect("/register/account");
	}

	res.render("forms/registration/edit", {
		title: "Edit Account",
		activePage: "register",
		targetUser
	});
};

const processEditAccount = async (req, res) => {
	// Process account edit form submission
	const errors = validationResult(req);
	const targetUserId = parseInt(req.params.id);
	const currentUser = req.session.user;

	if (!errors.isEmpty()) {
		errors.array().forEach(error => {
			req.flash("error", error.msg);
		});
		return res.redirect(`/register/${targetUserId}/edit`);
	}

	// Permission checks
	try {
		const targetUser = await getUserById(targetUserId);

		if (!targetUser) {
			req.flash("error", "User not found.");
			return res.redirect("/register/account");
		}

		const isSelf = currentUser.id === targetUserId;

		if (!isSelf && !hasPermission(currentUser, "edit_users")) {
			req.flash("error", "You do not have permission to edit this account.");
			return res.redirect("/register/account");
		}

		// Check if new username already exists (and belongs to different user)	
		const { name, username } = req.body;
		const usernameTaken = await usernameExists(username);
		if (usernameTaken && targetUser.username !== username) {
			req.flash("error", "A user with this username already exists.");
			return res.redirect(`/register/${targetUserId}/edit`);
		}

		// Update the user
		await updateUser(targetUserId, name, username);

		// If user edited their own account, update session
		if (isSelf) {
			req.session.user.name = name;
			req.session.user.username = username;
		}

		req.flash("success", "Account updated successfully.");
		return res.redirect("/register/account");

	} catch (error) {
		console.error("Error updating account:", error);
		req.flash("error", "An error occurred while updating the account.");
		return res.redirect(`/register/${targetUserId}/edit`);
	}
};

const processDeleteAccount = async (req, res) => {
	// Only admin's can delete accounts, and they cannot delete themselves
	const targetUserId = parseInt(req.params.id);
	const currentUser = req.session.user;

	// Permission checks
	if (!hasPermission(currentUser, "delete_users")) {
		req.flash("error", "You do not have permission to delete accounts.");
		return res.redirect("/register/account");
	}
	if (currentUser.id === targetUserId) {
		req.flash("error", "You cannot delete your own account.");
		return res.redirect("/register/account");
	}

	try {
		const deleted = await deleteUser(targetUserId);
		if (deleted) {
			req.flash("success", "User account deleted successfully.");
		} else {
			req.flash("error", "User not found or already deleted.");
		}
	} catch (error) {
		console.error("Error deleting user:", error);
		req.flash("error", "An error occurred while deleting the account.");
	}

	return res.redirect("/register/account");
};
// End account edit block

// Routes
const showRegistrationForm = (req, res) => {
	res.render("forms/registration/form", {
		title: "User Registration",
		activePage: "register",
		isLoggedIn: res.locals.isLoggedIn,
		user: req.session.user
	});
};

export { showRegistrationForm, processRegistration, showAllUsers, showEditAccountForm, processEditAccount, processDeleteAccount };