// Imports
import db from "../db.js";
import { sanitizeText, validateImgUrl } from "../../utils/validation.js";
import { normalizeToArray } from "../../utils/normalization.js";
import { getGalleryEntries, addGalleryEntry, deleteGalleryEntries, updateGalleryEntries } from "../helpers/gallery.js";

// Quick Update Helpers
const updateCharacterStatus = async (
	type,
	id,
	activeStatusId
) => {
	await db.query(`
		UPDATE ${getMainTable(type)}
		SET active_status_id = $1
		WHERE id = $2
	`, [
		activeStatusId,
		id
	]);
};

const updateCharacterIdentified = async (
	type,
	id,
	isIdentified
) => {
	await db.query(`
		UPDATE ${getMainTable(type)}
		SET is_identified = $1
		WHERE id = $2
	`, [
		isIdentified,
		id
	]);
};

const updateCharacterSecretVisibility = async (
	type,
	id,
	showSecretName
) => {
	await db.query(`
		UPDATE ${getMainTable(type)}
		SET show_secret_name = $1
		WHERE id = $2
	`, [
		showSecretName,
		id
	]);
};

const updateCharacterCampaign = async (
	type,
	id,
	campaignId
) => {
	await db.query(`
		UPDATE ${getMainTable(type)}
		SET campaign_id = $1
		WHERE id = $2
	`, [
		campaignId,
		id
	]);
};

const updateCharacterAttitudeId = async (
	type,
	id,
	attitudeId
) => {

	const table =
		type === "npc"
			? "npc_attitude"
			: "faction_attitude";

	const column =
		type === "npc"
			? "npc_id"
			: "faction_id";

	await db.query(`
		UPDATE ${table}
		SET attitude_id = $1
		WHERE ${column} = $2
	`, [
		attitudeId,
		id
	]);
};

// Helpers - JOIN
const SOCIAL_JOIN = (type) => `
  LEFT JOIN ${type}_social soc
    ON soc.${type}_id = character.id
`;

const GALLERY_JOIN = (type) => `
  LEFT JOIN ${type}_gallery g
    ON g.${type}_id = character.id
`;

const TITLES_JOIN = (type) => `
  LEFT JOIN ${type}_titles t
    ON t.${type}_id = character.id
  LEFT JOIN titles ti
    ON ti.id = t.title_id
  LEFT JOIN title_ranks tr
    ON tr.id = ti.rank_id
`;

const CLASSES_JOIN = (type) => `
  LEFT JOIN ${type}_class cls
    ON cls.${type}_id = character.id
  LEFT JOIN ${type}_class_archetype arch
    ON arch.${type}_class_id = cls.id
`;

const ACHIEVEMENTS_JOIN = (type) => `
  LEFT JOIN ${type}_achievements ach
    ON ach.${type}_id = character.id
`;

const SCARS_JOIN = (type) => `
  LEFT JOIN ${type}_scars sc
    ON sc.${type}_id = character.id
`;

const ATTITUDE_JOIN = (type) => `
  LEFT JOIN ${type}_attitude att
    ON att.${type}_id = character.id
`;

const QUESTS_JOIN = (type) => `
  LEFT JOIN ${type}_quests q
    ON q.${type}_id = character.id
`;

const LANGUAGES_JOIN = (type) => `
  LEFT JOIN ${type}_language lang
    ON lang.${type}_id = character.id
`;

const RELIGION_JOIN = (type) => `
	LEFT JOIN ${type}_religions rel
    ON rel.${type}_id = character.id
`;

const MERCHANT_JOIN = (type) => `
  LEFT JOIN merchants m
    ON m.${type}_id = character.id
  LEFT JOIN merchant_details md
    ON md.merchant_id = m.id
`;

// Helpers - Group By
const SOCIAL_GROUP_BY = (type) => {
	switch (type) {
		case "pc":
			return "soc.appearance, soc.background, soc.associates, soc.rumors, soc.aspirations, soc.anathema, soc.phobias, soc.quirks, soc.flaws, soc.secrets";
		case "companion":
			return "soc.appearance, soc.background, soc.extra_details, soc.secrets";
		case "npc":
			return "soc.appearance, soc.background, soc.extra_details, soc.hidden_details, soc.reveal_hidden_details, soc.secrets";
		case "faction":
			return "soc.appearance, soc.background, soc.extra_details, soc.hidden_details, soc.reveal_hidden_details, soc.secrets";
		default:
			return "soc.appearance, soc.background, soc.extra_details, soc.secrets";
	}
};

// Helpers - SELECT
const SELECT_GALLERY_AGG = `
  json_agg(
    jsonb_build_object(
      'image_url', g.image_url,
      'alt', g.alt,
      'is_main', g.is_main,
      'is_hover', g.is_hover,
      'hover_visible', g.hover_visible,
      'is_tall', g.is_tall
    )
  ) FILTER (WHERE g.id IS NOT NULL) AS gallery
`;

const SELECT_TITLES_AGG = `
  json_agg(
    jsonb_build_object(
      'title_id', t.title_id,
      'title_name', ti.title_name,
      'title_location', t.title_location,
      'has_location', t.has_location,
      'use_honorific', t.use_honorific,
      'adjust_ranking', t.adjust_ranking,
      'adjust_value', t.adjust_value,
      'title_sort_order', tr.sort_order
    )
  ) FILTER (WHERE t.title_id IS NOT NULL) AS titles
`;

const SELECT_CLASSES_AGG = `
  json_agg(
    jsonb_build_object(
      'class_id', cls.class_id,
      'class_level', cls.class_level,
      'unknown_name', cls.unknown_name,
      'archetype_name', arch.archetype_name
    )
  ) FILTER (WHERE cls.class_id IS NOT NULL) AS classes
`;

