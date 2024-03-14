require_relative './base_model'

class DoctorModel < BaseModel
  INSERT_STATEMENT = <<~SQL.gsub("\n", " ")
    INSERT INTO doctors (crm, crm_state, doctor_name, doctor_email)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (crm) DO NOTHING
  SQL

  def self.prepare_data(data)
    [
      data['crm médico'],
      data['crm médico estado'],
      data['nome médico'],
      data['email médico']
    ]
  end
end
