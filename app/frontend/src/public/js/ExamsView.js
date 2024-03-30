import AbstractView from "./AbstractView.js";
import { updateHTML } from "./main.js"
export default class extends AbstractView {
  constructor(params) {
    super(params);
    this.setTitle("Lista de Exames Médicos");
  }

  getHtml(page = 1) {
    const fragment = new DocumentFragment();
    
    const heading1 = document.createElement('h1');
    heading1.innerText = 'Exames Médicos'
    
    return new Promise((resolve, _reject) => {
      fetch(`${this.URL}?page=${page}`)
        .then((response) => {
          if (response.status === 500) throw new Error('An error has ocurred. Try again');
          if (response.status === 404) {
            notice.classList.add('alert', 'alert-warning');
            notice.innerText = 'Não há exames cadastrados.'
          }
          return response.json();
        })
        .then((data) => {
          console.log(data);
          if (data.results.length) {
            const table = this.createTable(data.results);
            const paginationHeader = this.createPagination(data.total_pages, data.previous, data.next);
            paginationHeader.classList.add('pagination-top');
            const paginationFooter = this.createPagination(data.total_pages, data.previous, data.next);
            paginationFooter.classList.add('pagination-bottom');

            fragment.appendChild(heading1);
            fragment.appendChild(paginationHeader);
            fragment.appendChild(table);
            fragment.appendChild(paginationFooter);
          }
        })
        .catch((error) => {
          console.error(error.message);
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

  createPagination(total_pages, previous, next) {
    const pagination = document.createElement('nav');
    pagination.ariaLabel = 'Exams pages navigation';

    const paginationContainerList = document.createElement('ul');
    paginationContainerList.classList.add('pagination', 'justify-content-center');

    const btnPreviousPageListWrapper = this.createOutterRelativePaginationBtns(
      'Anterior', previous ? previous.page : null, !previous
    );
    paginationContainerList.appendChild(btnPreviousPageListWrapper);

    this.createPagesBtnsNavigation(total_pages, previous, paginationContainerList);

    const btnNextPageListWrapper = this.createOutterRelativePaginationBtns(
      'Próximo', next ? next.page : null, !next
    );
    paginationContainerList.appendChild(btnNextPageListWrapper);
    
    pagination.appendChild(paginationContainerList);
    return pagination;
  }

  createPagesBtnsNavigation(total_pages, previous, paginationContainerList) {
    for (let i = 1; i <= total_pages; i++) {
      const pageListBtnWrapper = document.createElement('li');
      pageListBtnWrapper.className = 'page-item';

      if ((previous && i === previous.page + 1) || (!previous && i === 1)) {
        pageListBtnWrapper.classList.add('active');
        pageListBtnWrapper.ariaCurrent = `page ${i}`;
      }

      const button = document.createElement('button');
      button.className = 'page-link';
      button.innerText = i;
      button.addEventListener('click', (ev) => {
        ev.preventDefault();
        this.updateExamsPage(i);
      });

      pageListBtnWrapper.appendChild(button);
      paginationContainerList.appendChild(pageListBtnWrapper);
    }
  }

  createOutterRelativePaginationBtns(label, page, disabled) {
    const btnListWrapper = document.createElement('li');
    btnListWrapper.className = 'page-item';

    const button = document.createElement('button');
    button.className = 'page-link';
    button.innerText = label;

    if (disabled) {
      btnListWrapper.classList.add('disabled');
      button.setAttribute('disabled', 'true');
    } else {
      button.addEventListener('click', (ev) => {
        ev.preventDefault();
        this.updateExamsPage(page);
      });
    }

    btnListWrapper.appendChild(button);
    return btnListWrapper;
  }

  updateExamsPage(page) {
    this.getHtml(page)
      .then(updateHTML);
  }
}
