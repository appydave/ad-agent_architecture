# file: spec/ad/agent_architecture/dsl/data_accessors_spec.rb

# frozen_string_literal: true

require 'ad/agent_architecture/dsl/data_accessors'

RSpec.describe Ad::AgentArchitecture::Dsl::DataAccessors do
  let(:workflow_data) do
    {
      settings: { test_setting: 'value' },
      attributes: { test_attribute: { name: :test_attribute, type: :string } },
      prompts: { test_prompt: { name: :test_prompt, content: 'content' } },
      sections: []
    }
  end

  let(:workflow_dsl_class) do
    Class.new do
      include Ad::AgentArchitecture::Dsl::DataAccessors

      attr_reader :data

      def initialize(data)
        @data = data
      end
    end
  end

  let(:workflow) { workflow_dsl_class.new(workflow_data) }

  describe '#settings' do
    it 'returns the settings hash from the workflow data' do
      expect(workflow.settings).to eq(workflow_data[:settings])
    end
  end

  describe '#get_setting' do
    it 'retrieves a setting by name' do
      expect(workflow.get_setting(:test_setting)).to eq('value')
    end
  end

  describe '#attributes' do
    it 'returns the attributes hash from the workflow data' do
      expect(workflow.attributes).to eq(workflow_data[:attributes])
    end
  end

  describe '#get_attribute' do
    it 'retrieves an attribute by name' do
      expect(workflow.get_attribute(:test_attribute)).to eq({ name: :test_attribute, type: :string })
    end
  end

  describe '#prompts' do
    it 'returns the prompts hash from the workflow data' do
      expect(workflow.prompts).to eq(workflow_data[:prompts])
    end
  end

  describe '#get_prompt' do
    it 'retrieves a prompt by name' do
      expect(workflow.get_prompt(:test_prompt)).to eq({ name: :test_prompt, content: 'content' })
    end
  end

  describe '#get_prompt_content' do
    it 'retrieves a prompt content by name' do
      expect(workflow.get_prompt_content(:test_prompt)).to eq('content')
    end
  end

  describe '#sections' do
    it 'returns the sections array from the workflow data' do
      expect(workflow.sections).to eq(workflow_data[:sections])
    end
  end
end