const SELECT_SCARS_AGG = `
  json_agg(
    jsonb_build_object(
      'scar_cause', sc.scar_cause,
      'scar_description', sc.scar_description,
      'session_received', sc.session_received
    )
  ) FILTER (WHERE sc.scar_cause IS NOT NULL) AS scars
`;

const SELECT_ACHIEVEMENTS_AGG = `
  json_agg(
    jsonb_build_object(
      'achievement_id', ach.achievement_id,
      'is_killing_blow', ach.is_killing_blow
    )
  ) FILTER (WHERE ach.achievement_id IS NOT NULL) AS achievements
`;

const SELECT_QUESTS_AGG = `
  json_agg(q.quest_id) FILTER (WHERE q.quest_id IS NOT NULL) AS quests
`;

const SELECT_LANGUAGES_AGG = `
  json_agg(lang.language_id) FILTER (WHERE lang.language_id IS NOT NULL) AS languages
`;

const SELECT_RELIGIONS_AGG = `
  json_agg(rel.religions_id) FILTER (WHERE rel.religions_id IS NOT NULL) AS religions
`;

const SELECT_ATTITUDE_OBJECT = `
  jsonb_agg(
    jsonb_build_object(
      'attitude_id', att.attitude_id,
      'favored_pc', att.favored_pc,
      'allies', att.allies,
      'allies_visible', att.allies_visible,
      'enemies', att.enemies,
      'enemies_visible', att.enemies_visible,
      'influence_skills', att.influence_skills,
      'skills_visible', att.skills_visible,
      'influence_notes', att.influence_notes,
      'notes_visible', att.notes_visible,
      'progress_made', att.progress_made,
      'progress_threshold', att.progress_threshold,
      'hostile_boon', att.hostile_boon,
      'unfriendly_boon', att.unfriendly_boon,
			'neutral_boon', att.neutral_boon,
      'friendly_boon', att.friendly_boon,
      'helpful_boon', att.helpful_boon,
      'notes', att.notes,
      'secrets', att.secrets
    )
  ) FILTER (WHERE att.attitude_id IS NOT NULL) AS attitude
`;

const SELECT_MERCHANT_AGG = `
  jsonb_agg(
    jsonb_build_object(
      'merchant_id', m.id,
      'merchant_type', md.merchant_type,
      'shop_name', md.shop_name,
      'size', md.size,
      'base_value', md.base_value,
      'purchase_limit', md.purchase_limit,
      'minor_items', md.minor_items,
      'moderate_items', md.moderate_items,
      'major_items', md.major_items,
      'spellcasting_limit', md.spellcasting_limit,
      'notes', md.notes,
      'secrets', md.secrets
    )
  ) FILTER (WHERE m.id IS NOT NULL) AS merchant
`;

const SELECT_SOCIAL_OBJECT = (type) => {
	switch (type) {
		case "pc":
			return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'associates', soc.associates,
          'rumors', soc.rumors,
          'aspirations', soc.aspirations,
          'anathema', soc.anathema,
          'phobias', soc.phobias,
          'quirks', soc.quirks,
          'flaws', soc.flaws,
          'secrets', soc.secrets
        ) AS social
      `;
		case "companion":
			return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'extra_details', soc.extra_details,
          'secrets', soc.secrets
        ) AS social
      `;
		case "npc":
		case "faction":
			return `
        jsonb_build_object(
          'appearance', soc.appearance,
          'background', soc.background,
          'extra_details', soc.extra_details,
          'hidden_details', soc.hidden_details,
          'reveal_hidden_details', soc.reveal_hidden_details,
          'secrets', soc.secrets
        ) AS social
      `;
	}
};

// Helpers - WHERE
function buildWhereClause({ campaignId, userId, type }) {
	const params = [];
	const conditions = [];

	if (campaignId) {
		params.push(campaignId);
		conditions.push(`character.campaign_id = $${params.length}`);
	}

	if (userId && (type === "pc" || type === "companion")) {
		params.push(userId);
		conditions.push(`character.user_id = $${params.length}`);
	}

	const whereClause = conditions.length
		? `WHERE ${conditions.join(" AND ")}`
		: "";

	return { whereClause, params };
}

// Core Query Builder
function buildCharacterQuery({ type, whereClause }) {
	return `
    SELECT
      character.*,

      ${SELECT_SOCIAL_OBJECT(type)},
      ${SELECT_GALLERY_AGG},

      ${type === "pc" || type === "companion" || type === "npc" ? SELECT_TITLES_AGG : "NULL AS titles"},
      ${type === "pc" || type === "companion" || type === "npc" ? SELECT_LANGUAGES_AGG : "NULL AS languages"},
      ${type === "pc" || type === "companion" || type === "npc" ? SELECT_RELIGIONS_AGG : "NULL AS religions"},
      ${type === "pc" || type === "companion" ? SELECT_CLASSES_AGG : "NULL AS classes"},
      ${type === "pc" || type === "companion" ? SELECT_SCARS_AGG : "NULL AS scars"},
      ${type === "pc" || type === "companion" ? SELECT_ACHIEVEMENTS_AGG : "NULL AS achievements"},
      ${type === "npc" || type === "faction" ? SELECT_ATTITUDE_OBJECT : "NULL AS attitude"},
      ${type === "npc" || type === "faction" ? SELECT_QUESTS_AGG : "NULL AS quests"},
      ${type === "npc" || type === "faction" ? SELECT_MERCHANT_AGG : "NULL AS merchant"}

    FROM ${type === "faction" ? "factions" : `${type}_main`} character

    ${SOCIAL_JOIN(type)}
    ${GALLERY_JOIN(type)}
    
    ${type === "pc" || type === "companion" || type === "npc" ? TITLES_JOIN(type) : ""}
    ${type === "pc" || type === "companion" || type === "npc" ? LANGUAGES_JOIN(type) : ""}
    ${type === "pc" || type === "companion" || type === "npc" ? RELIGION_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? CLASSES_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? ACHIEVEMENTS_JOIN(type) : ""}
    ${type === "pc" || type === "companion" ? SCARS_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? ATTITUDE_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? QUESTS_JOIN(type) : ""}
    ${type === "npc" || type === "faction" ? MERCHANT_JOIN(type) : ""}

    ${whereClause}

    GROUP BY
      character.id,
      ${SOCIAL_GROUP_BY(type)}

    ORDER BY character.${type}_name ASC;
  `;
}

