require_relative '../exam_data_builder.rb'
require_relative '../models/exam_model.rb'

class PaginationMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    token = ""

    unless request.path == '/import'

      if request.params['page'] && request.params['limit']
        page = (request.params['page']).to_i
        limit = (request.params['limit']).to_i

        offset =  (page - 1) * limit
        endIndex = page * limit

        examsCount = ExamModel.count(DBManager.conn).to_a[0]['count'].to_i

        if endIndex < examsCount
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

      env['has_token'] = !token.empty? ? true : false

      env['results'] = ExamDataBuilder.get_exams_from_db(token:, limit:, offset:)
    end

    @app.call(env)
  rescue PG::Error => e
    [500, { "Content-Type" => "application/json" }, { error: true,  message: 'An error has occurred. Try again' }.to_json]
  end
end
