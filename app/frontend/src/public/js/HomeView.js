import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor() {
    super();
    this.setTitle("Página Inicial - Exames Médicos")
  }

  getHtml() {
    const fragment = new DocumentFragment();

    const heading1 = document.createElement('h1');
    heading1.innerText = 'Exames Médicos';

    const content = document.createElement('p');
    content.innerText = 'Acesse os exames cadastrados em nossa base de dados pelo menu acima';

    fragment.appendChild(heading1);
    fragment.appendChild(content);

    return Promise.resolve(fragment);
  }
}