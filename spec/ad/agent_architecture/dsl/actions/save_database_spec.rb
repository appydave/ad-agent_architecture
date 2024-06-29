# frozen_string_literal: true

# require 'spec_helper'
# require 'sequel'
# require 'sqlite3'

RSpec.describe Ad::AgentArchitecture::Dsl::Actions::SaveDatabase do
  before do
    reset_database(DB)
  end

  let(:workflow_hash) do
    {
      name: 'Test Workflow',
      prompts: {
        p1: { name: :p1, path: 'abc', content: 'abc' },
        p2: { name: :p2, path: nil, content: 'abc' }
      },
      attributes: {
        title: { name: :title, type: :string, is_array: false }
      },
      sections: [
        {
          name: 'Section 1',
          order: 1,
          steps: [
            {
              name: 'Step 1',
              order: 1,
              input_attributes: [:title],
              output_attributes: [:title],
              prompt: 'Test prompt'
            }
          ]
        }
      ]
    }
  end

  let(:instance) { described_class.new(workflow_hash) }

  describe '#save' do
    it 'saves the workflow to the database' do
      expect { instance.save }.not_to raise_error

      # Verify workflow
      workflow = DB[:workflows].first
      expect(workflow[:name]).to eq('Test Workflow')

      # Verify attribute
      attribute = DB[:attributes].first
      expect(attribute[:name]).to eq('title')
      expect(attribute[:type]).to eq('string')
      expect(attribute[:is_array]).to be_falsey

      # Verify prompt
      DB[:workflows].order(:id).limit(1, 1).first

      prompts = DB[:prompts].all
      expect(prompts[0][:name]).to eq('p1')
      expect(prompts[0][:path]).to eq('abc')
      expect(prompts[0][:content]).to eq('abc')

      expect(prompts[1][:name]).to eq('p2')
      expect(prompts[1][:path]).to be_nil
      expect(prompts[1][:content]).to eq('abc')

      # Verify section
      section = DB[:sections].first
      expect(section[:name]).to eq('Section 1')
      expect(section[:order]).to eq(1)
      expect(section[:workflow_id]).to eq(workflow[:id])

      # Verify step
      step = DB[:steps].first
      expect(step[:name]).to eq('Step 1')
      expect(step[:order]).to eq(1)
      expect(step[:prompt]).to eq('Test prompt')
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
