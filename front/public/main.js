document.getElementById('fileInput').addEventListener('change', async function() {
  const fileInput = document.getElementById('fileInput');
  const file = fileInput.files[0];
  const formData = new FormData();
  formData.append('file', file);
  try {
    const response = await fetch('http://localhost:3000/api/import', {
      method: 'POST',
      body: formData
    });
    alert('Arquivo importado com sucesso');
    location.reload();
  } catch {
    alert('Erro ao importar arquivo');
  }
});

const fetchData = async () => {
  try {
    const response = await fetch('http://localhost:3000/api/tests');
    const data = await response.json();
    return data;
  } catch {
    return [];
  }
};

document.getElementById('search').addEventListener('input', function(event) {
    const trs = document.querySelectorAll('tbody tr');
    trs.forEach(tr => {
      const tds = tr.querySelectorAll('td');
      let found = false;
      tds.forEach(td => {
        let value = event.target.value.trim();
        if (td.textContent.includes(value.toUpperCase()) || td.textContent.includes(value)) {
          found = true;
        }
      });
      if (found) {
        tr.style.display = '';
      } else {
        tr.style.display = 'none';
      }
    });
  }
);

const createTable = (data) => {
  if (data.length === 0) {
    const main = document.querySelector('main');
    const title = document.createElement('h2');
    title.textContent = 'Nenhum exame encontrado';
    main.appendChild(title);
    return;
  }
  const main = document.querySelector('main');
  const table = document.createElement('table');
  main.appendChild(table);
  const thead = document.createElement('thead');
  thead.innerHTML = `
    <tr>
      <th>Token</th>
      <th>Data</th>
      <th>Paciente</th>
      <th>CPF</th>
      <th>Médico</th>
    </tr>
  `;
  const tbody = document.createElement('tbody');
  data.forEach(exam => {

    const tr = document.createElement('tr');

    tr.innerHTML = `
      <td class="exams-table">${exam.result_token}</td>
      <td class="exams-table">${new Date(exam.result_date).toLocaleDateString()}</td>
      <td class="exams-table">${exam.patient_name}</td>
      <td class="exams-table">${exam.cpf}</td>
      <td class="exams-table">${exam.doctor.name}</td>
    `;

    tr.addEventListener('click', function() {
      getExamData(exam.result_token);
    });

    tbody.appendChild(tr);
  });
  table.appendChild(thead);
  table.appendChild(tbody);
};

fetchData()
  .then(data => createTable(data));


getExamData = async (token) => {
  try {
    const response = await fetch(`http://localhost:3000/api/tests/${token}`);
    const data = await response.json();
    console.log(data);
    const modal = document.querySelector('.modal');
    modal.style.display = 'block';
    const modalContent = document.querySelector('.modal-content');
    modalContent.innerHTML = `
      <span class="close">&times;</span>

      <table>
        <thead>
          <tr>
            <th>Exame</th>
            <th>Data</th>
            <th>Paciente</th>
            <th>Médico</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>${data.result_token}</td>
            <td>${new Date(data.result_date).toLocaleDateString()}</td>
            <td class="exams-description">
              <p>nome: ${data.patient_name}</p>
              <p>cpf: ${data.cpf}</p>
              <p>nascimento: ${new Date(data.birthdate).toLocaleDateString()}</p>
              <p>e-mail: ${data.email}</p>
            </td>
            <td>
              <p>nome: ${data.doctor.name}</p>
              <p>crm: ${data.doctor.crm} | ${data.doctor.crm_state}</p>
            </td>
          </tr>
        </tbody>
      </table>
      <table>
        <thead>
          <tr>
            <th>Tipo</th>
            <th>Valor de referência</th>
            <th>Resultado</th>
          </tr>
        </thead>
        <tbody>
          ${data.tests.map(exam => {
            const result = exam.result;
            const limits = exam.limits.split('-');
            const cor = (Number(result) >= Number(limits[0]) && Number(result) <= Number(limits[1])) ? 'green' : 'red';
            return `
              <tr>
                <td>${exam.type}</td>
                <td>${exam.limits}</td>
                <td style="color: ${cor}"> ${exam.result}</td>
              </tr>
            `;
          }
        ).join('')}
        </tbody>
      </table>
    `;
    const close = document.querySelector('.close');
    close.addEventListener('click', function() {
      modal.style.display = 'none';
    });
    window.addEventListener('click', function(event) {
      if (event.target === modal) {
        modal.style.display = 'none';
      }
    });

  } catch (error) {
    console.log(error);
  }
};
