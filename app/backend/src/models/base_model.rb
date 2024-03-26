class BaseModel
  def self.exec_insert(conn, data)
    conn.exec_prepared("insert_#{self.name.downcase}", self.prepare_data(data))
  end

  def self.prepare_insert(conn)
    begin
      conn.prepare("insert_#{self.name.downcase}", self::INSERT_STATEMENT)
    rescue => e
      # Statement already prepared, do nothing
    end
  end

  def self.exec_delete_all(conn)
    conn.exec("DELETE FROM #{self.name.downcase.gsub('model', 's')}")
  end
end
