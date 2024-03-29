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
    
    return new Promise((resolve, _reject) => {
      fetch(this.URL)
        .then((response) => {
          if (response.status === 404) {
            notice.classList.add('alert', 'alert-warning');
            notice.innerText = 'Não há exames cadastrados.'
            return response.json();
          }
          if (response.status === 500) throw new Error('An error has ocurred. Try again');
          return response.json();
        })
        .then((data) => {
          if (data.length) {
            const table = this.createTable(data);
            fragment.appendChild(heading1);
            fragment.appendChild(table);
          }
        })
        .catch((error) => {
          console.error(error.message);
          notice.classList.remove('alert', 'alert-warning', 'alert-success', 'alert-danger');
          notice.classList.add('alert', 'alert-danger');
          notice.innerText = 'Não foi possível completar sua ação. Tente novamente';
        })
        .finally(() => resolve(fragment));
    })
  }

  createTable(exams) {
    const tableHTML = `
      <caption>Exames médicos</caption>
      
      <thead>
        <tr class="table-header">
          <th scope="col">Token</th>
          <th scope="col">Data do Exame</th>
          <th scope="col">CPF</th>
          <th scope="col">Nome</th>
          <th scope="col">Cidade</th>
          <th scope="col">Estado</th>
          <th scope="col">Nome do Médico</th>
          <th scope="col">CRM do Médico</th>
        </tr>
      </thead>
    `;
    const table = document.createElement('table');
    table.classList.add('table', 'table-hover');
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
