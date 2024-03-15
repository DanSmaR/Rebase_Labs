import AbstractView from "./AbstractView.js";
import ExamDetailView from "./ExamDetailView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Busca de Exames por Token");
    this.examDetailView = new ExamDetailView(params);
  }

  getHtml() {
    const fragment = new DocumentFragment();

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
      
      app = document.querySelector("#app");
      
      const oldTable = document.querySelector('table');

      if (oldTable) {
        app.removeChild(oldTable);
      }

      const token = document.getElementById('token').value;

      if (token) {
        fetch(this.URL + `?token=${token}`)
          .then((response) => response.json())
          .then((data) => {
            const descriptionList = this.examDetailView.createExamsDescriptionList(data);
            const tableTests = this.examDetailView.createTestsTable(data);
            app.appendChild(descriptionList);
            app.appendChild(tableTests);
          });
      }
    });

    fragment.appendChild(heading1);
    fragment.appendChild(form);

    return Promise.resolve(fragment);
  }
}