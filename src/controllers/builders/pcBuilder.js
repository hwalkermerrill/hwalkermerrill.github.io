// --- Imports ---
import {
	getPCs, getCompanions, getPcById, getCompanionById,
	updateCharacterStatus, updateCharacterIdentified, updateCharacterSecretVisibility, updateCharacterCampaign,
	updateCharacterReligion, updateCharacterRace, updateCharacterLanguage,
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
import { getGalleryEntries, addGalleryEntry, updateGalleryEntry, deleteGalleryEntry } from "../../models/helpers/gallery.js";
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
		return res.redirect(`/builder/pc/${pcId}/edit?tab=social`);
	}
	catch (err) {
		console.error("Error creating character:", err);
		req.flash("error", "Failed to create character.");
		return res.redirect("/builder/pc/new");
	}
}

async function submitPcMainEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updatePcMain(pcId, req.body);
		req.flash("success", "Main character information saved.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=social`);
	}
	catch (err) {
		console.error("Error updating PC:", err);
		req.flash("error", "Failed to save character.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=main`);
	}
}

async function submitPcSocialEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updatePcSocial(pcId, req.body);
		req.flash("success", "Social profile saved.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=character`);
	}
	catch (err) {
		console.error("Error updating social profile:", err);
		req.flash("error", "Failed to save social profile.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=social`);
	}
}
async function submitPcCharacterEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (
		!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateCharacterRace("pc", pcId, {
			race_id: req.body.race_id,
			race_traits: req.body.race_traits
		});
		await updateCharacterReligion("pc", pcId, {
			religion_id: req.body.religion_id,
			notes: req.body.religion_notes,
			secrets: req.body.religion_secrets
		});
		await updatePcClasses(pcId, req.body.classes || []);
		await updateCharacterLanguage("pc", pcId, normalizeToArray(req.body.language_ids));
		req.flash("success", "Character information saved.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=mechanics`);
	}
	catch (err) {
		console.error("Error updating character information:", err);
		req.flash("error", "Failed to save character information.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=character`);
	}
}

async function submitPcMechanicsEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updatePcMechanics(pcId, req.body);
		req.flash("success", "Character mechanics saved.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=background`);
	}
	catch (err) {
		console.error("Error updating character mechanics:", err);
		req.flash("error", "Failed to save character mechanics.");
		return res.redirect(`/builder/pc/${pcId}/edit?tab=mechanics`);
	}
}

