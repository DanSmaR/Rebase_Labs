export default class {
  URL = '/data';

  setTitle(title) {
      document.title = title;
  }

  createTable(exams) {
    const tableHTML = `
      <caption>Tabela com informações detalhadas sobre todos os exames médicos efetuados</caption>
      
      <thead>
        <tr>
          <td>Token</td>
          <td>Data do Exame</td>
          <td>CPF</td>
          <td>Nome</td>
          <td>E-mail</td>
          <td>Data de Nascimento</td>
          <td>Endereço</td>
          <td>Cidade</td>
          <td>Estado</td>
          <td>Nome do Médico</td>
          <td>E-mail do Médico</td>
          <td>CRM do Médico</td>
          <td>CRM Estado</td>
          <td>Tipo de Exame</td>
          <td>Limites</td>
          <td>Resultado</td>
        </tr>
      </thead>
    `;
    const table = document.createElement('table');
    table.innerHTML = tableHTML;
    const tableBody = document.createElement('tbody');

    exams.forEach(exam => {
      const patientRow = document.createElement('tr');
        patientRow.innerHTML = `
          <td>${exam.token}</td>
          <td>${exam.exam_date}</td>
          <td>${exam.cpf}</td>
          <td>${exam.name}</td>
          <td>${exam.email}</td>
          <td>${exam.birthday}</td>
          <td>${exam.address}</td>
          <td>${exam.city}</td>
          <td>${exam.state}</td>
          <td>${exam.doctor.name}</td>
          <td>${exam.doctor.email}</td>
          <td>${exam.doctor.crm}</td>
          <td>${exam.doctor.crm_state}</td>
        `;
        tableBody.appendChild(patientRow);

        exam.tests.forEach(test => {
          const examRow = document.createElement('tr');
          examRow.innerHTML = `
            <td colspan="13"></td>
            <td>${test.type}</td>
            <td>${test.limits}</td>
            <td>${test.result}</td>
          `;
          tableBody.appendChild(examRow);
        });
    });

    table.appendChild(tableBody);
    return table;
  }
}