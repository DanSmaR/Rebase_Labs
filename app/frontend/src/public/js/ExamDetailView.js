import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Detalhes do Exame Médico");
  }

  getHtml() {
    const fragment = new DocumentFragment();

    return new Promise((resolve, _reject) => {
      fetch(this.URL + `?token=${this.params.token}`)
        .then((response) => {
          if (response.status === 500) throw new Error('An error has ocurred. Try again');
          return response.json();
        })
        .then((data) => {
          const descriptionList = this.createExamsDescriptionList(data);
          const tableTests = this.createTestsTable(data);

          fragment.appendChild(descriptionList);
          fragment.appendChild(tableTests);
        })
        .catch((error) => {
          console.error(error);
          notice.classList.remove('alert', 'alert-warning', 'alert-success', 'alert-danger');
          notice.classList.add('alert', 'alert-danger');
          notice.innerText = 'Não foi possível completar sua ação. Tente novamente';
        })
        .finally(() => resolve(fragment));
    })
  }

  createExamsDescriptionList(exams) {
    const fragment = new DocumentFragment();

    const heading1 = document.createElement('h1');

    const examDate = new Date(exams[0].exam_date);
    
    heading1.innerHTML = "Detalhe Exame Médico";
    
    const containerList = document.createElement('div');
    containerList.classList.add('card');

    containerList.innerHTML = `
      <h3 class="detail-exam-title">Exame ${exams[0].token} feito em <time datetime="${exams[0].exam_date}">${examDate.toLocaleDateString('pt-BR')}</time></h3>
      <dl class="card-body">
        <dt class="card-subtitle mb-2 text-body-secondary">CPF</dt>
        <dd class="detail-exam-data">${exams[0].cpf}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Nome</dt>
        <dd class="detail-exam-data">${exams[0].name}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">E-mail</dt>
        <dd class="detail-exam-data">${exams[0].email}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Data de Nascimento</dt>
        <dd class="detail-exam-data">${exams[0].birthday}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Endereço</dt>
        <dd class="detail-exam-data">${exams[0].address}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Cidade</dt>
        <dd class="detail-exam-data" class="card-subtitle mb-2 text-body-secondary">${exams[0].city}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Estado</dt>
        <dd class="detail-exam-data">${exams[0].state}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">Médico</dt>
        <dd class="detail-exam-data">${exams[0].doctor.name}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">E-mail do Médico</dt>
        <dd class="detail-exam-data">${exams[0].doctor.email}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">CRM do Médico</dt>
        <dd class="detail-exam-data">${exams[0].doctor.crm}</dd>
        <dt class="card-subtitle mb-2 text-body-secondary">CRM Estado</dt>
        <dd class="detail-exam-data">${exams[0].doctor.crm_state}</dd>
      </dl>
    `;

    fragment.appendChild(heading1);
    fragment.appendChild(containerList);

    return fragment;
  }

  createTestsTable(exams) {
    const tableHead = `
      <caption>Detalhes dos testes do exame</caption>
      
      <thead>
        <tr>
          <th scope="col">Tipo de Exame</th>
          <th scope="col">Limites</th>
          <th scope="col">Resultado</th>
        </tr>
      </thead>
      `;

      const table = document.createElement('table');
      table.classList.add('table', 'table-hover');
      table.innerHTML = tableHead;
      const tableBody = document.createElement('tbody');
      
      exams[0].tests.forEach(test => {
        const examRow = document.createElement('tr');
        examRow.innerHTML = `
          <td>${test.type}</td>
          <td>${test.limits}</td>
          <td>${test.result}</td>
        `;
        tableBody.appendChild(examRow);
    });

    table.appendChild(tableBody);
    return table;
  }
}
