// Imports
import { generateConfirmationCode, yenToUsd } from "../includes/helpers.js";
import { getDb as db } from "./db-in-file.js";

// Constants
const monthAbbrev = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

// ROUTE MODEL FUNCTIONS
export const formatMonth = (monthNumber) => {
	return monthAbbrev[monthNumber - 1];
};

export const getAllRoutes = async () => {
	return db().routes;
};

export const getListOfRegions = async () => {
	const regions = new Set(db().routes.map(route => route.region));
	return Array.from(regions);
};

export const getListOfSeasons = async () => {
	const seasons = new Set(db().routes.map(route => route.bestSeason));
	return Array.from(seasons);
};

export const getRouteById = async (routeId) => {
	const route = db().routes.find(route => route.id == routeId) || null;
	return {
		...route,
		operatingMonths: route.operatingMonths.map(month => formatMonth(month))
	};
};

export const getRoutesByRegion = async (region) => {
	return db().routes.filter(route => route.region.toLowerCase() == region.toLowerCase());
};

export const getRoutesBySeason = async (season) => {
	return db().routes.filter(route => route.bestSeason.toLowerCase() == season.toLowerCase());
};

export const getRoutesByMonth = async (month) => {
	return db().routes.filter(route => route.operatingMonths.includes(month));
};

export const getRoutesByDuration = async () => {
	return [...db().routes].sort((a, b) => {
		const aDuration = parseFloat(a.duration);
		const bDuration = parseFloat(b.duration);
		return aDuration - bDuration;
	});
};

export const getRoutesByDistance = async () => {
	return [...db().routes].sort((a, b) => a.distance - b.distance);
};

// STATION MODEL FUNCTIONS

export const getAllStations = async () => {
	return db().stations;
};

export const getStationById = async (stationId) => {
	return db().stations.find(station => station.id === stationId) || null;
};

export const getStationsByRegion = async (region) => {
	return db().stations.filter(station => station.region.toLowerCase() == region.toLowerCase());
};

export const getStationsByPrefecture = async (prefecture) => {
	return db().stations.filter(station => station.prefecture.toLowerCase() == prefecture.toLowerCase());
};

export const getStationsByFacility = async (facility) => {
	return db().stations.filter(station => station.facilities.includes(facility));
};

// SCHEDULE MODEL FUNCTIONS

export const getAllSchedules = async () => {
	return db().schedules;
};

export const getScheduleById = async (scheduleId) => {
	return db().schedules.find(schedule => schedule.id == scheduleId) || null;
};

export const getSchedulesByRoute = async (routeId) => {
	return db().schedules.filter(schedule => schedule.routeId == routeId);
};

export const getAvailableSchedulesByRoute = async (routeId) => {
	return db().schedules.filter(schedule => schedule.routeId == routeId && schedule.status == true);
};

export const getSchedulesByDay = async (day) => {
	return db().schedules.filter(schedule => schedule.daysOfWeek.includes(day.toLowerCase()));
};

export const getSchedulesByDepartureTime = async () => {
	return [...db().schedules].sort((a, b) => {
		return a.departureTime.localeCompare(b.departureTime);
	});
};

// TICKET CLASS MODEL FUNCTIONS

export const getAllTicketClasses = async () => {
	return db().ticketClasses;
};

export const getTicketClassByName = async (className) => {
	return db().ticketClasses.find(tc => tc.class.toLowerCase() == className.toLowerCase()) || null;
};

export const getTicketClassesByPrice = async () => {
	return [...db().ticketClasses].sort((a, b) => a.pricePerKm - b.pricePerKm);
};

// COMBINED/UTILITY MODEL FUNCTIONS

export const getRouteWithStations = async (routeId) => {
	const route = await getRouteById(routeId);
	if (!route) return null;

	const startStation = await getStationById(route.startStation);
	const endStation = await getStationById(route.endStation);

	return {
		...route,
		startStationDetails: startStation,
		endStationDetails: endStation
	};
};

export const getRouteWithSchedules = async (routeId) => {
	const route = await getRouteById(routeId);
	if (!route) return null;

	const routeSchedules = await getSchedulesByRoute(routeId);

	return {
		...route,
		schedules: routeSchedules
	};
};

export const getCompleteRouteDetails = async (routeId) => {
	const route = await getRouteById(routeId);
	if (!route) return null;

	const startStation = await getStationById(route.startStation);
	const endStation = await getStationById(route.endStation);
	const routeSchedules = await getSchedulesByRoute(routeId);

	return {
		...route,
		startStationDetails: startStation,
		endStationDetails: endStation,
		schedules: routeSchedules
	};
};

export const calculateTicketPrice = async (routeId, className) => {
	const route = await getRouteById(routeId);
	const ticketClass = await getTicketClassByName(className);

	if (!route || !ticketClass) return null;

	return route.distance * ticketClass.pricePerKm;
};

export const getTicketOptionsForRoute = async (routeId) => {
	const route = await getRouteById(routeId);
	if (!route) return null;

	return db().ticketClasses.map(tc => ({
		class: tc.class,
		name: tc.name,
		price: Math.round(yenToUsd(route.distance * tc.pricePerKm) * 100) / 100, // Round to 2 decimal places
		amenities: tc.amenities,
		description: tc.description
	}));
};

export const getTicketOptionsForSchedule = async (scheduleId) => {
	const schedule = await getScheduleById(scheduleId);
	if (!schedule) return null;

	return getTicketOptionsForRoute(schedule.routeId);
};

export const isRouteOperating = async (routeId) => {
	const route = await getRouteById(routeId);
	if (!route) return false;

	const currentMonth = new Date().getMonth() + 1;
	return route.operatingMonths.includes(currentMonth);
};

export const getScheduleWithRoute = async (scheduleId) => {
	const schedule = await getScheduleById(scheduleId);
	if (!schedule) return null;

	const route = await getRouteById(schedule.routeId);

	return {
		...schedule,
		routeDetails: route
	};
};

export const searchRoutes = async (keyword) => {
	const searchTerm = keyword.toLowerCase();
	return db().routes.filter(route => {
		return (
			route.name.toLowerCase().includes(searchTerm) ||
			route.description.toLowerCase().includes(searchTerm) ||
			route.highlights.some(highlight => highlight.toLowerCase().includes(searchTerm))
		);
	});
};

// CONFIRMATION MODEL FUNCTIONS

export const createConfirmation = async (confirmationData) => {
	const dbObj = db();
	const newConfirmation = {
		id: generateConfirmationCode(),
		createdAt: new Date().toISOString(),
		...confirmationData
	};

	// Auto-saves via Proxy
	dbObj.confirmations = [...dbObj.confirmations, newConfirmation];

	return newConfirmation.id;
};

export const getConfirmationById = async (confirmationId) => {
	return db().confirmations.find(conf => conf.id === confirmationId) || null;
};

export const getAllConfirmations = async () => {
	return db().confirmations;
};