// --- PC Mini-builder functions ---
async function addPcTitleController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterTitle("pc", pcId, req.body);
		req.flash("success", "Title added.");
	}
	catch (err) {
		console.error("Error adding title:", err);
		req.flash("error", "Failed to add title.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function removePcTitleController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterTitle("pc", pcId, req.body);
		req.flash("success", "Title removed.");
	}
	catch (err) {
		console.error("Error removing title:", err);
		req.flash("error", "Failed to remove title.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function addPcAchievementController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterAchievement("pc", pcId, req.body);
		req.flash("success", "Achievement added.");
	}
	catch (err) {
		console.error("Error adding achievement:", err);
		req.flash("error", "Failed to add achievement.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function removePcAchievementController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterAchievement("pc", pcId, req.body);
		req.flash("success", "Achievement removed.");
	}
	catch (err) {
		console.error("Error removing achievement:", err);
		req.flash("error", "Failed to remove achievement.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function addPcScarController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterScar("pc", pcId, req.body);
		req.flash("success", "Scar added.");
	}
	catch (err) {
		console.error("Error adding scar:", err);
		req.flash("error", "Failed to add scar.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function removePcScarController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterScar("pc", pcId, req.body);
		req.flash("success", "Scar removed.");
	}
	catch (err) {
		console.error("Error removing scar:", err);
		req.flash("error", "Failed to remove scar.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function addPcGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addGalleryEntry("pc_gallery", "pc_id", pcId, req.body);
		req.flash("success", "Gallery image added.");
	}
	catch (err) {
		console.error("Error adding gallery image:", err);
		req.flash("error", "Failed to add gallery image.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function updatePcGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateGalleryEntry("pc_gallery", Number(req.params.galleryId), req.body);
		req.flash("success", "Gallery image updated.");
	}
	catch (err) {
		console.error("Error updating gallery image:", err);
		req.flash("error", "Failed to update gallery image.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

async function removePcGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const pcId = Number(req.params.id);
	const pc = await getPcById(pcId);

	if (!pc) {
		req.flash("error", "PC not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, pc)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await deleteGalleryEntry("pc_gallery", Number(req.params.galleryId));
		req.flash("success", "Gallery image removed.");
	}
	catch (err) {
		console.error("Error removing gallery image:", err);
		req.flash("error", "Failed to remove gallery image.");
	}

	return res.redirect(
		`/builder/pc/${pcId}/edit?tab=background`
	);
}

// --- Companion Builder Functions ---
async function submitNewCompanion(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const {
		pc_id,
		companion_name,
		campaign_id,
		active_status_id,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description
	} = req.body;

	try {
		if (!companion_name || !companion_name.trim()) {
			req.flash("error", "Character name is required.");
			return res.redirect("/builder/companion/new");
		}

		const companionId = await createCompanion({
			user_id: user.id,
			pc_id: pc_id ? Number(pc_id) : null,
			campaign_id: Number(campaign_id),
			active_status_id: Number(active_status_id || 1),
			companion_name: companion_name.trim(),
			secret_name: secret_name || null,
			show_secret_name: show_secret_name === "true",
			secret_color: secret_color || null,
			is_gendered: is_gendered !== "false",
			is_female: is_female === "true",
			description: description || null
		});

		req.flash("success", "Character created successfully.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=social`);
	}
	catch (err) {
		console.error("Error creating character:", err);
		req.flash("error", "Failed to create character.");
		return res.redirect("/builder/companion/new");
	}
}

async function submitCompanionMainEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateCompanionMain(companionId, req.body);
		req.flash("success", "Main character information saved.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=social`);
	}
	catch (err) {
		console.error("Error updating Companion:", err);
		req.flash("error", "Failed to save character.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=main`);
	}
}

async function submitCompanionSocialEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateCompanionSocial(companionId, req.body);
		req.flash("success", "Social profile saved.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=character`);
	}
	catch (err) {
		console.error("Error updating social profile:", err);
		req.flash("error", "Failed to save social profile.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=social`);
	}
}
async function submitCompanionCharacterEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (
		!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateCharacterRace("companion", companionId, {
			race_id: req.body.race_id,
			race_traits: req.body.race_traits
		});
		await updateCharacterReligion("companion", companionId, {
			religion_id: req.body.religion_id,
			notes: req.body.religion_notes,
			secrets: req.body.religion_secrets
		});
		await updateCompanionClasses(companionId, req.body.classes || []);
		await updateCharacterLanguage("companion", companionId, normalizeToArray(req.body.language_ids));
		req.flash("success", "Character information saved.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=mechanics`);
	}
	catch (err) {
		console.error("Error updating character information:", err);
		req.flash("error", "Failed to save character information.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=character`);
	}
}

async function submitCompanionMechanicsEdit(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateCompanionMechanics(companionId, req.body);
		req.flash("success", "Character mechanics saved.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=background`);
	}
	catch (err) {
		console.error("Error updating character mechanics:", err);
		req.flash("error", "Failed to save character mechanics.");
		return res.redirect(`/builder/companion/${companionId}/edit?tab=mechanics`);
	}
}

// --- Companion Mini-builder functions ---
async function addCompanionTitleController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterTitle("companion", companionId, req.body);
		req.flash("success", "Title added.");
	}
	catch (err) {
		console.error("Error adding title:", err);
		req.flash("error", "Failed to add title.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function removeCompanionTitleController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterTitle("companion", companionId, req.body);
		req.flash("success", "Title removed.");
	}
	catch (err) {
		console.error("Error removing title:", err);
		req.flash("error", "Failed to remove title.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function addCompanionAchievementController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterAchievement("companion", companionId, req.body);
		req.flash("success", "Achievement added.");
	}
	catch (err) {
		console.error("Error adding achievement:", err);
		req.flash("error", "Failed to add achievement.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function removeCompanionAchievementController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterAchievement("companion", companionId, req.body);
		req.flash("success", "Achievement removed.");
	}
	catch (err) {
		console.error("Error removing achievement:", err);
		req.flash("error", "Failed to remove achievement.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function addCompanionScarController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addCharacterScar("companion", companionId, req.body);
		req.flash("success", "Scar added.");
	}
	catch (err) {
		console.error("Error adding scar:", err);
		req.flash("error", "Failed to add scar.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function removeCompanionScarController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await removeCharacterScar("companion", companionId, req.body);
		req.flash("success", "Scar removed.");
	}
	catch (err) {
		console.error("Error removing scar:", err);
		req.flash("error", "Failed to remove scar.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function addCompanionGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await addGalleryEntry("companion_gallery", "companion_id", companionId, req.body);
		req.flash("success", "Gallery image added.");
	}
	catch (err) {
		console.error("Error adding gallery image:", err);
		req.flash("error", "Failed to add gallery image.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function updateCompanionGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await updateGalleryEntry("companion_gallery", Number(req.params.galleryId), req.body);
		req.flash("success", "Gallery image updated.");
	}
	catch (err) {
		console.error("Error updating gallery image:", err);
		req.flash("error", "Failed to update gallery image.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

async function removeCompanionGalleryController(req, res) {

	const user = req.session.user;

	if (!user) {
		return res.redirect("/login");
	}

	const companionId = Number(req.params.id);
	const companion = await getCompanionById(companionId);

	if (!companion) {
		req.flash("error", "Companion not found.");
		return res.redirect("/builder/pc");
	}

	if (!editPermissionCheck(user, companion)) {
		req.flash("error", "You do not have permission to edit that character.");
		return res.redirect("/builder/pc");
	}

	try {
		await deleteGalleryEntry("companion_gallery", Number(req.params.galleryId));
		req.flash("success", "Gallery image removed.");
	}
	catch (err) {
		console.error("Error removing gallery image:", err);
		req.flash("error", "Failed to remove gallery image.");
	}

	return res.redirect(
		`/builder/companion/${companionId}/edit?tab=background`
	);
}

// --- Exports ---
export {
	showCharacterDashboard,
	updateCharacterCampaignController, updateCharacterIdentifiedController, updateCharacterSecretVisibilityController, updateCharacterStatusController,
	showCreatePcForm, showCreateCompanionForm, showEditPcForm, showEditCompanionForm,
	submitNewPc, submitPcMainEdit, submitPcSocialEdit, submitPcCharacterEdit, submitPcMechanicsEdit,
	addPcAchievementController, addPcTitleController, addPcScarController, addPcGalleryController,
	removePcAchievementController, removePcTitleController, removePcScarController, removePcGalleryController,
	submitNewCompanion, submitCompanionMainEdit, submitCompanionSocialEdit, submitCompanionCharacterEdit, submitCompanionMechanicsEdit,
	addCompanionAchievementController, addCompanionTitleController, addCompanionScarController, addCompanionGalleryController,
	removeCompanionAchievementController, removeCompanionTitleController, removeCompanionScarController, removeCompanionGalleryController
};
