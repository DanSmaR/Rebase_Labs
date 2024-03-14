import ExamsView from "./ExamsView.js";
import HomeView from "./HomeView.js";
import SearchView from "./SearchView.js";

const navigateTo = url => {
  history.pushState(null, null, url);
  router();
};

const router = () => {
  const routes = [
    { path: "/", view: HomeView },
    { path: "/exams", view: ExamsView },
    { path: "/search", view: SearchView },
  ];

  const routesMatches = routes.map(route => {
    return {
      route,
      isMatch: location.pathname == route.path
    }
  });

  let match = routesMatches.find(routeMatch => routeMatch.isMatch);

  if (!match) {
    match = {
      route: routes[0],
      isMatch: true
    };
  }

  const view = new match.route.view();
  
  view.getHtml()
    .then(html => {
      app = document.querySelector("#app");
      while (app.firstChild) {
        app.removeChild(app.firstChild);
      }
      app.appendChild(html);
    })
};

window.addEventListener('popstate', router);

document.addEventListener("DOMContentLoaded", () => {
  document.body.addEventListener("click", e => {
    if (e.target.matches("[data-link]")) {
      e.preventDefault();
      navigateTo(e.target.href);
    }
  });
  router();
})