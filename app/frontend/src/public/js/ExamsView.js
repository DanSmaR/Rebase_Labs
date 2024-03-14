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

  createTable(exams) {
    const tableHTML = `
      <caption>Exames médicos</caption>
      
      <thead>
        <tr>
          <td>Token</td>
          <td>Data do Exame</td>
          <td>CPF</td>
          <td>Nome</td>
          <td>Cidade</td>
          <td>Estado</td>
          <td>Nome do Médico</td>
          <td>CRM do Médico</td>
        </tr>
      </thead>
    `;
    const table = document.createElement('table');
    table.innerHTML = tableHTML;
    const tableBody = document.createElement('tbody');

    exams.forEach(exam => {
      const examRow = document.createElement('tr');
      examRow.innerHTML = `
          <td><a href="/exams/${exam.token}">${exam.token}</a></td>
          <td>${exam.exam_date}</td>
          <td>${exam.cpf}</td>
          <td>${exam.name}</td>
          <td>${exam.city}</td>
          <td>${exam.state}</td>
          <td>${exam.doctor.name}</td>
          <td>${exam.doctor.crm}</td>
        `;
        tableBody.appendChild(examRow);
    });

    table.appendChild(tableBody);
    return table;
  }
}
