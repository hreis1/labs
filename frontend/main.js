fetch('http://localhost:3000/tests')
  .then(response => response.json())
  .then(data => {
    const ul = document.querySelector('ul');
    ul.innerHTML = '';
    data.forEach(exam => {
      const li = document.createElement('li');
      li.innerHTML = `
        <dl>
          <dt>Token</dt>
          <dd>${exam.result_token}</dd>
          <dt>Data</dt>
          <dd>${exam.result_date}</dd>
          <dt>Paciente</dt>
          <dd>${exam.patient_name}</dd>
          <dt>CPF</dt>
          <dd>${exam.cpf}</dd>
          <dt>Email</dt>
          <dd>${exam.email}</dd>
          <dt>Nascimento</dt>
          <dd>${exam.birthdate}</dd>
          <dt>Médico</dt>
          <dd>${exam.doctor.name}</dd>
          <dt>CRM</dt>
          <dd>${exam.doctor.crm}</dd>
          <dt>Estado CRM</dt>
          <dd>${exam.doctor.crm_state}</dd>
        </dl>
        <br>
        `;
        const details = document.createElement('details');
        details.innerHTML = `
          <summary>Resultados</summary>
        `;
        li.appendChild(details);
        const div = document.createElement('div');
        exam.tests.forEach(test => {
          div.innerHTML += `
            <dl>
              <dt>Exame</dt>
              <dd>${test.name}</dd>
              <dt>Tipo</dt>
              <dd>${test.type}</dd>
              <dt>Resultado</dt>
              <dd>${test.result}</dd>
              <dt>Valor de Referência</dt>
              <dd>${test.limits}</dd>
            </dl>
          `;
          details.appendChild(div);
        });
      ul.appendChild(li);
    });
  });
