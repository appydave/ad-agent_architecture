# lib/ad/agent_architecture/db/models.rb

# frozen_string_literal: true

require 'sequel'

module Ad
  module AgentArchitecture
    module Database
      class Workflow < Sequel::Model
        one_to_many :sections, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :attributes, class: 'Ad::AgentArchitecture::Database::Attribute'
        one_to_many :workflow_runs, class: 'Ad::AgentArchitecture::Database::WorkflowRun'
      end

      class Section < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :steps, class: 'Ad::AgentArchitecture::Database::Step'
        one_to_many :section_runs, class: 'Ad::AgentArchitecture::Database::SectionRun'
      end

      class Step < Sequel::Model
        many_to_one :section, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :input_attributes, class: 'Ad::AgentArchitecture::Database::InputAttribute'
        one_to_many :output_attributes, class: 'Ad::AgentArchitecture::Database::OutputAttribute'
        one_to_many :step_runs, class: 'Ad::AgentArchitecture::Database::StepRun'
      end

      class Attribute < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :input_attributes, class: 'Ad::AgentArchitecture::Database::InputAttribute'
        one_to_many :output_attributes, class: 'Ad::AgentArchitecture::Database::OutputAttribute'
      end

      class InputAttribute < Sequel::Model
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
      end

      class OutputAttribute < Sequel::Model
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
      end

      class WorkflowRun < Sequel::Model
        many_to_one :workflow, class: 'Ad::AgentArchitecture::Database::Workflow'
        one_to_many :section_runs, class: 'Ad::AgentArchitecture::Database::SectionRun'
      end

      class SectionRun < Sequel::Model
        many_to_one :workflow_run, class: 'Ad::AgentArchitecture::Database::WorkflowRun'
        many_to_one :section, class: 'Ad::AgentArchitecture::Database::Section'
        one_to_many :step_runs, class: 'Ad::AgentArchitecture::Database::StepRun'
      end

      class StepRun < Sequel::Model
        many_to_one :section_run, class: 'Ad::AgentArchitecture::Database::SectionRun'
        many_to_one :step, class: 'Ad::AgentArchitecture::Database::Step'
        one_to_many :attribute_values, class: 'Ad::AgentArchitecture::Database::AttributeValue'
      end

      class AttributeValue < Sequel::Model
        many_to_one :attribute, class: 'Ad::AgentArchitecture::Database::Attribute'
        many_to_one :step_run, class: 'Ad::AgentArchitecture::Database::StepRun'
      end
    end
  end
end
