# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Ad::AgentArchitecture::Db' do
  let(:db) { DB }

  before do
    reset_database(db)
  end

  describe 'Database Schema' do
    it 'has a workflows table' do
      expect(db.table_exists?(:workflows)).to be true
    end

    it 'has a sections table' do
      expect(db.table_exists?(:sections)).to be true
    end

    it 'has a steps table' do
      expect(db.table_exists?(:steps)).to be true
    end

    it 'has an attributes table' do
      expect(db.table_exists?(:attributes)).to be true
    end

    it 'has an input_attributes table' do
      expect(db.table_exists?(:input_attributes)).to be true
    end

    it 'has an output_attributes table' do
      expect(db.table_exists?(:output_attributes)).to be true
    end

    it 'has a workflow_runs table' do
      expect(db.table_exists?(:workflow_runs)).to be true
    end

    it 'has a section_runs table' do
      expect(db.table_exists?(:section_runs)).to be true
    end

    it 'has a step_runs table' do
      expect(db.table_exists?(:step_runs)).to be true
    end

    it 'has an attribute_values table' do
      expect(db.table_exists?(:attribute_values)).to be true
    end
  end

  describe 'Database Associations' do
    let(:workflow) { Ad::AgentArchitecture::Database::Workflow.create(name: 'Test Workflow', description: 'A test workflow') }
    let(:section) { Ad::AgentArchitecture::Database::Section.create(name: 'Test Section', description: 'A test section', order: 1, workflow_id: workflow.id) }
    let(:step) { Ad::AgentArchitecture::Database::Step.create(name: 'Test Step', description: 'A test step', order: 1, section_id: section.id, prompt: 'Test prompt') }
    let(:attribute) { Ad::AgentArchitecture::Database::Attribute.create(name: 'Test Attribute', type: 'string', is_array: false, workflow_id: workflow.id) }

    it 'associates sections with workflows' do
      workflow.add_section(section)
      expect(workflow.reload.sections).to include(section)
    end

    it 'associates steps with sections' do
      section.add_step(step)
      expect(section.reload.steps).to include(step)
    end

    it 'associates attributes with workflows' do
      workflow.add_attribute(attribute)
      expect(workflow.reload.attributes).to include(attribute)
    end

    it 'creates and associate input_attributes with steps' do
      input_attr = Ad::AgentArchitecture::Database::InputAttribute.create(step_id: step.id, attribute_id: attribute.id, required: true)
      expect(step.reload.input_attributes).to include(input_attr)
    end

    it 'creates and associate output_attributes with steps' do
      output_attr = Ad::AgentArchitecture::Database::OutputAttribute.create(step_id: step.id, attribute_id: attribute.id)
      expect(step.reload.output_attributes).to include(output_attr)
    end

    it 'creates and associate workflow_runs with workflows' do
      workflow_run = Ad::AgentArchitecture::Database::WorkflowRun.create(workflow_id: workflow.id)
      expect(workflow.reload.workflow_runs).to include(workflow_run)
    end

    it 'creates and associate section_runs with workflow_runs' do
      workflow_run = Ad::AgentArchitecture::Database::WorkflowRun.create(workflow_id: workflow.id)
      section_run = Ad::AgentArchitecture::Database::SectionRun.create(workflow_run_id: workflow_run.id, section_id: section.id)
      expect(workflow_run.reload.section_runs).to include(section_run)
    end

    it 'creates and associate step_runs with section_runs' do
      workflow_run = Ad::AgentArchitecture::Database::WorkflowRun.create(workflow_id: workflow.id)
      section_run = Ad::AgentArchitecture::Database::SectionRun.create(workflow_run_id: workflow_run.id, section_id: section.id)
      step_run = Ad::AgentArchitecture::Database::StepRun.create(section_run_id: section_run.id, step_id: step.id, branch_number: 1)
      expect(section_run.reload.step_runs).to include(step_run)
    end

    it 'creates and associate attribute_values with step_runs' do
      workflow_run = Ad::AgentArchitecture::Database::WorkflowRun.create(workflow_id: workflow.id)
      section_run = Ad::AgentArchitecture::Database::SectionRun.create(workflow_run_id: workflow_run.id, section_id: section.id)
      step_run = Ad::AgentArchitecture::Database::StepRun.create(section_run_id: section_run.id, step_id: step.id, branch_number: 1)
      attr_value = Ad::AgentArchitecture::Database::AttributeValue.create(attribute_id: attribute.id, step_run_id: step_run.id, value: 'Test value')
      expect(step_run.reload.attribute_values).to include(attr_value)
    end
  end
end
