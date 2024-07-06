# frozen_string_literal: true

RSpec.describe Ad::AgentArchitecture::Report::AgentDataBuilder do
  before do
    reset_database(DB)
  end

  let(:builder) { described_class.new(dsl.workflow_id) }

  let(:dsl) do
    Agent.create(:test_workflow, description: 'Test description') do
      settings do
        setting_one 'value1', description: 'setting one description'
      end

      attributes do
        attribute :some_title, type: :string, is_array: false, description: 'Title goes here'
      end

      prompts do
        prompt :prompt_one, path: 'abc', content: 'abc'
        prompt :prompt_two, path: nil, content: 'abc', description: 'description for prompt two'
      end

      section :section_one, description: 'Section 1 description' do
        step :step_one, description: 'Step 1 description' do
          input :some_title
          output :some_title
          prompt 'Test prompt'
        end
      end
    end
  end

  describe '#build' do
    before { dsl.save }

    let(:workflow_id) { dsl.workflow_id }

    it 'builds the agent data correctly' do
      data = builder.build

      # puts JSON.pretty_generate(data)

      expect(data[:name]).to eq('test_workflow')
      expect(data[:title]).to eq('Test Workflow')
      expect(data[:description]).to eq('Test description')

      expect(data[:settings]).to include(
        setting_one: { value: 'value1', title: 'Setting One', description: 'setting one description' }
      )

      expect(data[:attributes]).to include(
        some_title: { name: 'some_title', type: 'string', is_array: false, description: 'Title goes here', title: 'Some Title' }
      )

      expect(data[:prompts]).to include(
        prompt_one: { name: 'prompt_one', content: 'abc', description: nil, title: 'Prompt One' },
        prompt_two: { name: 'prompt_two', content: 'abc', description: 'description for prompt two', title: 'Prompt Two' }
      )
    end
  end
end
