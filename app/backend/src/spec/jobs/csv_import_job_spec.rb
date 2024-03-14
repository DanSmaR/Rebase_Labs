require_relative '../spec_helper.rb'
require_relative '../../jobs/csv_import_job.rb'
require_relative '../../database/database_setup.rb'
require_relative '../../database/db_manager.rb'

RSpec.describe CSVImportJob do
  describe '#perform' do
    let(:file_path) { '/path/to/file.csv' }
    let(:mock_conn) { double('PG::Connection') }

    before do
      allow(DBManager).to receive(:conn).and_return(mock_conn)
      allow(DatabaseSetup).to receive(:prepare_statements)
      allow(DatabaseSetup).to receive(:insert_csv_data)
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:delete)
    end

    it 'calls the necessary methods and deletes the file' do
      expect(DatabaseSetup).to receive(:prepare_statements).with(mock_conn)
      expect(DatabaseSetup).to receive(:insert_csv_data).with(file_path, mock_conn)
      expect(File).to receive(:delete).with(file_path)

      CSVImportJob.new.perform(file_path)
    end

    context 'when the file does not exist' do
      before do
        allow(File).to receive(:exist?).and_return(false)
      end

      it 'calls the necessary methods but does not delete the file' do
        expect(DatabaseSetup).to receive(:prepare_statements).with(mock_conn)
        expect(DatabaseSetup).to receive(:insert_csv_data).with(file_path, mock_conn)
        expect(File).not_to receive(:delete)

        CSVImportJob.new.perform(file_path)
      end
    end
  end
end
