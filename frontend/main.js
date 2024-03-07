const fetchData = async () => {
  try {
    const response = await fetch('http://localhost:3000/tests');
    const data = await response.json();
    return data;
  } catch {
    return [];
  }
};

const createTable = (data) => {
  const table = document.querySelector('body > main > table');

  const thead = document.createElement('thead');
  thead.innerHTML = `
    <tr>
      <th>Token</th>
      <th>Data</th>
      <th>Paciente</th>
      <th>CPF</th>
      <th>Email</th>
      <th>Nascimento</th>
      <th>Médico</th>
      <th>CRM</th>
      <th>Estado CRM</th>
    </tr>
  `;

  const tbody = document.createElement('tbody');
  data.forEach(exam => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${exam.result_token}</td>
      <td>${new Date(exam.result_date).toLocaleDateString()}</td>
      <td>${exam.patient_name}</td>
      <td>${exam.cpf}</td>
      <td>${exam.email}</td>
      <td>${new Date(exam.birthdate).toLocaleDateString()}</td>
      <td>${exam.doctor.name}</td>
      <td>${exam.doctor.crm}</td>
      <td>${exam.doctor.crm_state}</td>
    `;
    tbody.appendChild(tr);
  });

  table.appendChild(thead);
  table.appendChild(tbody);
};

fetchData()
  .then(data => createTable(data));
