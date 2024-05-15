document.getElementById('fileInput').addEventListener('change', async function() {
  try {
  const formData = new FormData();
  formData.append('file', this.files[0]);
    const response = await fetch('http://localhost:3000/api/import', {
      method: 'POST',
      body: formData
    });
    const data = await response.json();
    if (data.error) {
      alert('Erro ao enviar o arquivo');
    }
    if (data.message) {
      alert('Arquivo enviado com sucesso, aguarde a atualização da página');
      location.reload();
    }} catch (error) {
    alert('Erro ao enviar o arquivo');
    }
});

document.getElementById('search').addEventListener('keypress', async function(event) {
  if (event.key === 'Enter') {
    const search = this.value;
    if (!search || search.length != 6) {
      return;
    }
    const exam = await getExam(search);
    if (exam.error) {
      createExamsTable([]);
    } else {
      createExamModal(exam);
    }
  }
});

const getExams = async () => {
  try {
    const response = await fetch('http://localhost:3000/api/tests');
    const data = await response.json();
    return data;
  } catch {
    return [];
  }
};

const createExamsTable = (exams) => {
  const main = document.querySelector('main');

  if (exams.length === 0) {
    main.innerHTML = `<h2>Nenhum exame encontrado</h2>`;
    return;
  }

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
  exams.forEach(exam => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${exam.result_token}</td>
      <td>${new Date(exam.result_date).toLocaleDateString()}</td>
      <td>${exam.patient_name}</td>
      <td>${exam.cpf}</td>
      <td>${exam.doctor.name}</td>
    `;
    tr.addEventListener('click', function() {
      getExam(exam.result_token)
        .then(exam => createExamModal(exam));
    });
    tbody.appendChild(tr);
  });

  table.appendChild(thead);
  table.appendChild(tbody);
};

const getExam = async (token) => {
  try {
    const response = await fetch(`http://localhost:3000/api/tests/${token}`);
    const data = await response.json();
    return data;
  } catch (error) {
    return {};
  }
};

const createExamModal = (exam) => {
  const main = document.querySelector('main');
  if (document.querySelector('.modal')) {
    document.querySelector('.modal').remove();
  }
  if (!exam) {
    return;
  }
  const modal = document.createElement('div');
  modal.classList.add('modal');
  main.appendChild(modal);

  modal.innerHTML = `
    <div class="modal-content">
      <h2>Exame<span class="close">&times;</span></h2>

      <table>
        <thead>
          <tr>
            <th>Token</th>
            <th>Data do exame</th>
            <th>Paciente</th>
            <th>Médico</th>
          </tr>
        </thead>
        <tbody>
          <tr class="exam-description">
            <td>${exam.result_token}</td>
            <td>${new Date(exam.result_date).toLocaleDateString()}</td>
            <td>
              <p>Nome: ${exam.patient_name}</p>
              <p>CPF: ${exam.cpf}</p>
              <p>Nascimento: ${new Date(exam.birthdate).toLocaleDateString()}</p>
              <p>E-mail: ${exam.email}</p>
            </td>
            <td>
              <p>Nome: ${exam.doctor.name}</p>
              <p>CRM: ${exam.doctor.crm} | ${exam.doctor.crm_state}</p>
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
          ${exam.tests.map(test => {
            const { result, limits } = test;
            const [lowerLimit, upperLimit] = limits.split('-');
            const color = (Number(result) >= Number(lowerLimit) && Number(result) <= Number(upperLimit)) ? 'green' : 'red';
            return `
              <tr>
                <td>${test.type}</td>
                <td>${limits}</td>
                <td style="color: ${color}">${result}</td>
              </tr>
            `;
          }).join('')}
        </tbody>
      </table>
    </div>
  `;

  const closeModal = () => modal.remove();
  const close = modal.querySelector('.close');
  close.addEventListener('click', closeModal);
  window.addEventListener('click', (event) => {
    if (event.target === modal) {
      closeModal();
    }
  });
};

getExams()
  .then(exams => createExamsTable(exams));
