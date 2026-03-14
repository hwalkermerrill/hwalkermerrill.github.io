// GLOBAL MIDDLEWARE HERE
const setHeadAssetsFunctionality = (res) => {
  // Adds asset management to the routes, including css and js with priority
  res.locals.styles = [];
  res.locals.scripts = [];

  // res.addStyle(css, priority) - Add CSS/link tags
  res.addStyle = (css, priority = 0) => {
    res.locals.styles.push({ content: css, priority });
  };

  // res.addScript(js, priority) - Add script tags 
  res.addScript = (js, priority = 0) => {
    res.locals.scripts.push({ content: js, priority });
  };

  // These functions will be available in EJS templates
  res.locals.renderStyles = () => {
    return res.locals.styles
      // Sort by priority: higher numbers load first
      .sort((a, b) => b.priority - a.priority)
      .map(item => item.content)
      .join("\n");
  };

  res.locals.renderScripts = () => {
    return res.locals.scripts
      // Sort by priority: higher numbers load first
      .sort((a, b) => b.priority - a.priority)
      .map(item => item.content)
      .join("\n");
  };
};
const addLocalVariables = (req, res, next) => {
  // Set local variables
  const now = new Date();
  // const hour = now.getHours();
  const versionIteration = "v1.1.";
  // const themes = ["blue-theme", "green-theme", "red-theme"];
  // const randomTheme = t]
  // themes[Math.floor(Math.random() * themes.length)];
  const activePage = req.path.split("/")[1] || "home";

  // Set greetings in Japanese and English based on Time
  // const greeting =
  //   hour < 5 ? { jp: "Nande Okiteru No!?", en: "Why Are You Awake!?" } :
  //     hour < 12 ? { jp: "Ohayo Gozaimasu!", en: "Good Morning" } :
  //       hour < 18 ? { jp: "Konnichiwa!", en: "Good Day" } :
  //         { jp: "Konbanwa!", en: "Good Evening" };

  // Make following variables available to all templates
  res.locals.NODE_ENV = process.env.NODE_ENV?.toLowerCase() || "production";
  res.locals.currentDate = now;
  res.locals.currentYear = now.getFullYear();
  res.locals.queryParams = { ...req.query };
  // res.locals.greetingJP = greeting.jp;
  // res.locals.greetingEN = greeting.en;
  // res.locals.bodyClass = randomTheme;
  res.locals.versionNumber = `${versionIteration}${now.getFullYear().toString().slice(2)}${(now.getMonth() + 1).toString().padStart(2, "0")}`;
  res.locals.activePage = activePage;

  // DO NOT REMOVE, NOT DUPLICATE: Used for conditional rendering
  res.locals.isLoggedIn = false;
  if (req.session && req.session.user) {
    res.locals.isLoggedIn = true;
  }

  setHeadAssetsFunctionality(res);

  next();
};
const devLogs = (req, res, next) => {
  // Logs to terminal while in development mode
  const isDev = res.locals.NODE_ENV === "development";

  if (isDev && !req.path.startsWith("/.")) {
    console.log(`${req.method} ${req.url}`);
  }
  res.on("finish", () => {
    if (!isDev) return;

    if (Object.keys(req.query).length > 0) {
      console.log("Query:", req.query);
    }
    if (Object.keys(req.params).length > 0) {
      console.log("Params:", req.params);
    }
    console.log(`Response Status: ${res.statusCode}`);
  });

  next();
};

export { addLocalVariables, devLogs };