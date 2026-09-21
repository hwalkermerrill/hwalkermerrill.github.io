// Imports
import db from "../db.js";
import { sanitizeText, validateImgUrl } from "../../utils/validation.js";
import { normalizeToArray } from "../../utils/normalization.js";

// Get existing gallery entries
const getGalleryEntries = async (
	tableName,
	parentColumn,
	parentId
) => {
	const { rows } = await db.query(`
		SELECT *
		FROM ${tableName}
		WHERE ${parentColumn} = $1
		ORDER BY id ASC
	`, [parentId]);

	return rows;
};

// Add a single gallery image
const addGalleryEntry = async (
	tableName,
	parentColumn,
	parentId,
	{
		image_url,
		alt,
		is_imported = false,
		is_main = false,
		is_hover = false,
		hover_visible = false,
		is_tall = false,
		figcaption = null
	}
) => {
	const url = image_url?.trim();

	if (!url) return;

	if (!validateImgUrl(url)) {
		return;
	}

	await db.query(`
		INSERT INTO ${tableName} (
			${parentColumn},
			image_url,
			alt,
			is_imported,
			is_main,
			is_hover,
			hover_visible,
			is_tall,
			figcaption
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7,$8,$9
		)
	`, [
		parentId,
		url,
		sanitizeText(alt || "Gallery Image"),
		Boolean(is_imported),
		Boolean(is_main),
		Boolean(is_hover),
		Boolean(hover_visible),
		Boolean(is_tall),
		sanitizeText(figcaption)
	]);
};

// Delete all gallery entries
const deleteGalleryEntries = async (
	tableName,
	parentColumn,
	parentId
) => {
	await db.query(`
		DELETE
		FROM ${tableName}
		WHERE ${parentColumn} = $1
	`, [parentId]);
};

// Replace/update gallery
const updateGalleryEntries = async (
	tableName,
	parentColumn,
	parentId,
	data
) => {
	const urls = normalizeToArray(data.gallery_url);
	const alts = normalizeToArray(data.gallery_alt);
	const talls = normalizeToArray(data.gallery_is_tall);
	const captions = normalizeToArray(data.gallery_figcaption);
	const hoverVisible = normalizeToArray(data.gallery_hover_visible);
	const imageTypes = normalizeToArray(data.gallery_type);

	await deleteGalleryEntries(
		tableName,
		parentColumn,
		parentId
	);

	let mainAssigned = false;
	let hoverAssigned = false;

	for (let i = 0; i < urls.length; i++) {
		const type = imageTypes[i] || "extra";

		let is_main = false;
		let is_hover = false;

		if (type === "main" && !mainAssigned) {
			is_main = true;
			mainAssigned = true;
		}

		if (type === "hover" && !hoverAssigned) {
			is_hover = true;
			hoverAssigned = true;
		}

		await addGalleryEntry(
			tableName,
			parentColumn,
			parentId,
			{
				image_url: urls[i],
				alt: alts[i],
				is_main,
				is_hover,
				hover_visible: hoverVisible[i] === "true",
				is_tall: talls[i] === "true",
				figcaption: captions[i]
			}
		);
	}
};

export {
	getGalleryEntries,
	addGalleryEntry,
	deleteGalleryEntries,
	updateGalleryEntries
};