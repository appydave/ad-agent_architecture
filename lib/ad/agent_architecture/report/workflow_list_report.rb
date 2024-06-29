# frozen_string_literal: true

require 'k_log'

module Ad
  module AgentArchitecture
    module Report
      # Print workflow details
      class WorkflowListReport
        include KLog::Logging

        def print
          # tp query, :workflow_name, :workflow_description, :section_name, :section_description, :section_order, :step_name, :step_order, :step_prompt, :inputs, :outputs
          tp query, :workflow_name, :workflow_description, :section_name, :step_name, :step_prompt, :inputs, :outputs
        end

        def query
          Ad::AgentArchitecture::Database::SQLQuery.query(:workflow_details).map do |row|
            row[:inputs] = JSON.parse(row[:inputs]) if row[:inputs]
            row[:outputs] = JSON.parse(row[:outputs]) if row[:outputs]
            row
          end
        end
      end
    end
  end
end
