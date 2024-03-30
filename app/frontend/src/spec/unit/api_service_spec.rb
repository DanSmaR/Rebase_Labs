require_relative '../spec_helper.rb'
require 'faraday'
require_relative '../../services/api_service.rb'
describe ApiService do
  let(:mock_conn) { instance_double(Faraday::Connection) }
  let(:mock_response) { instance_double(Faraday::Response) }

  after do
    ApiService.instance_variable_set(:@conn, nil)
  end

  context "no errors" do
    before do
      allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
    end
    describe ".initialize" do
      it 'instantiates a Faraday connection' do
        expect(subject.instance_variable_get(:@conn)).to eq mock_conn
      end
    end

    describe '.get_exams' do
      it "returns a Faraday Response" do
        queries = { limit: 20, page: 2 }

        allow(mock_conn).to receive(:get).with('tests', queries).and_return(mock_response)
        allow(mock_response).to receive(:body)

        response = subject.get_exams(limit: queries[:limit], page: queries[:page])

        expect(response).to eq mock_response.body
      end
    end

    describe ".get_exams_by_token" do
      it "returns a Faraday Response" do
        allow(mock_conn).to receive(:get).with('tests/IQCZ17').and_return(mock_response)
        allow(mock_response).to receive(:body)

        response = subject.get_exam_by_token('IQCZ17')

        expect(response).to eq mock_response.body
      end
    end

    describe ".send_file" do
      let(:mock_file) { instance_double(Faraday::Multipart::FilePart) }
      it "returns a Faraday Response" do
        payload = { file: mock_file }
        allow(mock_conn).to receive(:post).with('import', payload).and_return(mock_response)

        response = subject.send_file(payload)

        expect(response).to eq mock_response
      end
    end
  end


  context "with errors" do
    describe ".initialize" do
      it 'raises ApiServerError' do
        allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_raise(Faraday::Error)

        expect { subject }.to raise_error(ApiServerError)
      end
    end

    describe ".get_exams" do
      before do
        allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
      end
      it "raises ApiNotFoundError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ResourceNotFound)

        expect { subject.get_exams(limit: 20, page: 1) }.to raise_error(ApiNotFoundError)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ConnectionFailed)

        expect { subject.get_exams(limit: 20, page: 1) }.to raise_error(ApiServerError)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ServerError)

        expect { subject.get_exams(limit: 20, page: 1) }.to raise_error(ApiServerError)
      end
    end

    describe ".get_exam_by_token" do
      let(:token) { 'HEDFA1' }

      before do
        allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
      end

      it "raises ApiNotFoundError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ResourceNotFound)

        expect { subject.get_exam_by_token(token) }.to raise_error(ApiNotFoundError)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ServerError)

        expect { subject.get_exam_by_token(token) }.to raise_error(ApiServerError)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:get).and_raise(Faraday::ConnectionFailed)

        expect { subject.get_exam_by_token(token) }.to raise_error(ApiServerError)
      end
    end

    describe ".send_file" do
      let(:mock_file) { instance_double(Faraday::Multipart::FilePart) }
      let(:payload) { { file: mock_file } }

      before do
        allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:post).and_raise(Faraday::ServerError)

        expect { subject.send_file(payload) }.to raise_error(ApiServerError)
      end

      it "raises ApiServerError" do
        allow(mock_conn).to receive(:post).and_raise(Faraday::ConnectionFailed)

        expect { subject.send_file(payload) }.to raise_error(ApiServerError)
      end

      it "raises ApiBadRequestError" do
        allow(mock_conn).to receive(:post).and_raise(Faraday::BadRequestError)

        expect { subject.send_file(payload) }.to raise_error(ApiBadRequestError)
      end
    end
  end
end
