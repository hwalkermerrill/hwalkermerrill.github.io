// Sanitize user input to prevent xxs
function sanitizeText(raw = "") {
	if (!raw) return "";

	// Escape all HTML
	let safe = raw
		.replace(/&/g, "&amp;")
		.replace(/</g, "&lt;")
		.replace(/>/g, "&gt;");

	// Allow <b>, <i>, <br>, <q>
	safe = safe
		.replace(/&lt;b&gt;/g, "<b>")
		.replace(/&lt;\/b&gt;/g, "</b>")
		.replace(/&lt;i&gt;/g, "<i>")
		.replace(/&lt;\/i&gt;/g, "</i>")
		.replace(/&lt;q&gt;/g, "<q>")
		.replace(/&lt;\/q&gt;/g, "</q>")
		.replace(/&lt;br&gt;/g, "<br>");

	// Convert newlines to <br>
	safe = safe.replace(/\n/g, "<br>");

	return safe.trim();
}

function validateImgUrl(url) {
	// Must not contain whitespace
	if (/\s/.test(url)) return false;

	// Allow absolute URLs
	if (/^https?:\/\//i.test(url)) {
		// Must end with a common image extension
		return /\.(png|jpg|jpeg|gif|webp)$/i.test(url);
	}

	// Allow relative URLs starting with /
	if (url.startsWith("/")) {
		// Must end with a common image extension
		return /\.(png|jpg|jpeg|gif|webp)$/i.test(url);
	}

	// Everything else is invalid
	return false;
}

// Exports
export {
	sanitizeText,
	validateImgUrl,
};