// --- Imports ---
import {
	getPCs, getCompanions,
	createPcMain,
	updatePcMain,
	deletePcMain,
	replacePcSocial, replacePcAttributes, replacePcStats, replacePcSkills, replacePcClasses, replacePcLanguages, replacePcReligion, replacePcTitles, replacePcAchievements, replacePcScars, replacePcGallery
} from "../../models/pages/characters.js";
import { getActiveStatus, getRaces, getClasses, getReligions, getLanguages, getSpeeds, getTitles, getAchievements } from "../../models/pages/select.js";
import { sanitizeText, validateImgUrl } from "../../utils/validation.js";
import { normalizeToArray } from "../../utils/normalization.js";
import { hasRole } from "../../utils/permissions.js";

// --- Helper Functions ---
/**
 * Check if the current user can edit a given PC.
 * - Owner can edit their own PCs.
 * - gm_admin can edit all PCs.
 */
const canEditPc = (user, pc) => {
	if (!user) return false;
	if (hasRole(user, "gm_admin")) return true;
	return pc.user_id && pc.user_id === user.id;
};

/**
 * Load shared dropdown data for PC builder forms.
 * Used by both /new and /:id/edit routes.
 */
const loadPcDropdowns = async () => {
	const [
		activeStatus,
		races,
		classes,
		religions,
		languages,
		speeds,
		titles,
		achievements
	] = await Promise.all([
		getActiveStatus(),
		getRaces(),
		getClasses(),
		getReligions(),
		getLanguages(),
		getSpeeds(),
		getTitles(),
		getAchievements()
	]);

	return {
		activeStatus,
		races,
		classes,
		religions,
		languages,
		speeds,
		titles,
		achievements
	};
};

// --- Controller Functions ---

/**
 * PC + Companion Builder Dashboard
 * Route: GET /builder/pc
 *
 * - Shows user's PCs and companions.
 * - GM/Admin sees all PCs/companions for the campaign.
 * - Provides entry points to /builder/pc/new and /builder/pc/:id/edit.
 */
const pcBuilderDashboard = async (req, res) => {
	const user = req.session.user;
	const campaignId = res.locals.campaign_id;

	try {
		// TODO: Implement getPCs/getCompanions filters:
		// - If gm_admin: load all PCs/companions for campaign.
		// - Else: load PCs/companions owned by user (optionally filtered by campaign).
		const pcs = await getPCs(campaignId, user);
		const companions = await getCompanions(campaignId, user);

		const dropdowns = await loadPcDropdowns();

		res.render("builder/pc/dashboard", {
			title: "PC & Companion Builder",
			pcs,
			companions,
			dropdowns
		});
	} catch (error) {
		console.error("Error loading PC builder dashboard:", error);
		req.flash("error", "Failed to load PC builder dashboard.");
		res.redirect("/home");
	}
};

/**
 * New PC Form
 * Route: GET /builder/pc/new
 *
 * - Shows the initial PC creation form (Identity & Basics).
 */
const pcNewForm = async (req, res) => {
	const user = req.session.user;
	const campaignId = res.locals.campaign_id;

	if (!user) {
		req.flash("error", "You must be logged in to create a PC.");
		return res.redirect("/login");
	}

	try {
		const dropdowns = await loadPcDropdowns();

		res.render("builder/pc/new", {
			title: "Create New PC",
			campaignId,
			dropdowns
		});
	} catch (error) {
		console.error("Error loading new PC form:", error);
		req.flash("error", "Failed to load PC creation form.");
		res.redirect("/builder/pc");
	}
};

/**
 * Handle New PC Submission
 * Route: POST /builder/pc/new
 *
 * - Validates Identity & Basics.
 * - Creates pc_main row.
 * - Redirects to /builder/pc/:id/edit for further sections.
 */
const submitNewPc = async (req, res) => {
	const user = req.session.user;
	const campaignId = res.locals.campaign_id;

	if (!user) {
		req.flash("error", "You must be logged in to create a PC.");
		return res.redirect("/login");
	}

	// Extract basic fields from the form
	const {
		pc_name,
		race_id,
		is_gendered,
		is_female,
		description,
		race_traits,
		secret_name,
		show_secret_name,
		secret_color
	} = req.body;

	// TODO: Add validation similar to Asset Builder:
	// - Required fields (pc_name, race_id).
	// - Sanitize text fields.
	// - Handle boolean flags.

	try {
		// Start transaction
		// await db.query("BEGIN");

		// const pcData = {
		// 	user_id: user.id,
		// 	campaign_id: campaignId,
		// 	pc_name,
		// 	race_id,
		// 	is_gendered: is_gendered === "true",
		// 	is_female: is_female === "true",
		// 	description: sanitizeText(description),
		// 	race_traits: sanitizeText(race_traits),
		// 	secret_name: sanitizeText(secret_name),
		// 	show_secret_name: show_secret_name === "true",
		// 	secret_color
		// };

		const pc = await createPcMain(pcData);

		// await db.query("COMMIT");

		req.flash("success", "PC created successfully. Continue filling out the details.");
		res.redirect(`/builder/pc/${pc.id}/edit`);
	} catch (error) {
		console.error("Error creating new PC:", error);
		// await db.query("ROLLBACK");
		req.flash("error", "Failed to create PC. Please fix the errors and try again.");
		res.redirect("/builder/pc/new");
	}
};

