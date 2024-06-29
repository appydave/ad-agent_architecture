# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

require 'ad/agent_architecture/version'
require 'ad/agent_architecture/db/create_schema'

DB = Sequel.sqlite

Ad::AgentArchitecture::Database::CreateSchema.new(DB).execute

require 'ad/agent_architecture/db/models'
require 'ad/agent_architecture/dsl/agent_workflow_dsl'

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
