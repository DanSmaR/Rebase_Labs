require_relative '../spec_helper.rb'
require_relative '../../services/exam_service.rb'
require_relative '../../exam_data_builder.rb'
require_relative '../support/test_data.rb'

describe ExamService do
  let(:data_builder) { class_double(ExamDataBuilder) }
  let(:exam_service) { ExamService.new(data_builder) }

  context '#get_exams' do
    it 'returns an empty array when there are no exams' do
      allow(data_builder).to receive(:get_exams_from_db).and_return([])

      expect(exam_service.get_exams).to eq([])
    end

    it 'returns grouped exams when there are exams in DB' do
      allow(data_builder).to receive(:get_exams_from_db).and_return(db_result)
      allow(data_builder).to receive(:build_exam_data).and_return(*api_response)

      expect(exam_service.get_exams).to eq(api_response)
    end
  end
end
