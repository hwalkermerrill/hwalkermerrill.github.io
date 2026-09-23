// Imports (Core-Middleware-Routes)
import { Router } from "express";
import { requireLogin, requireRole } from "../middleware/auth.js";

import {
	showItemDashboard, showCreateItemForm, showEditItemForm, submitNewItem, submitItemEdit, deleteItemController,
	updateItemStatusController, updateItemIdentifiedController, updateItemOwnerController, updateItemBoonsVisibleController
} from "./builders/assetBuilder.js";

import {
	showCharacterDashboard, showCreatePcForm, showCreateCompanionForm, showEditPcForm, showEditCompanionForm,
	updateCharacterCampaignController, updateCharacterIdentifiedController, updateCharacterSecretVisibilityController, updateCharacterStatusController,
	submitNewPc, submitPcMainEdit, submitPcSocialEdit, submitPcCharacterEdit, submitPcMechanicsEdit,
	submitNewCompanion, submitCompanionMainEdit, submitCompanionSocialEdit, submitCompanionCharacterEdit, submitCompanionMechanicsEdit,
	addPcAchievementController, addPcTitleController, addPcScarController, addPcGalleryController, updatePcGalleryController,
	addCompanionAchievementController, addCompanionTitleController, addCompanionScarController, addCompanionGalleryController, updateCompanionGalleryController,
	removePcAchievementController, removePcTitleController, removePcScarController, removePcGalleryController, deletePcController,
	removeCompanionAchievementController, removeCompanionTitleController, removeCompanionScarController, removeCompanionGalleryController, deleteCompanionController
} from "./builders/pcBuilder.js";

const builderSubRouter = Router()

// Builder.get items
builderSubRouter.get("/item", requireLogin, requireRole("moderator"), showItemDashboard);
builderSubRouter.get("/item/new", requireLogin, requireRole("gm_admin"), showCreateItemForm);
builderSubRouter.get("/item/:id/edit", requireLogin, requireRole("gm_admin"), showEditItemForm);

// Builder.get characters
builderSubRouter.get("/characters", requireLogin, showCharacterDashboard);
builderSubRouter.get("/pc/new", requireLogin, showCreatePcForm);
builderSubRouter.get("/companion/new", requireLogin, showCreateCompanionForm);
builderSubRouter.get("/pc/:id/edit", requireLogin, showEditPcForm);
builderSubRouter.get("/companion/:id/edit", requireLogin, showEditCompanionForm);

// Builder.post items quick actions
builderSubRouter.post("/item/:id/status", requireLogin, requireRole("moderator"), updateItemStatusController);
builderSubRouter.post("/item/:id/identified", requireLogin, requireRole("moderator"), updateItemIdentifiedController);
builderSubRouter.post("/item/:id/boons", requireLogin, requireRole("moderator"), updateItemBoonsVisibleController);
builderSubRouter.post("/item/:id/owner", requireLogin, requireRole("moderator"), updateItemOwnerController);

// Builder.post character quick actions
builderSubRouter.post("/character/:id/campaign", requireLogin, updateCharacterCampaignController);
builderSubRouter.post("/character/:id/status", requireLogin, updateCharacterStatusController);
builderSubRouter.post("/character/:id/identified", requireLogin, updateCharacterIdentifiedController);
builderSubRouter.post("/character/:id/secret", requireLogin, updateCharacterSecretVisibilityController);

// Builder.post items main
builderSubRouter.post("/item/new", requireLogin, requireRole("gm_admin"), submitNewItem);
builderSubRouter.post("/item/:id/edit", requireLogin, requireRole("gm_admin"), submitItemEdit);
builderSubRouter.post("/item/:id/delete", requireLogin, requireRole("gm_admin"), deleteItemController);

// Builder.post pc main
builderSubRouter.post("/pc/new", requireLogin, submitNewPc);
builderSubRouter.post("/pc/:id/edit/main", requireLogin, submitPcMainEdit);
builderSubRouter.post("/pc/:id/edit/social", requireLogin, submitPcSocialEdit);
builderSubRouter.post("/pc/:id/edit/character", requireLogin, submitPcCharacterEdit);
builderSubRouter.post("/pc/:id/edit/mechanics", requireLogin, submitPcMechanicsEdit);

// Builder.post companion main
builderSubRouter.post("/companion/new", requireLogin, submitNewCompanion);
builderSubRouter.post("/companion/:id/edit/main", requireLogin, submitCompanionMainEdit);
builderSubRouter.post("/companion/:id/edit/social", requireLogin, submitCompanionSocialEdit);
builderSubRouter.post("/companion/:id/edit/character", requireLogin, submitCompanionCharacterEdit);
builderSubRouter.post("/companion/:id/edit/mechanics", requireLogin, submitCompanionMechanicsEdit);

// Builder.post pc mini
builderSubRouter.post("/pc/:id/edit/achievement/add", requireLogin, addPcAchievementController);
builderSubRouter.post("/pc/:id/edit/achievement/remove", requireLogin, removePcAchievementController);
builderSubRouter.post("/pc/:id/edit/title/add", requireLogin, addPcTitleController);
builderSubRouter.post("/pc/:id/edit/title/remove", requireLogin, removePcTitleController);
builderSubRouter.post("/pc/:id/edit/scar/add", requireLogin, addPcScarController);
builderSubRouter.post("/pc/:id/edit/scar/remove", requireLogin, removePcScarController);
builderSubRouter.post("/pc/:id/edit/gallery/add", requireLogin, addPcGalleryController);
builderSubRouter.post("/pc/:id/edit/gallery/:galleryId/update", requireLogin, updatePcGalleryController);
builderSubRouter.post("/pc/:id/edit/gallery/:galleryId/remove", requireLogin, removePcGalleryController);

// Builder.post companion mini
builderSubRouter.post("/companion/:id/edit/achievement/add", requireLogin, addCompanionAchievementController);
builderSubRouter.post("/companion/:id/edit/achievement/remove", requireLogin, removeCompanionAchievementController);
builderSubRouter.post("/companion/:id/edit/title/add", requireLogin, addCompanionTitleController);
builderSubRouter.post("/companion/:id/edit/title/remove", requireLogin, removeCompanionTitleController);
builderSubRouter.post("/companion/:id/edit/scar/add", requireLogin, addCompanionScarController);
builderSubRouter.post("/companion/:id/edit/scar/remove", requireLogin, removeCompanionScarController);
builderSubRouter.post("/companion/:id/edit/gallery/add", requireLogin, addCompanionGalleryController);
builderSubRouter.post("/companion/:id/edit/gallery/:galleryId/update", requireLogin, updateCompanionGalleryController);
builderSubRouter.post("/companion/:id/edit/gallery/:galleryId/remove", requireLogin, removeCompanionGalleryController);

builderSubRouter.post("/pc/:id/delete", requireLogin, deletePcController);
builderSubRouter.post("/companion/:id/delete", requireLogin, deleteCompanionController);

export default builderSubRouter