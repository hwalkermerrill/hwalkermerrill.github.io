// Sanitize user input to prevent xxs
function sanitizeText(raw = "") {
	if (!raw) return "";

	// Escape all HTML
	let safe = raw
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;");

	// Allow <b>, <i>, <br>, <p>, <q>, <sup>, <sub>, <u>, <blockquote>, <figure> and <figcaption>
	safe = safe
		.replace(/&lt;b&gt;/g, "<b>")
		.replace(/&lt;\/b&gt;/g, "</b>")
		.replace(/&lt;i&gt;/g, "<i>")
		.replace(/&lt;\/i&gt;/g, "</i>")
		.replace(/&lt;p&gt;/g, "<p>")
		.replace(/&lt;\/p&gt;/g, "</p>")
		.replace(/&lt;q&gt;/g, "<q>")
		.replace(/&lt;\/q&gt;/g, "</q>")
		.replace(/&lt;br&gt;/g, "<br>")
		.replace(/&lt;sup&gt;/g, "<sup>")
		.replace(/&lt;\/sup&gt;/g, "</sup>")
		.replace(/&lt;sub&gt;/g, "<sub>")
		.replace(/&lt;\/sub&gt;/g, "</sub>")
		.replace(/&lt;u&gt;/g, "<u>")
		.replace(/&lt;\/u&gt;/g, "</u>")
		.replace(/&lt;aside&gt;/g, "<aside>")
		.replace(/&lt;\/aside&gt;/g, "</aside>")
		.replace(/&lt;blockquote&gt;/g, "<blockquote>")
		.replace(/&lt;\/blockquote&gt;/g, "</blockquote>")
		.replace(/&lt;figure&gt;/g, "<figure>")
		.replace(/&lt;\/figure&gt;/g, "</figure>")
		.replace(/&lt;figcaption&gt;/g, "<figcaption>")
		.replace(/&lt;\/figcaption&gt;/g, "</figcaption>");

	// Convert newlines to <br>
	safe = safe.replace(/\n/g, "<br>");

	return safe.trim();
}

function validateImgUrl(url) {
	// Must not contain whitespace
	if (/\s/.test(url)) return false;

	// Only absolute URLS and relative URLS starting with "/"
	if (!/^https?:\/\//i.test(url) && !url.startsWith("/")) {
		return false;
	}

	// Must end with a common image extension, allowing query parameters
	return /\.(png|jpg|jpeg|gif|webp)(\?.*)?$/i.test(url);
}

function normalizeInt(value) {
	if (
		value === undefined ||
		value === null ||
		String(value).trim() === ""
	) { return null; }
	return Number(value);
}

// Exports
export {
	sanitizeText,
	validateImgUrl,
	normalizeInt
};