// Read Model Functions
async function getSingleCharacter({ type, id }) {
	const query = buildCharacterQuery({
		type,
		whereClause: `WHERE character.id = $1`
	});

	const { rows } = await db.query(query, [id]);
	return rows[0] || null;
}

function getMainTable(type) {
	switch (type) {
		case "pc":
			return "pc_main";
		case "companion":
			return "companion_main";
		case "npc":
			return "npc_main";
		case "faction":
			return "factions";
	}
}

function getCharacterIdColumn(type) {
	switch (type) {
		case "pc":
			return "pc_id";
		case "companion":
			return "companion_id";
		case "npc":
			return "npc_id";
		case "faction":
			return "faction_id";
	}
}

const getPCs = async ({ campaignId = null, userId = null } = {}) => {
	const { whereClause, params } = buildWhereClause({ campaignId, userId, type: "pc" });
	const query = buildCharacterQuery({ type: "pc", whereClause });
	const { rows } = await db.query(query, params);
	return rows;
};

const getCompanions = async ({ campaignId = null, userId = null } = {}) => {
	const { whereClause, params } = buildWhereClause({ campaignId, userId, type: "companion" });
	const query = buildCharacterQuery({ type: "companion", whereClause });
	const { rows } = await db.query(query, params);
	return rows;
};

const getNPCs = async ({ campaignId = null } = {}) => {
	const { whereClause, params } = buildWhereClause({ campaignId, type: "npc" });
	const query = buildCharacterQuery({ type: "npc", whereClause });
	const { rows } = await db.query(query, params);
	return rows;
};

const getFactions = async ({ campaignId = null } = {}) => {
	const { whereClause, params } = buildWhereClause({ campaignId, type: "faction" });
	const query = buildCharacterQuery({ type: "faction", whereClause });
	const { rows } = await db.query(query, params);
	return rows;
};

const getPcById = async (id) =>
	getSingleCharacter({ type: "pc", id });

const getCompanionById = async (id) =>
	getSingleCharacter({ type: "companion", id });

const getNpcById = async (id) =>
	getSingleCharacter({ type: "npc", id });

const getFactionById = async (id) =>
	getSingleCharacter({ type: "faction", id });

// Cross-Character Updaters
const updateCharacterReligion = async (
	type,
	characterId,
	{
		religion_id,
		notes,
		secrets
	}
) => {
	const table = `${type}_religion`;
	const column = `${type}_id`;

	await db.query(`
		DELETE FROM ${table}
		WHERE ${column} = $1
	`, [characterId]);

	await db.query(`
		INSERT INTO ${table} (
			${column},
			religion_id,
			notes,
			secrets
		)
		VALUES (
			$1,$2,$3,$4
		)
	`, [
		characterId,
		religion_id,
		sanitizeText(notes),
		sanitizeText(secrets)
	]);
};

const addCharacterLanguage = async (
	type,
	characterId,
	languageId
) => {
	await db.query(`
		INSERT INTO ${type}_language (
			${type}_id,
			language_id
		)
		VALUES ($1,$2)
		ON CONFLICT DO NOTHING
	`, [
		characterId,
		languageId
	]);
};

const removeCharacterLanguage = async (
	type,
	characterId,
	languageId
) => {
	await db.query(`
		DELETE FROM ${type}_language
		WHERE ${type}_id = $1
			AND language_id = $2
	`, [
		characterId,
		languageId
	]);
};

const addCharacterTitle = async (
	type,
	characterId,
	data
) => {
	await db.query(`
		INSERT INTO ${type}_titles (
			${type}_id,
			title_id,
			title_location,
			adjust_ranking,
			adjust_value,
			has_location,
			use_honorific,
			received_session
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7,$8
		)
	`, [
		characterId,
		data.title_id,
		data.title_location || null,
		data.adjust_ranking || null,
		data.adjust_value || null,
		data.has_location || false,
		data.use_honorific !== false,
		data.received_session || 1
	]);
};

const removeCharacterTitle = async (
	type,
	titleRowId
) => {
	await db.query(`
		DELETE FROM ${type}_titles
		WHERE id = $1
	`, [titleRowId]);
};

const addCharacterAchievement = async (
	type,
	characterId,
	achievementId,
	isKillingBlow = false
) => {
	await db.query(`
		INSERT INTO ${type}_achievements (
			${type}_id,
			achievement_id,
			is_killing_blow
		)
		VALUES ($1,$2,$3)
		ON CONFLICT DO NOTHING
	`, [
		characterId,
		achievementId,
		isKillingBlow
	]);
};

const removeCharacterAchievement = async (
	type,
	characterId,
	achievementId
) => {
	await db.query(`
		DELETE FROM ${type}_achievements
		WHERE ${type}_id = $1
			AND achievement_id = $2
	`, [
		characterId,
		achievementId
	]);
};

const addCharacterScar = async (
	type,
	characterId,
	{
		scar_cause,
		scar_description,
		session_received
	}
) => {
	await db.query(`
		INSERT INTO ${type}_scars (
			${type}_id,
			scar_cause,
			scar_description,
			session_received
		)
		VALUES ($1,$2,$3,$4)
	`, [
		characterId,
		sanitizeText(scar_cause),
		sanitizeText(scar_description),
		session_received || 1
	]);
};

