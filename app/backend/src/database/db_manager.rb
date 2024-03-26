require 'pg'
require 'uri'

class DBManager
  def self.conn
    database_url = ENV['RACK_ENV'] == 'test' ? ENV['DB_TEST_URL'] : ENV['DATABASE_URL']

    @conn ||= begin
      uri = URI.parse(database_url)

      PG.connect(
        host: uri.hostname,
        port: uri.port,
        dbname: uri.path[1..-1],
        user: uri.user,
        password: uri.password
      )
    end
  end
end
