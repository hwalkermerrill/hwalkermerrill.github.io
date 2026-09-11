function normalizeToArray(value) {
	if (!value) return [];
	return Array.isArray(value) ? value : [value];
}

// Exports
export { normalizeToArray };