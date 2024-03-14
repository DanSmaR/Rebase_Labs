import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Detalhes do Exame Médico");
  }

  getHtml() {
    const fragment = new DocumentFragment();
    
    return new Promise((resolve, reject) => {
      fetch(this.URL + `?token=${this.params.token}`)
        .then((response) => response.json())
        .then((data) => {
          const descriptionList = this.createExamsDescriptionList(data);
          const tableTests = this.createTestsTable(data);

          fragment.appendChild(descriptionList);
          fragment.appendChild(tableTests);

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

  createExamsDescriptionList(exams) {
    const fragment = new DocumentFragment();

    const heading1 = document.createElement('h1');

    const examDate = new Date(exams[0].exam_date);
    
    heading1.innerHTML = `Detalhe Exame Médico ${exams[0].token} feito em <time datetime="${exams[0].exam_date}">${examDate.toLocaleDateString('pt-BR')}</time>`;
    
    const descriptionList = document.createElement('dl');
      
    descriptionList.innerHTML = `
      <dt>CPF</dt>
      <dd>${exams[0].cpf}</dd>
      <dt>Nome</dt>
      <dd>${exams[0].name}</dd>
      <dt>E-mail</dt>
      <dd>${exams[0].email}</dd>
      <dt>Data de Nascimento</dt>
      <dd>${exams[0].birthday}</dd>
      <dt>Endereço</dt>
      <dd>${exams[0].address}</dd>
      <dt>Cidade</dt>
      <dd>${exams[0].city}</dd>
      <dt>Estado</dt>
      <dd>${exams[0].state}</dd>
      <dt>Médico</dt>
      <dd>${exams[0].doctor.name}</dd>
      <dt>E-mail do Médico</dt>
      <dd>${exams[0].doctor.email}</dd>
      <dt>CRM do Médico</dt>
      <dd>${exams[0].doctor.crm}</dd>
      <dt>CRM Estado</dt>
      <dd>${exams[0].doctor.crm_state}</dd>
    `;

    fragment.appendChild(heading1);
    fragment.appendChild(descriptionList);

    return fragment;
  }


  createTestsTable(exams) {
    const tableHead = `
      <caption>Detalhes dos testes do exame</caption>
      
      <thead>
        <tr>
          <td>Tipo de Exame</td>
          <td>Limites</td>
          <td>Resultado</td>
        </tr>
      </thead>
      `;
      const table = document.createElement('table');
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
