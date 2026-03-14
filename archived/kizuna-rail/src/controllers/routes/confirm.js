import { getConfirmationById } from "../../models/model.js";

export default async (req, res) => {
    const { confirmationId } = req.params;

    const confirmation = await getConfirmationById(confirmationId);

    res.render("routes/confirm", {
        title: "Trip Confirmation",
        confirmation
    });
};