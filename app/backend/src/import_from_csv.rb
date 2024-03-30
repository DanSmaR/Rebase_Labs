Dir[File.expand_path("./database/*.rb", __dir__)].each { |file| require file }

DatabaseSetup.seed(DBManager.conn)
