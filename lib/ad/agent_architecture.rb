# frozen_string_literal: true

require 'sequel'
require 'sqlite3'
require 'k_log'

require 'ad/agent_architecture/version'
require 'ad/agent_architecture/database/create_schema'

DB = Sequel.sqlite

Ad::AgentArchitecture::Database::CreateSchema.new(DB).execute

require 'ad/agent_architecture/database/models'
require 'ad/agent_architecture/database/sql_query'
require 'ad/agent_architecture/database/save_workflow_graph'
require 'ad/agent_architecture/dsl/agent_workflow_dsl'
require 'ad/agent_architecture/report/workflow_detail_report'
require 'ad/agent_architecture/report/workflow_list_report'

module Ad
  module AgentArchitecture
    # raise Ad::AgentArchitecture::Error, 'Sample message'
    Error = Class.new(StandardError)

    # Your code goes here...
  end
end

if ENV.fetch('KLUE_DEBUG', 'false').downcase == 'true'
  namespace = 'AdAgentArchitecture::Version'
  file_path = $LOADED_FEATURES.find { |f| f.include?('ad-agent_architecture/version') }
  version   = AdAgentArchitecture::VERSION.ljust(9)
  puts "#{namespace.ljust(35)} : #{version.ljust(9)} : #{file_path}"
end
