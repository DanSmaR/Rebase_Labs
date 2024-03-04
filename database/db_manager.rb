require 'pg'
require 'uri'

class DBManager
  def self.conn
    @conn ||= begin
      uri = URI.parse(ENV['DATABASE_URL'])

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
