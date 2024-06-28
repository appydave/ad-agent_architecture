# frozen_string_literal: true

require 'sequel'

module Ad
  module AgentArchitecture
    module Database
      # Workflow model represents a workflow entity in the database.
      class Workflow < Sequel::Model
        one_to_many :sections, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :attributes, class: 'Ad::AgentArchitecture::Database::Attribute'
        one_to_many :workflow_runs, class: 'Ad::AgentArchitecture::Database::WorkflowRun'
      end

      # Section model represents a section entity in the database.
      class Section < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :steps, class: 'Ad::AgentArchitecture::Database::Step'
        one_to_many :section_runs, class: 'Ad::AgentArchitecture::Database::SectionRun'
      end

      # Step model represents a step entity in the database.
      class Step < Sequel::Model
        many_to_one :section, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :input_attributes, class: 'Ad::AgentArchitecture::Database::InputAttribute'
        one_to_many :output_attributes, class: 'Ad::AgentArchitecture::Database::OutputAttribute'
        one_to_many :step_runs, class: 'Ad::AgentArchitecture::Database::StepRun'
      end

      # Attribute model represents an attribute entity in the database.
      class Attribute < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :input_attributes, class: 'Ad::AgentArchitecture::Database::InputAttribute'
        one_to_many :output_attributes, class: 'Ad::AgentArchitecture::Database::OutputAttribute'
      end

      # InputAttribute model represents an input attribute entity in the database.
      class InputAttribute < Sequel::Model
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
      end

      # OutputAttribute model represents an output attribute entity in the database.
      class OutputAttribute < Sequel::Model
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
      end

      # WorkflowRun model represents a workflow run entity in the database.
      class WorkflowRun < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :section_runs, class: 'Ad::AgentArchitecture::Database::SectionRun'
      end

      # SectionRun model represents a section run entity in the database.
      class SectionRun < Sequel::Model
        many_to_one :workflow_run, class: 'Ad::AgentArchitecture::Database::WorkflowRun'
        many_to_one :section, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :step_runs, class: 'Ad::AgentArchitecture::Database::StepRun'
      end

      # StepRun model represents a step run entity in the database.
      class StepRun < Sequel::Model
        many_to_one :section_run, class: 'Ad::AgentArchitecture::Database::SectionRun'
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        one_to_many :attribute_values, class: 'Ad::AgentArchitecture::Database::AttributeValue'
      end

      # AttributeValue model represents an attribute value entity in the database.
      class AttributeValue < Sequel::Model
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
        many_to_one :step_run, class: 'Ad::AgentArchitecture::Database::StepRun'
      end
    end
  end
end
