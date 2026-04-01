// Imports (Core-Middleware-Models)
import bcrypt from "bcrypt";
import { validationResult } from "express-validator";
import { usernameExists, saveUser, getAllUsers, getUserById, updateUser, deleteUser } from "../../models/forms/registration.js";

// Controller Functions
const showEditAccountForm = async (req, res) => {
	// Allow editing of existing accounts
	const targetUserId = parseInt(req.params.id);
	const currentUser = req.session.user;

	const targetUser = await getUserById(targetUserId);

	if (!targetUser) {
		req.flash("error", "User not found.");
		return res.redirect("/register/list");
	}

	// Check permissions: users can edit themselves, admins can edit anyone
	const canEdit = currentUser.id === targetUserId || currentUser.roleName === "admin";

	if (!canEdit) {
		req.flash("error", "You do not have permission to edit this account.");
		return res.redirect("/register/list");
	}

	res.render("forms/registration/edit", {
		title: "Edit Account",
		user: targetUser
	});
};

const processEditAccount = async (req, res) => {
	// Process account edit form submission
	const errors = validationResult(req);

	if (!errors.isEmpty()) {
		errors.array().forEach(error => {
			req.flash("error", error.msg);
		});
		return res.redirect(`/register/${req.params.id}/edit`);
	}

	const targetUserId = parseInt(req.params.id);
	const currentUser = req.session.user;
	const { name, username } = req.body;

	try {
		const targetUser = await getUserById(targetUserId);

		if (!targetUser) {
			req.flash("error", "User not found.");
			return res.redirect("/register/list");
		}

		// Check permissions
		const canEdit = currentUser.id === targetUserId || currentUser.roleName === "admin";

		if (!canEdit) {
			req.flash("error", "You do not have permission to edit this account.");
			return res.redirect("/register/list");
		}

		// Check if new username already exists (and belongs to different user)
		const usernameTaken = await usernameExists(username);
		if (usernameTaken && targetUser.username !== username) {
			req.flash("error", "A user with this username already exists.");
			return res.redirect(`/register/${targetUserId}/edit`);
		}

		// Update the user
		await updateUser(targetUserId, name, username);

		// If user edited their own account, update session
		if (currentUser.id === targetUserId) {
			req.session.user.name = name;
			req.session.user.username = username;
		}

		req.flash("success", "Account updated successfully.");
		res.redirect("/register/list");
	} catch (error) {
		console.error("Error updating account:", error);
		req.flash("error", "An error occurred while updating the account.");
		res.redirect(`/register/${targetUserId}/edit`);
	}
};

const processDeleteAccount = async (req, res) => {
	// Only admin's can delete accounts, and they cannot delete themselves
	const targetUserId = parseInt(req.params.id);
	const currentUser = req.session.user;
	// Only admins can delete accounts
	if (currentUser.roleName !== "admin") {
		req.flash("error", "You do not have permission to delete accounts.");
		return res.redirect("/register/list");
	}
	// Prevent admins from deleting their own account
	if (currentUser.id === targetUserId) {
		req.flash("error", "You cannot delete your own account.");
		return res.redirect("/register/list");
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
	res.redirect("/register/list");
};

// Routes
const showRegistrationForm = (req, res) => {
	res.render("forms/registration/form", {
		title: "User Registration"
	});
};

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
	// Initialize users as empty array
	let allUsers = [];

	try {
		allUsers = await getAllUsers();
	} catch (error) {
		console.error("Error retrieving users:", error);
		// return res.render("forms/registration/list", {
		// 	title: "Registered Users",
		// 	users: []
		// });
	}

	return res.render("forms/registration/list", {
		title: "Registered Users",
		users: allUsers,
		user: req.session && req.session.user ? req.session.user : null
	});
};

export { showRegistrationForm, processRegistration, showAllUsers, showEditAccountForm, processEditAccount, processDeleteAccount };