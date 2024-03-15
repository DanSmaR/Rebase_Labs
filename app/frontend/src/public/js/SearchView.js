import AbstractView from "./AbstractView.js";
import ExamDetailView from "./ExamDetailView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Busca de Exames por Token");
    this.examDetailView = new ExamDetailView(params);
  }

  getHtml() {
    // const notice = document.getElementById('notice');
    // notice.role = 'alert'

    const fragment = new DocumentFragment();
    const article = document.createElement('article');
    article.classList.add('exam-data');

    const heading1 = document.createElement('h1');
    heading1.innerText = 'Busca de Exames por Token'

    const form = document.createElement('form');
    form.role = 'search';
    form.innerHTML = `
      <div class="input-group mb-3">
        <input type="search" class="form-control" id="token" name="token" placeholder="Busca por Token" aria-label="Pesquisa de Exames por Token" required>
        <button type="submit" class="btn btn-outline-secondary">Pesquisar</button>
      </div>
    `;

    form.addEventListener('submit', (event) => {
      event.preventDefault();

      notice.classList.remove('alert', 'alert-warning', 'alert-success', 'alert-danger');
      notice.innerText = "";
      
      app = document.querySelector("#app");
      
      const examData = document.querySelector('.exam-data');

      if (examData) {
        while(examData.firstChild) {
          examData.removeChild(examData.firstChild);
        }
        app.removeChild(examData);
      }

      const inputSearch = document.getElementById('token');
      const token = inputSearch.value;
      inputSearch.value = "";

      if (token) {
        fetch(this.URL + `?token=${token}`)
          .then((response) => response.json())
          .then((data) => {
            if (data.length == 0) {
              notice.classList.add('alert', 'alert-warning');
              notice.innerText = 'Exame não encontrado.'
            } else {
              const descriptionList = this.examDetailView.createExamsDescriptionList(data);
              const tableTests = this.examDetailView.createTestsTable(data);
              article.appendChild(descriptionList)
              article.appendChild(tableTests)
              app.appendChild(article);
            }
          })
          .catch(error => {
            console.error(error);
            notice.classList.remove('alert', 'alert-warning', 'alert-success', 'alert-danger');
            notice.classList.add('alert', 'alert-danger');
            notice.innerText = 'Não foi possível completar sua ação. Tente novamente';
          });
      }
    });

    fragment.appendChild(heading1);
    fragment.appendChild(form);

    return Promise.resolve(fragment);
  }
}