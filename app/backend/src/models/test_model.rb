require_relative './base_model'

class TestModel < BaseModel
  INSERT_STATEMENT = <<~SQL.gsub("\n", " ")
    INSERT INTO tests (exam_token, exam_type, exam_limits, exam_result)
    VALUES ($1, $2, $3, $4)
    ON CONFLICT (exam_token, exam_type) DO NOTHING
  SQL

  def self.prepare_data(data)
    [
      data['token resultado exame'],
      data['tipo exame'],
      data['limites tipo exame'],
      data['resultado tipo exame']
    ]
  end
end
