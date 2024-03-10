import AbstractView from "./AbstractView.js";

export default class extends AbstractView {
  URL = 'http://localhost:3001/tests'
  
  constructor(params) {
    super(params);
    this.setTitle("Lista de Exames Médicos");
  }

  getHtml() {
    const fragment = new DocumentFragment();
    
    const heading1 = document.createElement('h1');
    heading1.innerText = 'Exames Médicos'
    
    const tableHTML = `
      <caption>Tabela com informações detalhadas sobre todos os exames médicos efetuados</caption>
      
      <thead>
        <tr>
          <td>CPF</td>
          <td>Nome</td>
          <td>E-mail</td>
          <td>Data de Nascimento</td>
          <td>Endereço</td>
          <td>Cidade</td>
          <td>Estado</td>
          <td>CRM do Médico</td>
          <td>CRM Estado</td>
          <td>Token</td>
          <td>Data do Exame</td>
          <td>Tipo de Exame</td>
          <td>Limites</td>
          <td>Resultado</td>
        </tr>
      </thead>
    `
    const table = document.createElement('table')
    table.innerHTML = tableHTML;

    const tableBody = document.createElement('tbody');
    
    return new Promise((resolve, reject) => {
      fetch(this.URL)
        .then((response) => response.json())
        .then((data) => {
          data.forEach(exam => {
            const tableRow = document.createElement('tr');
            tableRow.innerHTML = `
              <td>${exam.cpf}</td>
              <td>${exam.name}</td>
              <td>${exam.email}</td>
              <td>${exam.birth_date}</td>
              <td>${exam.address}</td>
              <td>${exam.city}</td>
              <td>${exam.state}</td>
              <td>${exam.crm}</td>
              <td>${exam.crm_state}</td>
              <td>${exam.token}</td>
              <td>${exam.exam_date}</td>
              <td>${exam.exam_type}</td>
              <td>${exam.exam_limits}</td>
              <td>${exam.exam_result}</td>
            `

            tableBody.appendChild(tableRow);
          });
        
          table.appendChild(tableBody);
          
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
