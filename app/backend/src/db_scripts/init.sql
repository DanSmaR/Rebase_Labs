CREATE TABLE IF NOT EXISTS patients (
    cpf VARCHAR PRIMARY KEY,
    patient_name VARCHAR,
    patient_email VARCHAR,
    birth_date DATE,
    address VARCHAR,
    city VARCHAR,
    state VARCHAR
  );

  CREATE TABLE IF NOT EXISTS doctors (
    crm VARCHAR PRIMARY KEY,
    crm_state VARCHAR,
    doctor_name VARCHAR,
    doctor_email VARCHAR
  );

  CREATE TABLE IF NOT EXISTS exams (
    token VARCHAR PRIMARY KEY,
    patient_cpf VARCHAR REFERENCES patients(cpf),
    doctor_crm VARCHAR REFERENCES doctors(crm),
    exam_date DATE
  );

  CREATE TABLE IF NOT EXISTS tests (
    id SERIAL PRIMARY KEY,
    exam_token VARCHAR REFERENCES exams(token),
    exam_type VARCHAR,
    exam_limits VARCHAR,
    exam_result VARCHAR
  );

  ALTER TABLE tests
  ADD CONSTRAINT unique_exam_token_and_type UNIQUE (exam_token, exam_type);