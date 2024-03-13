require_relative './database/db_manager.rb'

class ExamDataBuilder
  def self.get_exams_from_db(query, *params)
    result = DBManager.conn.exec_params(query, params)
    result.map { |row| row }
  end

  def self.build_exam_data(items)
    {
      'token' => items.first['token'],
      'exam_date' => items.first['exam_date'],
      'cpf' => items.first['cpf'],
      'name' => items.first['patient_name'],
      'email' => items.first['patient_email'],
      'birthday' => items.first['birth_date'],
      'address' => items.first['address'],
      'city' => items.first['city'],
      'state' => items.first['state'],
      'doctor' => build_doctor_data(items),
      'tests' => build_exam_tests(items)
    }
  end

  def self.build_doctor_data(items)
    {
      'crm' => items.first['crm'],
      'crm_state' => items.first['crm_state'],
      'name' => items.first['doctor_name'],
      'email' => items.first['doctor_email']
    }
  end

  def self.build_exam_tests(items)
    items.map do |item|
      {
        'type' => item['exam_type'],
        'limits' => item['exam_limits'],
        'result' => item['exam_result']
      }
    end
  end
end
