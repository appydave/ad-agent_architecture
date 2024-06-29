# frozen_string_literal: true

require 'k_log'

module Ad
  module AgentArchitecture
    module Report
      # Print workflow details
      class WorkflowDetailReport
        include KLog::Logging

        def print(workflow)
          log.section_heading 'Workflow Details Report'
          log.kv 'Name', workflow.name
          log.kv 'Description', workflow.description

          workflow.sections.each do |section|
            log.section_heading "Section: #{section.name}"
            log.kv 'Order', section.order
            section.steps.each do |step|
              log.section_heading "Step: #{step.name}"
              log.kv 'Order', step.order
              log.kv 'Prompt', step.prompt
              log.kv 'Input Attributes', step.input_attributes.map { |ia| ia.attribute.name }.join(', ')
              log.kv 'Output Attributes', step.output_attributes.map { |oa| oa.attribute.name }.join(', ')
            end
          end
        end
      end
    end
  end
end
