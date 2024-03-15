import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Página Inicial - Exames Médicos")
  }

  getHtml() {
    const fragment = new DocumentFragment();

    const heading1 = document.createElement('h1');
    heading1.innerText = 'Exames Médicos';

    const contentOne = document.createElement('p');
    contentOne.innerText = 'Navegue pela nosso site pelos menus acima';

    const examsLink = document.createElement('p');
    examsLink.innerHTML = 'Acesse todos os <a href="/exams">exames</a> cadastrados';

    const searchLink = document.createElement('p');
    searchLink.innerHTML = '<a href="/search">Busque por um exame específico</a> passando um token no campo de busca';

    fragment.appendChild(heading1);
    fragment.appendChild(contentOne);
    fragment.appendChild(examsLink);
    fragment.appendChild(searchLink);

    return Promise.resolve(fragment);
  }
}