require_relative './database/db_manager.rb'
require_relative './errors/database_error.rb'

class ExamDataBuilder
  QUERY = [
    'SELECT p.*, d.*, e.*, t.* ',
    'FROM exams e ',
    'FROM (SELECT * FROM exams LIMIT $1 OFFSET $2) e ',
    'JOIN patients p ON p.cpf = e.patient_cpf JOIN doctors d ON d.crm = e.doctor_crm ',
    'JOIN tests t ON t.exam_token = e.token'
  ]

  def self.get_exams_from_db(token: '', limit: nil, offset: nil)
    if !token.empty?
      final_query = "#{QUERY[0] + QUERY[1] + QUERY[3] + QUERY[4] } WHERE e.token = $1;"
      params = [token]
    elsif offset && limit
      final_query = "#{QUERY[0] + QUERY[2] + QUERY[3] + QUERY[4]} ORDER BY e.exam_date DESC, t.exam_type;"
      params = [limit, offset]
    else
      final_query = "#{QUERY[0] + QUERY[1] + QUERY[3] + QUERY[4]} ORDER BY e.exam_date DESC, t.exam_type;"
      params = []
    end

    begin
      result = DBManager.conn.exec_params(final_query, params)
      result.map { |row| row }

    rescue PG::Error => e
      puts e.message
      raise DataBaseError, e.message
    end
  end

  def self.build_exam_data(items)
    data = {
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
