import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Lista de Exames Médicos");
  }

  getHtml() {
    const fragment = new DocumentFragment();
    
    const heading1 = document.createElement('h1');
    heading1.innerText = 'Exames Médicos'
    
    return new Promise((resolve, reject) => {
      fetch(this.URL)
        .then((response) => response.json())
        .then((data) => {
          const table = this.createTable(data);

          fragment.appendChild(heading1);
          fragment.appendChild(table);

          resolve(fragment);
        })
        .catch((error) => {
          console.log(error);
          const errorMsgTitle = document.createElement('h2');
          errorMsgTitle.innerText = 'Erro!';

          const errorMsgContent = document.createElement('p');
          errorMsgContent.innerText = 'Sua solicitação não pode ser efetuada no momento. Tente Mais Tarde';

          fragment.appendChild(errorMsgTitle);
          fragment.appendChild(errorMsgContent);
          reject(fragment);
        });
    })
  }
}