const removeCharacterScar = async (
	type,
	scarId
) => {
	await db.query(`
		DELETE FROM ${type}_scars
		WHERE id = $1
	`, [scarId]);
};

// PC Builder Functions
const createPc = async (data) => {
	const {
		user_id,
		campaign_id,
		active_status_id,
		race_id,
		pc_name,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		race_traits,
		retired_reason,
		death_cause,
		end_session
	} = data;

	const { rows } = await db.query(`
		INSERT INTO pc_main (
			user_id,
			campaign_id,
			active_status_id,
			race_id,
			pc_name,
			unknown_name,
			is_identified,
			secret_name,
			show_secret_name,
			secret_color,
			is_gendered,
			is_female,
			description,
			race_traits,
			retired_reason,
			death_cause,
			end_session
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7,$8,
			$9,$10,$11,$12,$13,$14,$15,$16,$17
		)
		RETURNING id
	`, [
		user_id,
		campaign_id,
		active_status_id || 1,
		race_id || 1,
		pc_name.trim(),
		unknown_name || "Unknown",
		is_identified === true,
		sanitizeText(secret_name),
		show_secret_name === true,
		secret_color || null,
		is_gendered !== false,
		is_female === true,
		sanitizeText(description),
		sanitizeText(race_traits),
		sanitizeText(retired_reason),
		sanitizeText(death_cause),
		end_session || null
	]);
	return rows[0].id;
};

const updatePcMain = async (
	pcId,
	data
) => {
	const {
		active_status_id,
		race_id,
		pc_name,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		race_traits,
		retired_reason,
		death_cause,
		end_session
	} = data;

	await db.query(`
		UPDATE pc_main
		SET
			active_status_id = $1,
			race_id = $2,
			pc_name = $3,
			unknown_name = $4,
			is_identified = $5,
			secret_name = $6,
			show_secret_name = $7,
			secret_color = $8,
			is_gendered = $9,
			is_female = $10,
			description = $11,
			race_traits = $12,
			retired_reason = $13,
			death_cause = $14,
			end_session = $15
		WHERE id = $16
	`, [
		active_status_id,
		race_id,
		pc_name.trim(),
		unknown_name,
		is_identified,
		sanitizeText(secret_name),
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		sanitizeText(description),
		sanitizeText(race_traits),
		sanitizeText(retired_reason),
		sanitizeText(death_cause),
		end_session,
		pcId
	]);
};

const updatePcSocial = async (
	pcId,
	data
) => {
	await db.query(`
		DELETE FROM pc_social
		WHERE pc_id = $1
	`, [pcId]);

	await db.query(`
		INSERT INTO pc_social (
			pc_id,
			appearance,
			background,
			associates,
			rumors,
			aspirations,
			anathema,
			phobias,
			quirks,
			flaws,
			secrets
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,
			$7,$8,$9,$10,$11
		)
	`, [
		pcId,
		sanitizeText(data.appearance),
		sanitizeText(data.background),
		sanitizeText(data.associates),
		sanitizeText(data.rumors),
		sanitizeText(data.aspirations),
		sanitizeText(data.anathema),
		sanitizeText(data.phobias),
		sanitizeText(data.quirks),
		sanitizeText(data.flaws),
		sanitizeText(data.secrets)
	]);
};

const updatePcGallery = async (
	pcId,
	data
) => {
	await updateGalleryEntries(
		"pc_gallery",
		"pc_id",
		pcId,
		data
	);
};

const updatePcMechanics = async (
	pcId,
	{
		attributes = {},
		stats = {},
		skills = {},
		speeds = []
	}
) => {

	// Attributes
	await db.query(`
		DELETE FROM pc_attributes
		WHERE pc_id = $1
	`, [pcId]);

	await db.query(`
		INSERT INTO pc_attributes (
			pc_id,
			alignment,
			strength,
			dexterity,
			constitution,
			intelligence,
			wisdom,
			charisma,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,
			$6,$7,$8,$9
		)
	`, [
		pcId,
		attributes.alignment || "Neutral",
		Number(attributes.strength) || 10,
		Number(attributes.dexterity) || 10,
		Number(attributes.constitution) || 10,
		Number(attributes.intelligence) || 10,
		Number(attributes.wisdom) || 10,
		Number(attributes.charisma) || 10,
		sanitizeText(attributes.notes)
	]);

	// Stats
	await db.query(`
		DELETE FROM pc_stats
		WHERE pc_id = $1
	`, [pcId]);

	await db.query(`
		INSERT INTO pc_stats (
			pc_id,
			main_ac,
			flat_ac,
			touch_ac,
			cmd,
			max_hp,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7
		)
	`, [
		pcId,
		Number(stats.main_ac) || 10,
		Number(stats.flat_ac) || 10,
		Number(stats.touch_ac) || 10,
		Number(stats.cmd) || 10,
		Number(stats.max_hp) || 10,
		sanitizeText(stats.notes)
	]);

	// Skills
	await db.query(`
		DELETE FROM pc_skills
		WHERE pc_id = $1
	`, [pcId]);

	await db.query(`
		INSERT INTO pc_skills (
			pc_id,
			initiative,
			perception,
			sense_motive,
			disguise,
			stealth,
			disable_device,
			reflex,
			fortitude,
			will,
			rerolls,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,
			$7,$8,$9,$10,$11,$12
		)
	`, [
		pcId,
		Number(skills.initiative) || 0,
		Number(skills.perception) || 0,
		Number(skills.sense_motive) || 0,
		Number(skills.disguise) || 0,
		Number(skills.stealth) || 0,
		Number(skills.disable_device) || 0,
		Number(skills.reflex) || 0,
		Number(skills.fortitude) || 0,
		Number(skills.will) || 0,
		sanitizeText(skills.rerolls),
		sanitizeText(skills.notes)
	]);

	// Speeds
	await db.query(`
		DELETE FROM pc_speed
		WHERE pc_id = $1
	`, [pcId]);

	for (const speed of normalizeToArray(speeds)) {

		await db.query(`
			INSERT INTO pc_speed (
				pc_id,
				speed_id,
				speed_value
			)
			VALUES (
				$1,$2,$3
			)
		`, [
			pcId,
			Number(speed.speed_id) || 1,
			Number(speed.speed_value) || 30
		]);
	}
};

