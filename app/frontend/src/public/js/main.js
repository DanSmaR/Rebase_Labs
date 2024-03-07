const fragment = new DocumentFragment();
const URL = 'http://localhost:3001/tests'

fetch(URL)
  .then((response) => response.json())
  .then((data) => {
    console.log(data);
    
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
  })
  .then(() => {
    document.querySelector('#app').appendChild(fragment);
  })
  .catch((error) => console.log(error));
  