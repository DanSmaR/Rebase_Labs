require_relative './base_model'

class PatientModel < BaseModel
  INSERT_STATEMENT = <<~SQL.gsub("\n", " ")
    INSERT INTO patients (cpf, patient_name, patient_email, birth_date, address, city, state)
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    ON CONFLICT (cpf) DO NOTHING
  SQL

  def self.prepare_data(data)
    [
      data['cpf'],
      data['nome paciente'],
      data['email paciente'],
      data['data nascimento paciente'],
      data['endereço/rua paciente'],
      data['cidade paciente'],
      data['estado patiente']
    ]
  end
end
