require_relative '../spec_helper.rb'
require_relative '../../database/db_manager'
require_relative '../../database/database_setup'

describe 'import_from_csv.rb' do
  let(:mock_conn) { double('PG::Connection') }

  before do
    allow(DBManager).to receive(:conn).and_return(mock_conn)
  end

  it 'seeds the database' do
    expect(DatabaseSetup).to receive(:seed).with(mock_conn)

    load File.join(__dir__, '../../import_from_csv.rb')
  end
end
