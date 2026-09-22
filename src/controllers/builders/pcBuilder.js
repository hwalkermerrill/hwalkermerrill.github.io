// --- Imports ---
import {
	getPCs, getCompanions, getPcById, getCompanionById,
	updateCharacterStatus, updateCharacterIdentified, updateCharacterSecretVisibility, updateCharacterCampaign, updateCharacterReligion, updateCharacterRace,
	addCharacterLanguage, addCharacterTitle, addCharacterAchievement, addCharacterScar,
	removeCharacterLanguage, removeCharacterTitle, removeCharacterAchievement, removeCharacterScar,
	createPc, updatePcMain, updatePcSocial, updatePcGallery, updatePcMechanics, updatePcClasses,
	createCompanion, updateCompanionMain, updateCompanionSocial, updateCompanionGallery, updateCompanionMechanics, updateCompanionClasses
} from "../../models/forms/characters.js";
import {
	getCampaigns, getActiveStatus,
	getPcByCampaign, getCompanionByCampaign,
	getRaces, getClasses, getReligions, getLanguages, getTitles, getAchievements
} from "../../models/helpers/select.js";
import { hasRole } from "../../utils/permissions.js";
import { validateImgUrl } from "../../utils/validation.js";

// --- Permissions ---
function ownsCharacter(user, character) {
	if (!user || !character) {
		return false;
	}

	return Number(character.user_id) === Number(user.id);
}

function limitedPermission(user) {
	return hasRole(user, "gm_admin") || hasRole(user, "moderator");
}

function fullPermission(user) {
	return hasRole(user, "gm_admin");
}

function editPermissionCheck(user, character) {
	return (fullPermission(user) || ownsCharacter(user, character))
}

// --- Helpers ---
async function loadCampaigns() {
	const campaigns = await getCampaigns();
	return campaigns;
}

async function loadFormData(campaignId) {

	const pcs = await getPcByCampaign(campaignId);
	const companions = await getCompanionByCampaign(campaignId);
	const active_status = await getActiveStatus();
	const races = await getRaces();
	const classes = await getClasses();
	const religions = await getReligions();
	const languages = await getLanguages();
	const titles = await getTitles();
	const achievements = await getAchievements();

	return {
		pcs,
		companions,
		active_status,
		races,
		classes,
		religions,
		languages,
		titles,
		achievements
	};
}

// --- Validation and Normalization ---

function validateGalleryUrls(req) {
	const raw = req.body.gallery_url;

	// Single value
	if (typeof raw === "string") {
		const trimmed = raw.trim();
		if (!trimmed) return;

		if (!validateImgUrl(trimmed)) {
			req.flash("error", `Invalid image URL: "${raw}". Must be a valid http/https image link ending in .png/.jpg/.jpeg/.gif/.webp.`);
		}

		return;
	}

	// Multiple values (array)
	if (Array.isArray(raw)) {
		raw.forEach((value) => {
			const trimmed = (value || "").trim();
			if (!trimmed) return;

			if (!validateImgUrl(trimmed)) {
				req.flash("error", `Invalid image URL: "${value}". Must be a valid http/https image link ending in .png/.jpg/.jpeg/.gif/.webp.`);
			}
		});
	}
}

function normalizeToArray(value) {

	if (!value) {
		return [];
	}

	return Array.isArray(value)
		? value : [value];
}

// --- Dashboard Controller Function ---
async function showCharacterDashboard(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const campaignId = res.locals.campaign_id;


	try {
		const campaigns = await loadCampaigns();
		const active_status = await getActiveStatus();
		let pcs;
		let companions;

		if (limitedPermission(user)) {
			pcs = await getPCs({ campaignId });
			companions = await getCompanions({ campaignId });
		} else {
			pcs = await getPCs({ campaignId, userId: user.id });
			companions = await getCompanions({ campaignId, userId: user.id });
		}

		res.render("forms/characters/list", {
			title: "Manage PCs & Companions",
			activePage: "dashboard",
			campaigns,
			campaign_id: campaignId,
			active_status,
			pcs,
			companions
		});
	}
	catch (err) {
		console.error("Error loading character dashboard:", err);
		req.flash("error", "Failed to load character dashboard.");
		return res.redirect("/");
	}
}

// --- Dashboard Quick-Update Functions --
async function updateCharacterStatusController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const { character_type, active_status_id } = req.body;
	const characterId = Number(req.params.id);
	let character = null;

	if (character_type === "pc") {
		character = await getPcById(characterId)
	}
	else if (character_type === "companion") {
		character = await getCompanionById(characterId)
	}

	if (!character) {
		req.flash("error", "Character not found.");
		return res.redirect("/builder/character");
	}

	if (!(limitedPermission(user) || ownsCharacter(user, character))) {
		req.flash("error", "You do not have permission to modify that character.");
		return res.redirect("/builder/character");
	}

	try {
		await updateCharacterStatus(character_type, characterId, Number(active_status_id));
		req.flash("success", "Character status updated.");
	}
	catch (err) {
		console.error("Error updating character status:", err);
		req.flash("error", "Failed to update character status.");
	}

	return res.redirect("/builder/character");
}