const updatePcClasses = async (
	pcId,
	classes
) => {

	await db.query(`
		DELETE FROM pc_class_archetype
		WHERE pc_class_id IN (
			SELECT id
			FROM pc_class
			WHERE pc_id = $1
		)
	`, [pcId]);

	await db.query(`
		DELETE FROM pc_class
		WHERE pc_id = $1
	`, [pcId]);

	for (const cls of normalizeToArray(classes)) {

		const { rows } = await db.query(`
			INSERT INTO pc_class (
				pc_id,
				class_id,
				unknown_name,
				class_level
			)
			VALUES (
				$1,$2,$3,$4
			)
			RETURNING id
		`, [
			pcId,
			Number(cls.class_id) || 1,
			cls.unknown_name || "Unknown",
			Number(cls.class_level) || 1
		]);

		const pcClassId = rows[0].id;

		for (const archetype of normalizeToArray(cls.archetypes)) {

			if (!archetype) continue;

			await db.query(`
				INSERT INTO pc_class_archetype (
					pc_class_id,
					archetype_name
				)
				VALUES (
					$1,$2
				)
			`, [
				pcClassId,
				sanitizeText(archetype)
			]);
		}
	}
};

// Companion Builder Functions
const createCompanion = async (data) => {
	const {
		user_id,
		pc_id,
		campaign_id,
		active_status_id,
		race_id,
		companion_name,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		race_traits,
		death_cause,
		end_session
	} = data;

	const { rows } = await db.query(`
		INSERT INTO companion_main (
			user_id,
			pc_id,
			campaign_id,
			active_status_id,
			race_id,
			companion_name,
			secret_name,
			show_secret_name,
			secret_color,
			is_gendered,
			is_female,
			description,
			race_traits,
			death_cause,
			end_session
		)
		VALUES (
			$1,$2,$3,$4,$5,
			$6,$7,$8,$9,
			$10,$11,$12,$13,
			$14,$15
		)
		RETURNING id
	`, [
		user_id,
		pc_id || null,
		campaign_id,
		active_status_id || 1,
		race_id || 1,
		companion_name.trim(),
		sanitizeText(secret_name),
		show_secret_name === true,
		secret_color || null,
		is_gendered !== false,
		is_female === true,
		sanitizeText(description),
		sanitizeText(race_traits),
		sanitizeText(death_cause),
		end_session || null
	]);

	return rows[0].id;
};

const updateCompanionMain = async (
	companionId,
	data
) => {
	const {
		pc_id,
		active_status_id,
		race_id,
		companion_name,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		race_traits,
		death_cause,
		end_session
	} = data;

	await db.query(`
		UPDATE companion_main
		SET
			pc_id = $1,
			active_status_id = $2,
			race_id = $3,
			companion_name = $4,
			secret_name = $5,
			show_secret_name = $6,
			secret_color = $7,
			is_gendered = $8,
			is_female = $9,
			description = $10,
			race_traits = $11,
			death_cause = $12,
			end_session = $13
		WHERE id = $14
	`, [
		pc_id || null,
		active_status_id,
		race_id,
		companion_name.trim(),
		sanitizeText(secret_name),
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		sanitizeText(description),
		sanitizeText(race_traits),
		sanitizeText(death_cause),
		end_session,
		companionId
	]);
};

const updateCompanionSocial = async (
	companionId,
	data
) => {

	await db.query(`
		DELETE FROM companion_social
		WHERE companion_id = $1
	`, [companionId]);

	await db.query(`
		INSERT INTO companion_social (
			companion_id,
			appearance,
			background,
			extra_details,
			secrets
		)
		VALUES (
			$1,$2,$3,$4,$5
		)
	`, [
		companionId,
		sanitizeText(data.appearance),
		sanitizeText(data.background),
		sanitizeText(data.extra_details),
		sanitizeText(data.secrets)
	]);
};

const updateCompanionGallery = async (
	companionId,
	data
) => {

	await updateGalleryEntries(
		"companion_gallery",
		"companion_id",
		companionId,
		data
	);
};

