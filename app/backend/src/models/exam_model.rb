require_relative './base_model'

class ExamModel < BaseModel
  INSERT_STATEMENT = <<~SQL.gsub("\n", " ")
    INSERT INTO exams (token, patient_cpf, doctor_crm, exam_date)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (token) DO NOTHING
  SQL

  def self.prepare_data(data)
    [
      data['token resultado exame'],
      data['cpf'],
      data['crm médico'],
      data['data exame']
    ]
  end
end