async function updateCharacterIdentifiedController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const { character_type, is_identified } = req.body;
	const characterId = Number(req.params.id);
	let character = null;

	if (character_type === "pc") {
		character = await getPcById(characterId)
	}
	else if (character_type === "companion") {
		character = await getCompanionById(characterId)
	}

	if (!character) {
		req.flash("error", "Character not found.");
		return res.redirect("/builder/character");
	}

	if (!(limitedPermission(user) || ownsCharacter(user, character))) {
		req.flash("error", "You do not have permission to modify that character.");
		return res.redirect("/builder/character");
	}

	try {
		await updateCharacterIdentified(character_type, characterId, is_identified === "true");
		req.flash("success", "Identification updated.");
	}
	catch (err) {
		console.error("Error updating identification:", err);
		req.flash("error", "Failed to update identification.");
	}

	return res.redirect("/builder/character");
}

async function updateCharacterSecretVisibilityController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const { character_type, show_secret_name } = req.body;
	const characterId = Number(req.params.id);
	let character = null;

	if (character_type === "pc") {
		character = await getPcById(characterId)
	}
	else if (character_type === "companion") {
		character = await getCompanionById(characterId)
	}

	if (!character) {
		req.flash("error", "Character not found.");
		return res.redirect("/builder/character");
	}

	if (!(limitedPermission(user) || ownsCharacter(user, character))) {
		req.flash("error", "You do not have permission to modify that character.");
		return res.redirect("/builder/character");
	}

	try {
		await updateCharacterSecretVisibility(character_type, characterId, show_secret_name === "true");
		req.flash("success", "Secret visibility updated.");
	}
	catch (err) {
		console.error("Error updating secret visibility:", err);
		req.flash("error", "Failed to update secret visibility.");
	}

	return res.redirect("/builder/character");
}

async function updateCharacterCampaignController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const { character_type, campaign_id } = req.body;
	const characterId = Number(req.params.id);
	let character = null;

	if (character_type === "pc") {
		character = await getPcById(characterId)
	}
	else if (character_type === "companion") {
		character = await getCompanionById(characterId)
	}

	if (!character) {
		req.flash("error", "Character not found.");
		return res.redirect("/builder/character");
	}

	if (!(limitedPermission(user) || ownsCharacter(user, character))) {
		req.flash("error", "You do not have permission to modify that character.");
		return res.redirect("/builder/character");
	}

	try {
		await updateCharacterCampaign(character_type, characterId, campaign_id ? Number(campaign_id) : null);
		req.flash("success", "Campaign updated.");
	}
	catch (err) {
		console.error("Error updating campaign:", err);
		req.flash("error", "Failed to update campaign.");
	}

	return res.redirect("/builder/character");
}

// --- Main Builder Form Functions ---
async function showCreatePcForm(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const campaignId = res.locals.campaign_id;
	const campaigns = await loadCampaigns();
	const formData = await loadFormData(campaignId);

	res.render("forms/characters/pcForm", {
		title: "Create PC",
		activePage: "dashboard",
		formMode: "create",
		pc: null,
		campaigns,
		...formData
	});
}

async function showCreateCompanionForm(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const campaignId = res.locals.campaign_id;
	const campaigns = await loadCampaigns();
	const formData = await loadFormData(campaignId);

	res.render("forms/characters/companionForm", {
		title: "Create Companion",
		activePage: "dashboard",
		formMode: "create",
		companion: null,
		campaigns,
		...formData
	});
}

async function showEditPcForm(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		return res.status(404).send("PC not found.");
	}

	if (!editPermissionCheck(user, pc)) {
		return res.status(403).send("Forbidden.");
	}

	const campaigns = await loadCampaigns();
	const formData = await loadFormData(pc.campaign_id);

	res.render("forms/characters/pcForm", {
		title: `Edit PC: ${pc.pc_name}`,
		activePage: "dashboard",
		formMode: "edit",
		pc,
		campaigns,
		...formData
	});
}

async function showEditCompanionForm(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		return res.status(404).send("Companion not found.");
	}

	if (!editPermissionCheck(user, companion)) {
		return res.status(403).send("Forbidden.");
	}

	const campaigns = await loadCampaigns();
	const formData = await loadFormData(companion.campaign_id);

	res.render("forms/characters/companionForm", {
		title: `Edit Companion: ${companion.companion_name}`,
		activePage: "dashboard",
		formMode: "edit",
		companion,
		campaigns,
		...formData
	});
}

// --- PC Builder Functions ---
async function submitNewPc(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const {
		pc_name,
		campaign_id,
		active_status_id,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description
	} = req.body;

	try {
		if (!pc_name || !pc_name.trim()) {
			req.flash("error", "Character name is required.");
			return res.redirect("/builder/pc/new");
		}

		const pcId = await createPc({
			user_id: user.id,
			campaign_id: Number(campaign_id),
			active_status_id: Number(active_status_id || 1),
			pc_name: pc_name.trim(),
			unknown_name: unknown_name || "Unknown",
			is_identified: is_identified === "true",
			secret_name: secret_name || null,
			show_secret_name: show_secret_name === "true",
			secret_color: secret_color || null,
			is_gendered: is_gendered !== "false",
			is_female: is_female === "true",
			description: description || null
		});

		req.flash("success", "Character created successfully.");
		return res.redirect(`/builder/pc/${pcId}/social`);
	}
	catch (err) {
		console.error("Error creating character:", err);
		req.flash("error", "Failed to create character.");
		return res.redirect("/builder/pc/new");
	}
}

// --- Exports ---
export {
	showCharacterDashboard,
	updateCharacterCampaignController, updateCharacterIdentifiedController, updateCharacterSecretVisibilityController, updateCharacterStatusController,
	showCreatePcForm, showCreateCompanionForm, showEditPcForm, showEditCompanionForm
};
