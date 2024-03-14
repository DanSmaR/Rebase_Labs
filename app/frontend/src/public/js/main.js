import ExamsView from "./ExamsView.js";
import ExamDetailView from "./ExamDetailView.js";
import HomeView from "./HomeView.js";
import SearchView from "./SearchView.js";

const importCSVBtn = document.getElementById('import-csv-btn');
const notice = document.getElementById('notice');

const pathToRegex = path => new RegExp("^" + path.replace(/\//g, "\\/").replace(/:\w+/g, "(.+)") + "$");

const getParams = match => {
  const values = match.result.slice(1);
  const keys = Array.from(match.route.path.matchAll(/:(\w+)/g)).map(result => result[1]);

  return Object.fromEntries(keys.map((key, i) => {
      return [key, values[i]];
  }));
};

const navigateTo = url => {
  history.pushState(null, null, url);
  router();
};

const router = () => {
  notice.classList.remove('success', 'invalid', 'error');
  notice.innerText = '';

  const routes = [
    { path: "/", view: HomeView },
    { path: "/exams", view: ExamsView },
    { path: "/exams/:token", view: ExamDetailView },
    { path: "/search", view: SearchView },
  ];

  const routesMatches = routes.map(route => {
    return {
      route,
      result: location.pathname.match(pathToRegex(route.path))
    }
  });

  let match = routesMatches.find(routeMatch => routeMatch.result != null);

  if (!match) {
    match = {
      route: routes[0],
      result: [location.pathname]
    };
  }

  const view = new match.route.view(getParams(match));
  
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

importCSVBtn.addEventListener('click', (ev) => {
  ev.preventDefault();

  const fileInput = document.getElementById('csv-file');
  const file = fileInput.files[0];
  const formData = new FormData();

  formData.append('csvFile', file);

  fetch('/upload', {
    method: 'POST',
    body: formData
  })
  .then(response => response.json())
  .then(data => {
    console.log(data);

    if (data.success) {
      notice.classList.add('success');
      notice.innerText = 'Arquivo enviado com sucesso!';
      document.getElementById('csv-file').value = '';
    } else if (data.success === false) {
      notice.classList.add('invalid');
      notice.innerText = 'Arquivo não selecionado ou inválido!'
    } else if (data.error) {
      notice.classList.add('error');
      notice.innerText = 'Erro ao enviar arquivo! Tente novamente.';
    }
  })
  .catch(error => {
    console.error('Error:', error);
    notice.classList.add('error');
    notice.innerText = 'Erro ao enviar arquivo! Tente novamente.';
  });
});