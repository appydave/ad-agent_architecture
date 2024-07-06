# frozen_string_literal: true

RSpec.shared_context 'with shared context', shared_context: :metadata do
  let(:sample_dsl) do
    Agent.create('Test Workflow', description: 'Test description') do
      settings do
        setting1 'value1', description: 'setting1 description'
      end

      attributes do
        attribute :title, type: :string, is_array: false, description: 'Title goes here'
      end

      prompts do
        prompt :p1, path: 'abc', content: 'abc'
        prompt :p2, path: nil, content: 'abc', description: 'abc description'
      end

      section 'Section 1', description: 'Section 1 description' do
        step 'Step 1', description: 'Step 1 description' do
          input :title
          output :title
          prompt 'Test prompt'
        end
      end
    end
  end
end
