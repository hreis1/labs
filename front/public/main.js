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

    const tdToken = document.createElement('td');
    tdToken.textContent = exam.result_token;
    tdToken.classList.add('token');
    tr.appendChild(tdToken);
    
    const tdResultDate = document.createElement('td');
    tdResultDate.textContent = new Date(exam.result_date).toLocaleDateString();
    tr.appendChild(tdResultDate);

    const tdPatientName = document.createElement('td');
    tdPatientName.textContent = exam.patient_name;
    tr.appendChild(tdPatientName);

    const tdCpf = document.createElement('td');
    tdCpf.textContent = exam.cpf;
    tr.appendChild(tdCpf);

    const tdDoctor = document.createElement('td');
    tdDoctor.textContent = exam.doctor.name;
    tr.appendChild(tdDoctor);

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
      <h2>Exame: ${data.result_token}</h2>
      <p><strong>Data:</strong> ${new Date(data.result_date).toLocaleDateString()}</p>
      <p><strong>Paciente:</strong>
      <p><strong>Nome:</strong> ${data.patient_name}</p>
      <p><strong>Nascimento:</strong> ${new Date(data.birthdate).toLocaleDateString()}</p>
      <p><strong>Email:</strong> ${data.email}</p>
      <p><strong>CPF:</strong> ${data.cpf}</p>
      <p><strong>Médico</strong>
      <p><strong>Nome:</strong> ${data.doctor.name}</p>
      <p><strong>CRM:</strong> ${data.doctor.crm}</p>
      <p><strong>CRM UF:</strong> ${data.doctor.crm_state}</p>
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
            return `
              <tr>
                <td>${exam.type}</td>
                <td>${exam.limits}</td>
                <td>${exam.result}</td>
              </tr>
            `;
          }
        ).join('')}
        </tbody>
      </table>
    `;
    console.log(data);
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
