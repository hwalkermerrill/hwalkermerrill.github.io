export function keepAwakePage(req, res, next) {
	res.locals.keepAwake = true;
	next();
}