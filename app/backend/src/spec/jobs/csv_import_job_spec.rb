require_relative '../spec_helper.rb'
require_relative '../../jobs/csv_import_job.rb'
Dir[File.expand_path("../../database/*.rb", __dir__)].each { |file| require file }
require_relative '../../exam_data_builder.rb'
require_relative '../support/test_data.rb'

RSpec.describe CSVImportJob do
  describe '#perform' do
    let(:file_path) { File.expand_path('../support/data_copy.csv', __dir__) }

    it 'calls the necessary methods and deletes the file' do
      original_file_path = File.expand_path('../support/data.csv', __dir__)
      FileUtils.cp(original_file_path, file_path)

      DBManager.conn.exec("ALTER SEQUENCE tests_id_seq RESTART WITH 1")

      CSVImportJob.new.perform(file_path)

      results = ExamDataBuilder.get_exams_from_db

      DatabaseSetup.clean(DBManager.conn)

      expect(results).to eq(db_result)
    end

    context 'when the file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'calls the necessary methods but does not delete the file' do
        mock_conn = double('PG::Connection')
        allow(DBManager).to receive(:conn).and_return(mock_conn)

        expect(DatabaseSetup).to receive(:prepare_statements).with(mock_conn)
        expect(DatabaseSetup).to receive(:insert_csv_data).with(file_path, mock_conn)
        expect(File).not_to receive(:delete)

        CSVImportJob.new.perform(file_path)
      end
    end
  end
end
