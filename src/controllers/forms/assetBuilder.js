// --- Imports ---
// Reuse existing page models where possible
import {
	getAssetsForCampaign, getItemById, getGalleryForItem, getOwnersForItem,
	createItem,
	updateItem, updateItemStatus, updateItemIdentified, updateItemOwner, updateItemBoonsVisible,
	deleteItem,
	replaceGalleryForItem, replaceOwnersForItem
} from "../../models/pages/assets.js";
import { getCampaigns, getActiveStatus, getPcByCampaign, getCompanionByCampaign, getNpcByCampaign, getFactionByCampaign } from "../../models/helpers/select.js";
import { getMapsForCampaign } from "../../models/pages/maps.js";
import { hasRole } from "../../utils/permissions.js";

// --- Permissions ---
function limitedPermission(user) {
	return hasRole(user, "gm_admin") || hasRole(user, "moderator");
}

function fullPermission(user) {
	return hasRole(user, "gm_admin");
}

// --- Helpers ---
async function loadCampaigns() {
	const campaigns = await getCampaigns();
	return campaigns;
}

async function loadFormData(campaignId) {
	const pcs = await getPcByCampaign(campaignId);
	const companions = await getCompanionByCampaign(campaignId);
	const npcs = await getNpcByCampaign(campaignId);
	const factions = await getFactionByCampaign(campaignId);

	return {
		pcs,
		companions,
		npcs,
		factions
	};
}

// Controller Functions
async function showItemDashboard(req, res) {
	const user = req.session.user;
	if (!user || !limitedPermission(user)) {
		return res.redirect("/login");
	}

	const campaignId = res.locals.campaign_id;

	const campaigns = await loadCampaigns();
	const active_status = await getActiveStatus();
	const items = await getAssetsForCampaign(campaignId);
	const maps = await getMapsForCampaign(campaignId);
	const formData = await loadFormData(campaignId);

	res.render("forms/assets/list", {
		title: "Manage Items & Maps",
		activePage: "assets",
		campaigns,
		campaign_id: campaignId,
		items,
		maps,
		active_status,
		...formData
	});
}

async function showCreateItemForm(req, res) {
	const user = req.session.user;
	if (!user || !fullPermission(user)) {
		return res.redirect("/login");
	}

	const campaignId = res.locals.campaign_id;
	const active_status = await getActiveStatus();
	const campaigns = await loadCampaigns();
	const formData = await loadFormData(campaignId);

	res.render("forms/assets/form", {
		title: "Create Item",
		activePage: "assets",
		formMode: "create",
		item: null,
		active_status,
		gallery: [],
		owners: null,
		campaigns,
		...formData
	});
}

async function showEditItemForm(req, res) {
	const user = req.session.user;
	if (!user || !fullPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);
	const item = await getItemById(itemId);

	if (!item) {
		return res.status(404).send("Item not found.");
	}

	const active_status = await getActiveStatus();
	const campaigns = await loadCampaigns();
	const formData = await loadFormData(item.campaign_id);
	const gallery = await getGalleryForItem(itemId);
	const owners = await getOwnersForItem(itemId);

	res.render("forms/assets/form", {
		title: `Edit Item: ${item.item_name}`,
		activePage: "assets",
		formMode: "edit",
		item,
		gallery,
		active_status,
		owners,
		campaigns,
		...formData
	});
}

// Crud Functions
// *Create
async function submitNewItem(req, res) {
	const user = req.session.user;
	if (!user || !fullPermission(user)) {
		return res.redirect("/login");
	}

	try {
		const itemId = await createItem(req.body);
		await replaceGalleryForItem(itemId, req.body);
		await replaceOwnersForItem(itemId, req.body);

		req.flash("success", "Item created successfully!");
		return res.redirect(`/builder/item/${itemId}`);
	} catch (err) {
		console.error("Error creating item:", err);
		req.flash("error", "Failed to create item.");
		return res.redirect("/builder/item/new");
	}
}

// *Update
async function submitItemEdit(req, res) {
	const user = req.session.user;
	if (!user || !fullPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);

	try {
		await updateItem(itemId, req.body);
		await replaceGalleryForItem(itemId, req.body);
		await replaceOwnersForItem(itemId, req.body);

		req.flash("success", "Item updated successfully!");
		return res.redirect(`/builder/item/${itemId}`);
	} catch (err) {
		console.error("Error updating item:", err);
		req.flash("error", "Failed to update item.");
		return res.redirect(`/builder/item/${itemId}`);
	}
}

async function updateItemStatusController(req, res) {
	const user = req.session.user;
	if (!user || !limitedPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);
	const { active_status_id } = req.body;

	try {
		await updateItemStatus(itemId, Number(active_status_id));
		req.flash("success", "Item status updated.");
	} catch (err) {
		console.error("Error updating item status:", err);
		req.flash("error", "Failed to update item status.");
	}

	return res.redirect("/builder/item");
}

async function updateItemIdentifiedController(req, res) {
	const user = req.session.user;
	if (!user || !limitedPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);
	const { is_identified } = req.body;
	const flag = is_identified === "true";

	try {
		await updateItemIdentified(itemId, flag);
		req.flash("success", "Item identification updated.");
	} catch (err) {
		console.error("Error updating identification:", err);
		req.flash("error", "Failed to update identification.");
	}

	return res.redirect("/builder/item");
}

async function updateItemBoonsVisibleController(req, res) {
	const user = req.session.user;
	if (!user || !limitedPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);
	const { boons_visible } = req.body;
	const flag = boons_visible === "true";

	try {
		await updateItemBoonsVisible(itemId, flag);
		req.flash("success", "Boons visibility updated.");
	} catch (err) {
		console.error("Error updating boons visibility:", err);
		req.flash("error", "Failed to update boons visibility.");
	}

	return res.redirect("/builder/item");
}

async function updateItemOwnerController(req, res) {
	const user = req.session.user;
	if (!user || !limitedPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);
	const { pc_id } = req.body;

	try {
		await updateItemOwner(itemId, pc_id ? Number(pc_id) : null);
		req.flash("success", "Item owner updated.");
	} catch (err) {
		console.error("Error updating item owner:", err);
		req.flash("error", "Failed to update item owner.");
	}

	return res.redirect("/builder/item");
}

// *Delete
async function deleteItemController(req, res) {
	const user = req.session.user;
	if (!user || !fullPermission(user)) {
		return res.redirect("/login");
	}

	const itemId = Number(req.params.id);

	try {
		await deleteItem(itemId);
		req.flash("success", "Item deleted.");
		return res.redirect("/builder/item");
	} catch (err) {
		console.error("Error deleting item:", err);
		req.flash("error", "Failed to delete item.");
		return res.redirect("/builder/item");
	}
}

// Exports
export {
	showItemDashboard,
	showCreateItemForm,
	showEditItemForm,
	submitNewItem,
	submitItemEdit,
	updateItemStatusController,
	updateItemIdentifiedController,
	updateItemOwnerController,
	updateItemBoonsVisibleController,
	deleteItemController
};
