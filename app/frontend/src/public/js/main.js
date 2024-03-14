import ExamsView from "./ExamsView.js";
import HomeView from "./HomeView.js";
import SearchView from "./SearchView.js";

const importCSVBtn = document.getElementById('import-csv-btn');
const notice = document.getElementById('notice');

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