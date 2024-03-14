require_relative './database/database_setup.rb'
require_relative './database/db_manager.rb'

DatabaseSetup.seed(DBManager.conn)
