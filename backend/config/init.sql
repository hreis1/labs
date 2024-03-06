CREATE TABLE patients (
    id SERIAL PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birthdate DATE NOT NULL,
    address VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

CREATE TABLE doctors (
    id SERIAL PRIMARY KEY,
    crm VARCHAR(10) NOT NULL,
    crm_state VARCHAR(2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL
);

CREATE TABLE exams (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES patients(id),
    doctor_id INTEGER REFERENCES doctors(id),
    result_token VARCHAR(10) NOT NULL UNIQUE,
    result_date DATE NOT NULL
);

CREATE TABLE tests (
    id SERIAL PRIMARY KEY,
    exam_id INTEGER REFERENCES exams(id),
    type VARCHAR(100) NOT NULL,
    limits VARCHAR(100) NOT NULL,
    result VARCHAR(100) NOT NULL
);
