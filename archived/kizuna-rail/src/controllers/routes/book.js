import { createConfirmation, getScheduleById, getTicketOptionsForRoute } from "../../models/model.js";

const bookingPage = async (req, res) => {
	const { scheduleId } = req.params;
	const schedule = await getScheduleById(scheduleId);
	const ticketOptions = await getTicketOptionsForRoute(schedule.routeId, scheduleId);

	res.render("routes/book", {
		title: "Book Trip",
		schedule,
		ticketOptions
	});
};

const processBookingRequest = async (req, res) => {
	const data = req.body;
	const confirmationNum = await createConfirmation(data);

	res.redirect(`/routes/confirmation/${confirmationNum}`);
};

export { bookingPage, processBookingRequest };