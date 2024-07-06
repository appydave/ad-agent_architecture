# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Dsl::Actions::SaveDatabase do
  include_context 'with shared context'

  before do
    reset_database(DB)
  end

  let(:instance) { described_class.new(sample_dsl.workflow) }

  describe '#save' do
    it 'saves the workflow to the database' do
      expect { instance.save }.not_to raise_error

      expect(instance.workflow_id).not_to be_nil

      # Verify workflow
      workflow = DB[:workflows].first
      expect(workflow[:name]).to eq('Test Workflow')
      expect(workflow[:description]).to eq('Test description')

      # Verify attribute
      attribute = DB[:attributes].first
      expect(attribute[:name]).to eq('title')
      expect(attribute[:type]).to eq('string')
      expect(attribute[:is_array]).to be_falsey
      expect(attribute[:description]).to eq('Title goes here')

      # Verify setting
      setting = DB[:settings].first
      expect(setting[:name]).to eq('setting1')
      expect(setting[:value]).to eq('value1')
      expect(setting[:description]).to eq('setting1 description')

      # Verify prompt
      DB[:workflows].order(:id).limit(1, 1).first

      prompts = DB[:prompts].all
      expect(prompts[0][:name]).to eq('p1')
      expect(prompts[0][:path]).to eq('abc')
      expect(prompts[0][:content]).to eq('abc')

      expect(prompts[1][:name]).to eq('p2')
      expect(prompts[1][:path]).to be_nil
      expect(prompts[1][:content]).to eq('abc')
      expect(prompts[1][:description]).to eq('abc description')

      # Verify section
      section = DB[:sections].first
      expect(section[:name]).to eq('Section 1')
      expect(section[:order]).to eq(1)
      expect(section[:description]).to eq('Section 1 description')
      expect(section[:workflow_id]).to eq(workflow[:id])

      # Verify step
      step = DB[:steps].first
      expect(step[:name]).to eq('Step 1')
      expect(step[:order]).to eq(1)
      expect(step[:prompt]).to eq('Test prompt')
      expect(step[:description]).to eq('Step 1 description')
      expect(step[:section_id]).to eq(section[:id])

      # Verify input attribute
      input_attribute = DB[:input_attributes].first
      expect(input_attribute[:step_id]).to eq(step[:id])
      expect(input_attribute[:attribute_id]).to eq(attribute[:id])

      # Verify output attribute
      output_attribute = DB[:output_attributes].first
      expect(output_attribute[:step_id]).to eq(step[:id])
      expect(output_attribute[:attribute_id]).to eq(attribute[:id])
    end
  end
end
