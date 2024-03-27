require_relative '../exam_data_builder.rb'
require_relative '../models/exam_model.rb'
require_relative '../services/exam_service.rb'

class PaginationMiddleware
  def initialize(app, exam_model, exam_service)
    @app = app
    @exam_model = exam_model
    @exam_service = exam_service
  end

  def call(env)
    request = Rack::Request.new(env)

    unless request.path == '/import'
      token = ''

      if request.params['page'] && request.params['limit']
        page = (request.params['page']).to_i
        limit = (request.params['limit']).to_i

        offset =  (page - 1) * limit
        end_index = page * limit
        exams_count = @exam_model.count(DBManager.conn).to_a[0]['count'].to_i
        total_pages = exams_count.to_f / limit

        env['total_pages'] = total_pages.ceil

        if end_index < exams_count
          env['next'] = {
            page: page + 1,
            limit:
          }
        end

        if offset > 0
          env['previous'] = {
            page: page - 1,
            limit:
          }
        end
      else
        token = request.path.split('/')[2].to_s
      end

      env['results'] = @exam_service.get_exams(token:, limit:, offset:)
    end

    @app.call(env)
  rescue DataBaseError => e
    [500, { "Content-Type" => "application/json" }, { error: true,  message: 'An error has occurred. Try again' }.to_json]
  end
end