const updateCompanionMechanics = async (
	companionId,
	{
		attributes = {},
		stats = {},
		skills = {},
		speeds = []
	}
) => {

	// Attributes
	await db.query(`
		DELETE FROM companion_attributes
		WHERE companion_id = $1
	`, [companionId]);

	await db.query(`
		INSERT INTO companion_attributes (
			companion_id,
			alignment,
			strength,
			dexterity,
			constitution,
			intelligence,
			wisdom,
			charisma,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,
			$6,$7,$8,$9
		)
	`, [
		companionId,
		attributes.alignment || "Neutral",
		Number(attributes.strength) || 10,
		Number(attributes.dexterity) || 10,
		Number(attributes.constitution) || 10,
		Number(attributes.intelligence) || 10,
		Number(attributes.wisdom) || 10,
		Number(attributes.charisma) || 10,
		sanitizeText(attributes.notes)
	]);

	// Stats
	await db.query(`
		DELETE FROM companion_stats
		WHERE companion_id = $1
	`, [companionId]);

	await db.query(`
		INSERT INTO companion_stats (
			companion_id,
			main_ac,
			flat_ac,
			touch_ac,
			cmd,
			max_hp,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7
		)
	`, [
		companionId,
		Number(stats.main_ac) || 10,
		Number(stats.flat_ac) || 10,
		Number(stats.touch_ac) || 10,
		Number(stats.cmd) || 10,
		Number(stats.max_hp) || 10,
		sanitizeText(stats.notes)
	]);

	// Skills
	await db.query(`
		DELETE FROM companion_skills
		WHERE companion_id = $1
	`, [companionId]);

	await db.query(`
		INSERT INTO companion_skills (
			companion_id,
			initiative,
			perception,
			sense_motive,
			disguise,
			stealth,
			disable_device,
			reflex,
			fortitude,
			will,
			rerolls,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,
			$7,$8,$9,$10,$11,$12
		)
	`, [
		companionId,
		Number(skills.initiative) || 0,
		Number(skills.perception) || 0,
		Number(skills.sense_motive) || 0,
		Number(skills.disguise) || 0,
		Number(skills.stealth) || 0,
		Number(skills.disable_device) || 0,
		Number(skills.reflex) || 0,
		Number(skills.fortitude) || 0,
		Number(skills.will) || 0,
		sanitizeText(skills.rerolls),
		sanitizeText(skills.notes)
	]);

	// Speeds
	await db.query(`
		DELETE FROM companion_speed
		WHERE companion_id = $1
	`, [companionId]);

	for (const speed of normalizeToArray(speeds)) {

		await db.query(`
			INSERT INTO companion_speed (
				companion_id,
				speed_id,
				speed_value
			)
			VALUES (
				$1,$2,$3
			)
		`, [
			companionId,
			Number(speed.speed_id) || 1,
			Number(speed.speed_value) || 30
		]);
	}
};

const updateCompanionClasses = async (
	companionId,
	classes
) => {

	await db.query(`
		DELETE FROM companion_class_archetype
		WHERE companion_class_id IN (
			SELECT id
			FROM companion_class
			WHERE companion_id = $1
		)
	`, [companionId]);

	await db.query(`
		DELETE FROM companion_class
		WHERE companion_id = $1
	`, [companionId]);

	for (const cls of normalizeToArray(classes)) {

		const { rows } = await db.query(`
			INSERT INTO companion_class (
				companion_id,
				class_id,
				unknown_name,
				class_level
			)
			VALUES (
				$1,$2,$3,$4
			)
			RETURNING id
		`, [
			companionId,
			Number(cls.class_id) || 1,
			cls.unknown_name || "Unknown",
			Number(cls.class_level) || 1
		]);

		const companionClassId = rows[0].id;

		for (const archetype of normalizeToArray(cls.archetypes)) {

			if (!archetype) continue;

			await db.query(`
				INSERT INTO companion_class_archetype (
					companion_class_id,
					archetype_name
				)
				VALUES (
					$1,$2
				)
			`, [
				companionClassId,
				sanitizeText(archetype)
			]);
		}
	}
};

// NPC Builder Functions
const createNpc = async (data) => {
	const {
		campaign_id,
		active_status_id,
		race_id,
		npc_name,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		secrets,
		race_traits,
		retired_reason,
		death_cause,
		end_session,
		pinned,
		npc_group
	} = data;

	const { rows } = await db.query(`
		INSERT INTO npc_main (
			campaign_id,
			active_status_id,
			race_id,
			npc_name,
			unknown_name,
			is_identified,
			secret_name,
			show_secret_name,
			secret_color,
			is_gendered,
			is_female,
			description,
			secrets,
			race_traits,
			retired_reason,
			death_cause,
			end_session,
			pinned,
			npc_group
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7,$8,
			$9,$10,$11,$12,$13,$14,
			$15,$16,$17,$18,$19
		)
		RETURNING id
	`, [
		campaign_id,
		active_status_id || 1,
		race_id || 1,
		npc_name.trim(),
		unknown_name || "Unknown",
		is_identified === true,
		sanitizeText(secret_name),
		show_secret_name === true,
		secret_color || null,
		is_gendered !== false,
		is_female === true,
		sanitizeText(description),
		sanitizeText(secrets),
		sanitizeText(race_traits),
		sanitizeText(retired_reason),
		sanitizeText(death_cause),
		end_session || null,
		pinned === true,
		npc_group || null
	]);

	return rows[0].id;
};

const updateNpcMain = async (
	npcId,
	data
) => {
	const {
		active_status_id,
		race_id,
		npc_name,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		description,
		secrets,
		race_traits,
		retired_reason,
		death_cause,
		end_session,
		pinned,
		npc_group
	} = data;

	await db.query(`
		UPDATE npc_main
		SET
			active_status_id = $1,
			race_id = $2,
			npc_name = $3,
			unknown_name = $4,
			is_identified = $5,
			secret_name = $6,
			show_secret_name = $7,
			secret_color = $8,
			is_gendered = $9,
			is_female = $10,
			description = $11,
			secrets = $12,
			race_traits = $13,
			retired_reason = $14,
			death_cause = $15,
			end_session = $16,
			pinned = $17,
			npc_group = $18
		WHERE id = $19
	`, [
		active_status_id,
		race_id,
		npc_name.trim(),
		unknown_name,
		is_identified,
		sanitizeText(secret_name),
		show_secret_name,
		secret_color,
		is_gendered,
		is_female,
		sanitizeText(description),
		sanitizeText(secrets),
		sanitizeText(race_traits),
		sanitizeText(retired_reason),
		sanitizeText(death_cause),
		end_session,
		pinned,
		npc_group || null,
		npcId
	]);
};

