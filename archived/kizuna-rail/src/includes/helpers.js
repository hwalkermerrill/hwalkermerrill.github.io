/**
 * Generates a unique Japan Rail like confirmation code for bookings.
 * @returns {string} A unique confirmation code.
 */
const generateConfirmationCode = () => {
	return "JR" + Math.random().toString(36).substring(2, 10).toUpperCase();
};

/**
 * Converts kilometers to miles.
 * @param {number} km - The distance in kilometers.
 * @returns {number} The equivalent distance in miles.
 */
const kmToMiles = (km) => {
	const conversionFactor = 0.621371;
	return km * conversionFactor;
};

/**
 * Converts Japanese Yen to US Dollars.
 * @param {number} yen - The amount in Japanese Yen.
 * @returns {number} The equivalent amount in US Dollars.
 */
const yenToUsd = (yen) => {
	const exchangeRate = 0.007; // Example rate: 1 Yen = 0.0065 USD as of 2/23/26, balanced to 0.007 for advantage pricing while in flux.
	return yen * exchangeRate;
};

export { generateConfirmationCode, kmToMiles, yenToUsd };