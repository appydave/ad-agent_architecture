# frozen_string_literal: true

module Ad
  module AgentArchitecture
    module Database
      class SQLQuery
        SQL_DIR = File.expand_path('../sql', __dir__)

        def self.query(sql_filename, params = {})
          sql_path = File.join(SQL_DIR, "#{sql_filename}.sql")

          # puts "SQL_DIR: #{SQL_DIR}"
          # puts "SQL Path: #{sql_path}"
          raise "SQL file not found: #{sql_path}" unless File.exist?(sql_path)

          sql = File.read(sql_path)
          DB.fetch(sql, params)
        end
      end
    end
  end
end