const updateNpcSocial = async (
	npcId,
	data
) => {

	await db.query(`
		DELETE FROM npc_social
		WHERE npc_id = $1
	`, [npcId]);

	await db.query(`
		INSERT INTO npc_social (
			npc_id,
			appearance,
			background,
			extra_details,
			hidden_details,
			reveal_hidden_details,
			secrets
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7
		)
	`, [
		npcId,
		sanitizeText(data.appearance),
		sanitizeText(data.background),
		sanitizeText(data.extra_details),
		sanitizeText(data.hidden_details),
		Boolean(data.reveal_hidden_details),
		sanitizeText(data.secrets)
	]);

};

const updateNpcGallery = async (
	npcId,
	data
) => {

	await updateGalleryEntries(
		"npc_gallery",
		"npc_id",
		npcId,
		data
	);

};

const updateNpcMechanics = async (
	npcId,
	{
		stats = {},
		languages = []
	}
) => {

	// Stats
	await db.query(`
		DELETE FROM npc_stats
		WHERE npc_id = $1
	`, [npcId]);

	await db.query(`
		INSERT INTO npc_stats (
			npc_id,
			main_ac,
			max_hp,
			perception,
			sense_motive,
			will,
			reflex,
			fortitude,
			notes
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7,$8,$9
		)
	`, [
		npcId,
		Number(stats.main_ac) || 10,
		Number(stats.max_hp) || 10,
		Number(stats.perception) || 0,
		Number(stats.sense_motive) || 0,
		Number(stats.will) || 0,
		Number(stats.reflex) || 0,
		Number(stats.fortitude) || 0,
		sanitizeText(stats.notes)
	]);

	// Languages
	await db.query(`
		DELETE FROM npc_language
		WHERE npc_id = $1
	`, [npcId]);

	for (const languageId of normalizeToArray(languages)) {

		await db.query(`
			INSERT INTO npc_language (
				npc_id,
				language_id
			)
			VALUES ($1,$2)
			ON CONFLICT DO NOTHING
		`, [
			npcId,
			Number(languageId)
		]);

	}

};

const updateNpcAttitude = async (
	npcId,
	data
) => {

	await db.query(`
		DELETE FROM npc_attitude
		WHERE npc_id = $1
	`, [npcId]);

	await db.query(`
		INSERT INTO npc_attitude (
			npc_id,
			attitude_id,
			favored_pc,
			allies,
			allies_visible,
			enemies,
			enemies_visible,
			influence_skills,
			skills_visible,
			influence_notes,
			notes_visible,
			progress_made,
			progress_threshold,
			hostile_boon,
			unfriendly_boon,
			neutral_boon,
			friendly_boon,
			helpful_boon,
			notes,
			secrets
		)
		VALUES (
			$1,$2,$3,$4,$5,
			$6,$7,$8,$9,$10,
			$11,$12,$13,$14,$15,
			$16,$17,$18,$19, $20
		)
	`, [
		npcId,
		Number(data.attitude_id) || 3,

		data.favored_pc || null,

		sanitizeText(data.allies),
		Boolean(data.allies_visible),

		sanitizeText(data.enemies),
		Boolean(data.enemies_visible),

		sanitizeText(data.influence_skills),
		Boolean(data.skills_visible),

		sanitizeText(data.influence_notes),
		Boolean(data.notes_visible),

		Number(data.progress_made) || 0,
		Number(data.progress_threshold) || 10,

		sanitizeText(data.hostile_boon),
		sanitizeText(data.unfriendly_boon),
		sanitizeText(data.neutral_boon),
		sanitizeText(data.friendly_boon),
		sanitizeText(data.helpful_boon),

		sanitizeText(data.notes),
		sanitizeText(data.secrets)
	]);

};

// Faction Builder Functions
const createFaction = async (data) => {
	const {
		campaign_id,
		active_status_id,
		faction_name,
		unknown_name,
		is_identified,
		secret_name,
		show_secret_name,
		secret_color,

		faction_type,

		description,
		secrets,

		pinned,

		progress_able,
		progress_made,
		progress_threshold,

		death_cause,
		retired_reason,

		start_session,
		end_session
	} = data;

	const { rows } = await db.query(`
		INSERT INTO factions (
			campaign_id,
			active_status_id,

			faction_name,
			unknown_name,

			is_identified,

			secret_name,
			show_secret_name,
			secret_color,

			faction_type,

			description,
			secrets,

			pinned,

			progress_able,
			progress_made,
			progress_threshold,

			death_cause,
			retired_reason,

			start_session,
			end_session
		)
		VALUES (
			$1,$2,

			$3,$4,

			$5,

			$6,$7,$8,

			$9,

			$10,$11,

			$12,

			$13,$14,$15,

			$16,$17,

			$18,$19
		)
		RETURNING id
	`, [
		campaign_id,
		active_status_id || 1,

		faction_name.trim(),
		unknown_name || "Unknown",

		is_identified === true,

		sanitizeText(secret_name),
		show_secret_name === true,
		secret_color || null,

		faction_type,

		sanitizeText(description),
		sanitizeText(secrets),

		pinned === true,

		progress_able === true,
		Number(progress_made) || 0,
		Number(progress_threshold) || 10,

		sanitizeText(death_cause),
		sanitizeText(retired_reason),

		Number(start_session) || 1,
		end_session || null
	]);

	return rows[0].id;
};