/**
 * PC Edit Form (All Sections)
 * Route: GET /builder/pc/:id/edit
 *
 * - Loads full PC data.
 * - Renders builder page with tabs/sections.
 * - Uses ?section= query param to focus a specific section (optional).
 */
const pcEditForm = async (req, res) => {
	const user = req.session.user;
	const campaignId = res.locals.campaign_id;
	const pcId = parseInt(req.params.id, 10);
	const section = req.query.section || "identity";

	try {
		// TODO: Implement a getPcById(pcId) in characters model
		const pc = await getPCs(campaignId, user, { pcId });

		if (!pc) {
			req.flash("error", "PC not found.");
			return res.redirect("/builder/pc");
		}

		if (!canEditPc(user, pc)) {
			req.flash("error", "You do not have permission to edit this PC.");
			return res.redirect("/builder/pc");
		}

		const dropdowns = await loadPcDropdowns();

		// TODO: Load related tables (social, attributes, stats, skills, etc.)
		// via characters model helpers, similar to Asset Builder's data loading.

		res.render("builder/pc/edit", {
			title: `Edit PC: ${pc.pc_name}`,
			pc,
			dropdowns,
			section
		});
	} catch (error) {
		console.error("Error loading PC edit form:", error);
		req.flash("error", "Failed to load PC edit form.");
		res.redirect("/builder/pc");
	}
};

/**
 * Section Update Handlers
 *
 * Each section will have its own POST route, similar to Asset Builder:
 * - /builder/pc/:id/edit/identity
 * - /builder/pc/:id/edit/social
 * - /builder/pc/:id/edit/attributes
 * - /builder/pc/:id/edit/stats
 * - /builder/pc/:id/edit/skills
 * - /builder/pc/:id/edit/classes
 * - /builder/pc/:id/edit/languages
 * - /builder/pc/:id/edit/religion
 * - /builder/pc/:id/edit/titles
 * - /builder/pc/:id/edit/achievements
 * - /builder/pc/:id/edit/scars
 * - /builder/pc/:id/edit/gallery
 */

// Identity & Basics
const submitPcIdentity = async (req, res) => {
	const user = req.session.user;
	const campaignId = res.locals.campaign_id;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Load PC, check canEditPc, validate fields, call updatePcMain in a transaction.

	res.redirect(`/builder/pc/${pcId}/edit?section=identity`);
};

// Social Profile
const submitPcSocial = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Extract social fields, sanitize, call replacePcSocial in a transaction.

	res.redirect(`/builder/pc/${pcId}/edit?section=social`);
};

// Attributes
const submitPcAttributes = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Extract attributes, validate numbers, call replacePcAttributes.

	res.redirect(`/builder/pc/${pcId}/edit?section=attributes`);
};

// Stats
const submitPcStats = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Extract stats, validate, call replacePcStats.

	res.redirect(`/builder/pc/${pcId}/edit?section=stats`);
};

// Skills
const submitPcSkills = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Extract skills, validate, call replacePcSkills.

	res.redirect(`/builder/pc/${pcId}/edit?section=skills`);
};

// Classes & Archetypes
const submitPcClasses = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Normalize class array, validate, call replacePcClasses.

	res.redirect(`/builder/pc/${pcId}/edit?section=classes`);
};

// Languages
const submitPcLanguages = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Normalize language array, call replacePcLanguages.

	res.redirect(`/builder/pc/${pcId}/edit?section=languages`);
};

// Religion
const submitPcReligion = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Extract religion fields, sanitize, call replacePcReligion.

	res.redirect(`/builder/pc/${pcId}/edit?section=religion`);
};

// Titles
const submitPcTitles = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Normalize titles array, call replacePcTitles.

	res.redirect(`/builder/pc/${pcId}/edit?section=titles`);
};

// Achievements
const submitPcAchievements = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Normalize achievements array, call replacePcAchievements.

	res.redirect(`/builder/pc/${pcId}/edit?section=achievements`);
};

// Scars
const submitPcScars = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Normalize scars array, call replacePcScars.

	res.redirect(`/builder/pc/${pcId}/edit?section=scars`);
};

// Gallery
const submitPcGallery = async (req, res) => {
	const user = req.session.user;
	const pcId = parseInt(req.params.id, 10);

	// TODO: Validate URLs (controller), normalize gallery array, call replacePcGallery.

	res.redirect(`/builder/pc/${pcId}/edit?section=gallery`);
};

// --- Exports ---

export {
	pcBuilderDashboard,
	pcNewForm,
	submitNewPc,
	pcEditForm,
	submitPcIdentity,
	submitPcSocial,
	submitPcAttributes,
	submitPcStats,
	submitPcSkills,
	submitPcClasses,
	submitPcLanguages,
	submitPcReligion,
	submitPcTitles,
	submitPcAchievements,
	submitPcScars,
	submitPcGallery
};
