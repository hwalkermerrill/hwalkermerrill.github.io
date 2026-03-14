const homePage = (req, res) => {
    res.render("home", { title: "Kizuna Rail" });
};

const aboutPage = (req, res) => {
    res.render("about", { title: "About" });
};

const testErrorPage = (req, res, next) => {
    const err = new Error("This is a test error so you can see what it looks like.");
    err.status = 500;
    next(err);
};

export { homePage, aboutPage, testErrorPage };