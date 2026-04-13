// Imports
import { hasPermission, ROLE_RANK } from "../utils/permissions.js";

const requireLogin = (req, res, next) => {
	// Check if user is logged in via session, if not, redirect to login
	if (req.session && req.session.user) {
		res.locals.isLoggedIn = true;
		next();
	} else {
		res.redirect("/login");
	}
};

/**
 * Middleware factory to require specific role for route access
 * Returns middleware that checks if user has the required role
 * 
 * @param {string} roleName - The role name required (e.g., 'admin', 'user')
 * @returns {Function} Express middleware function
 */
const requireRole = (minRole) => {
	return (req, res, next) => {
		const user = req.session.user;

		// Check if user is logged in first
		if (!user) {
			req.flash("error", "You must be logged in to access this page.");
			return res.redirect("/login");
		}

		// Check if user's role matches the required role rank
		if (ROLE_RANK[user.roleName] < ROLE_RANK[minRole]) {
			req.flash("error", "You do not have permission to access this page.");
			return res.redirect("/");
		}

		next();
	};
};

// Check if user has permission to perform requested action
const requirePermission = (permission) => {
	return (req, res, next) => {
		const user = req.session.user;

		if (!user) {
			req.flash("error", "You must be logged in to perform this action.");
			return res.redirect("/login");
		}

		if (!hasPermission(user, permission)) {
			req.flash("error", "You do not have permission to perform this action.");
			return res.redirect("back");
		}

		next();
	};
};

export { requireLogin, requireRole, requirePermission };