const updateFactionMain = async (
	factionId,
	data
) => {

	const {
		active_status_id,

		faction_name,
		unknown_name,

		is_identified,

		secret_name,
		show_secret_name,
		secret_color,

		faction_type,

		description,
		secrets,

		pinned,

		progress_able,
		progress_made,
		progress_threshold,

		death_cause,
		retired_reason,

		start_session,
		end_session
	} = data;

	await db.query(`
		UPDATE factions
		SET
			active_status_id = $1,

			faction_name = $2,
			unknown_name = $3,

			is_identified = $4,

			secret_name = $5,
			show_secret_name = $6,
			secret_color = $7,

			faction_type = $8,

			description = $9,
			secrets = $10,

			pinned = $11,

			progress_able = $12,
			progress_made = $13,
			progress_threshold = $14,

			death_cause = $15,
			retired_reason = $16,

			start_session = $17,
			end_session = $18

		WHERE id = $19
	`, [
		active_status_id,

		faction_name.trim(),
		unknown_name,

		is_identified,

		sanitizeText(secret_name),
		show_secret_name,
		secret_color,

		faction_type,

		sanitizeText(description),
		sanitizeText(secrets),

		pinned,

		progress_able,
		Number(progress_made) || 0,
		Number(progress_threshold) || 10,

		sanitizeText(death_cause),
		sanitizeText(retired_reason),

		Number(start_session) || 1,
		end_session,

		factionId
	]);
};

const updateFactionSocial = async (
	factionId,
	data
) => {

	await db.query(`
		DELETE FROM faction_social
		WHERE faction_id = $1
	`, [factionId]);

	await db.query(`
		INSERT INTO faction_social (
			faction_id,

			appearance,
			background,

			extra_details,
			hidden_details,

			reveal_hidden_details,

			secrets
		)
		VALUES (
			$1,$2,$3,$4,$5,$6,$7
		)
	`, [
		factionId,

		sanitizeText(data.appearance),
		sanitizeText(data.background),

		sanitizeText(data.extra_details),
		sanitizeText(data.hidden_details),

		Boolean(data.reveal_hidden_details),

		sanitizeText(data.secrets)
	]);
};

const updateFactionGallery = async (
	factionId,
	data
) => {

	await updateGalleryEntries(
		"faction_gallery",
		"faction_id",
		factionId,
		data
	);
};

const updateFactionAttitude = async (
	factionId,
	data
) => {

	await db.query(`
		DELETE FROM faction_attitude
		WHERE faction_id = $1
	`, [factionId]);

	await db.query(`
		INSERT INTO faction_attitude (
			faction_id,
			attitude_id,

			favored_pc,

			allies,
			allies_visible,

			enemies,
			enemies_visible,

			influence_skills,
			skills_visible,

			influence_notes,
			notes_visible,

			progress_made,
			progress_threshold,

			hostile_boon,
			unfriendly_boon,
			neutral_boon,
			friendly_boon,
			helpful_boon,

			notes,
			secrets
		)
		VALUES (
			$1,$2,

			$3,

			$4,$5,

			$6,$7,

			$8,$9,

			$10,$11,

			$12,$13,

			$14,$15,$16,$17,$18,

			$19,$20
		)
	`, [
		factionId,
		Number(data.attitude_id) || 3,

		data.favored_pc || null,

		sanitizeText(data.allies),
		Boolean(data.allies_visible),

		sanitizeText(data.enemies),
		Boolean(data.enemies_visible),

		sanitizeText(data.influence_skills),
		Boolean(data.skills_visible),

		sanitizeText(data.influence_notes),
		Boolean(data.notes_visible),

		Number(data.progress_made) || 0,
		Number(data.progress_threshold) || 10,

		sanitizeText(data.hostile_boon),
		sanitizeText(data.unfriendly_boon),
		sanitizeText(data.neutral_boon),
		sanitizeText(data.friendly_boon),
		sanitizeText(data.helpful_boon),

		sanitizeText(data.notes),
		sanitizeText(data.secrets)
	]);

};

const addFactionMember = async (
	type,
	factionId,
	memberId,
	associationType = null,
	associationRank = null
) => {

	const table =
		type === "npc"
			? "faction_npcs"
			: type === "pc"
				? "faction_pcs"
				: "faction_companions";

	const column =
		type === "npc"
			? "npc_id"
			: type === "pc"
				? "pc_id"
				: "companion_id";

	await db.query(`
		INSERT INTO ${table} (
			faction_id,
			${column},
			association_type,
			association_rank
		)
		VALUES (
			$1,$2,$3,$4
		)
		ON CONFLICT DO NOTHING
	`, [
		factionId,
		memberId,
		associationType,
		associationRank
	]);
};

const removeFactionMember = async (
	type,
	factionId,
	memberId
) => {

	const table =
		type === "npc"
			? "faction_npcs"
			: type === "pc"
				? "faction_pcs"
				: "faction_companions";

	const column =
		type === "npc"
			? "npc_id"
			: type === "pc"
				? "pc_id"
				: "companion_id";

	await db.query(`
		DELETE FROM ${table}
		WHERE faction_id = $1
			AND ${column} = $2
	`, [
		factionId,
		memberId
	]);
};

// Exports
export {
	getPCs, getCompanions, getNPCs, getFactions,
	getPcById, getCompanionById, getNpcById, getFactionById,
	updateCharacterCampaign, updateCharacterIdentified, updateCharacterSecretVisibility, updateCharacterStatus, updateCharacterReligion, updateCharacterAttitudeId,
	addCharacterAchievement, addCharacterLanguage, addCharacterScar, addCharacterTitle,
	removeCharacterAchievement, removeCharacterLanguage, removeCharacterScar, removeCharacterTitle,
	createPc, updatePcMain, updatePcSocial, updatePcGallery, updatePcMechanics, updatePcClasses,
	createCompanion, updateCompanionMain, updateCompanionSocial, updateCompanionGallery, updateCompanionMechanics, updateCompanionClasses,
	createNpc, updateNpcMain, updateNpcSocial, updateNpcGallery, updateNpcMechanics, updateNpcAttitude,
	createFaction, updateFactionMain, updateFactionSocial, updateFactionGallery, updateFactionAttitude, addFactionMember, removeFactionMember
};