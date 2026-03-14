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
const requireRole = (roleName) => {
	return (req, res, next) => {
		// Check if user is logged in first
		if (!req.session || !req.session.user) {
			req.flash("error", "You must be logged in to access this page.");
			return res.redirect("/login");
		}

		// Check if user's role matches the required role
		if (req.session.user.roleName !== roleName) {
			req.flash("error", "You do not have permission to access this page.");
			return res.redirect("/");
		}

		// User has required role, continue
		next();
	};
};

export { requireLogin, requireRole };