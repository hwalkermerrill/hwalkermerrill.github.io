import { getAllRoutes, getListOfRegions, getListOfSeasons } from "../../models/model.js";

export default async (req, res) => {
    // Constants
    const regions = await getListOfRegions();
    const routes = await getAllRoutes();
    const seasons = await getListOfSeasons();
    const regionQuery = req.query.region || "All";
    const seasonQuery = req.query.season || "All";

    // Filter routes logic
    let filteredRoutes = routes;

    if (regionQuery !== "All") {
        filteredRoutes = filteredRoutes.filter(route => route.region === regionQuery);
    }

    if (seasonQuery !== "All") {
        filteredRoutes = filteredRoutes.filter(route => route.bestSeason === seasonQuery);
    }

    res.render("routes/list", {
        title: "Scenic Train Routes",
        regions,
        routes: filteredRoutes,
        seasons
    });
};