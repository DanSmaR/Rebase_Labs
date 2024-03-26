class ExamService
  def initialize(data_builder)
    @data_builder = data_builder
  end

  def get_exams(token = nil)
    exams = @data_builder.get_exams_from_db(token)

    return [] unless exams.any?

    exams.group_by { |item| item['token'] }.map do |_token, items|
      @data_builder.build_exam_data(items)
    end
  end
end
