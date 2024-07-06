# frozen_string_literal: true

# Usage
# DB = Sequel.sqlite # In-memory database

# schema_creator = Ad::AgentArchitecture::Database::CreateSchema.new(DB)
# schema_creator.execute
module Ad
  module AgentArchitecture
    module Database
      # Create the database schema
      class CreateSchema
        attr_reader :db

        def initialize(db)
          @db = db
        end

        def execute
          create_tables
          define_models
        end

        private

        def create_tables
          db.create_table :workflows do
            primary_key :id
            String :name, null: false
            String :description, null: true
          end

          db.create_table :sections do
            primary_key :id
            foreign_key :workflow_id, :workflows
            String :name, null: false
            String :description, null: true
            Integer :order
          end

          db.create_table :steps do
            primary_key :id
            foreign_key :section_id, :sections
            String :name, null: false
            String :action, default: 'gpt'
            String :description, null: true
            Integer :order
            String :prompt
          end

          db.create_table :attributes do
            primary_key :id
            foreign_key :workflow_id, :workflows
            String :name, null: false
            String :description, null: true
            String :type
            Boolean :is_array
          end

          db.create_table :input_attributes do
            primary_key :id
            foreign_key :step_id, :steps
            foreign_key :attribute_id, :attributes
            Boolean :required
          end

          db.create_table :output_attributes do
            primary_key :id
            foreign_key :step_id, :steps
            foreign_key :attribute_id, :attributes
          end

          db.create_table :prompts do
            primary_key :id
            String :name, null: false
            String :path, null: true
            String :content, null: true
            String :description, null: true
            foreign_key :workflow_id, :workflows
          end

          db.create_table :settings do
            primary_key :id
            String :name, null: false
            String :value
            String :description, null: true
            foreign_key :workflow_id, :workflows
          end

          # Workflow runs workflows that are executed

          db.create_table :workflow_runs do
            primary_key :id
            foreign_key :workflow_id, :workflows
          end

          db.create_table :section_runs do
            primary_key :id
            foreign_key :workflow_run_id, :workflow_runs
            foreign_key :section_id, :sections
          end

          db.create_table :step_runs do
            primary_key :id
            foreign_key :section_run_id, :section_runs
            foreign_key :step_id, :steps
            Integer :branch_number
          end

          db.create_table :attribute_values do
            primary_key :id
            foreign_key :attribute_id, :attributes
            foreign_key :step_run_id, :step_runs
            String :value
          end
        end

        def define_models
          Class.new(Sequel::Model(:workflows)) do
            one_to_many :sections
            one_to_many :attributes
            one_to_many :workflow_runs
          end

          Class.new(Sequel::Model(:sections)) do
            many_to_one :workflow
            one_to_many :steps
            one_to_many :section_runs
          end

          Class.new(Sequel::Model(:steps)) do
            many_to_one :section
            one_to_many :input_attributes, class: :InputAttribute
            one_to_many :output_attributes, class: :OutputAttribute
            one_to_many :step_runs
          end

          Class.new(Sequel::Model(:attributes)) do
            many_to_one :workflow
            one_to_many :input_attributes, class: :InputAttribute
            one_to_many :output_attributes, class: :OutputAttribute
          end

          Class.new(Sequel::Model(:input_attributes)) do
            many_to_one :step
            many_to_one :attribute
          end

          Class.new(Sequel::Model(:output_attributes)) do
            many_to_one :step
            many_to_one :attribute
          end

          Class.new(Sequel::Model(:workflow_runs)) do
            many_to_one :workflow
            one_to_many :section_runs
          end

          Class.new(Sequel::Model(:section_runs)) do
            many_to_one :workflow_run
            many_to_one :section
            one_to_many :step_runs
          end

          Class.new(Sequel::Model(:step_runs)) do
            many_to_one :section_run
            many_to_one :step
            one_to_many :attribute_values
          end

          Class.new(Sequel::Model(:attribute_values)) do
            many_to_one :attribute
            many_to_one :step_run
          end
        end
      end
    end
  end
end
