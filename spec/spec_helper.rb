# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'simplecov'

SimpleCov.start

require 'ad/agent_architecture'

def reset_database(db)
  db.drop_table?(:attribute_values)
  db.drop_table?(:step_runs)
  db.drop_table?(:section_runs)
  db.drop_table?(:workflow_runs)
  db.drop_table?(:input_attributes)
  db.drop_table?(:output_attributes)
  db.drop_table?(:attributes)
  db.drop_table?(:steps)
  db.drop_table?(:sections)
  db.drop_table?(:prompts)
  db.drop_table?(:workflows)

  Ad::AgentArchitecture::Database::CreateSchema.new(db).execute
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run_when_matching :focus

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
