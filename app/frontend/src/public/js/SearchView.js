import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Busca de Exames por Token");
  }

  getHtml() {
    const fragment = new DocumentFragment();

    const heading1 = document.createElement('h1');
    heading1.innerText = 'Busca de Exames por Token'

    const form = document.createElement('form');
    form.role = 'search';
    form.innerHTML = `
      <input type="search" id="token" name="token" placeholder="Busca por Token" aria-label="Pesquisa de Exames por Token" required>
      <input type="submit" value="Pesquisar">
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
            const table = this.createTable(data);
            app.appendChild(table);
          });
      }
    });

    fragment.appendChild(heading1);
    fragment.appendChild(form);

    return Promise.resolve(fragment);
  }
}