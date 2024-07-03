# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Ad::AgentArchitecture::Report::DslGenerator do
  let(:workflow_hash) do
    {
      name: 'YouTube Script Writer',
      settings: {
        prompt_path: 'spec/fixtures/prompts'
      },
      prompts: {
        working_idea: { name: :working_idea, content: 'Create 5 simple project ideas on: [idea]' },
        basic_factsheet: { name: :basic_factsheet, content: 'I need you to gather detailed and reliable information about the idea' }
      },
      attributes: {
        idea: { name: :idea, type: :string, is_array: false },
        ideas: { name: :ideas, type: :array, is_array: false }
      },
      sections: [
        {
          name: 'Research',
          order: 1,
          steps: [
            {
              name: 'Basic Idea',
              order: 1,
              input_attributes: [:idea],
              output_attributes: [:ideas],
              prompt: :working_idea
            }
          ]
        }
      ]
    }
  end
  let(:display) { false }
  let(:clipboard) { false }

  let(:generator) { described_class.new(workflow_hash, display: display, clipboard: clipboard) }

  describe '#dsl_for_attributes' do
    subject { generator.dsl_for_attributes.gsub(/\s+/, ' ') }

    it 'generates the correct DSL for attributes' do
      expect(subject)
        .to include('attributes do')
        .and include('attribute :idea, type: :string')
        .and include('attribute :ideas, type: :array')
        .and include('end')
    end
  end

  describe '#dsl_for_prompts' do
    subject { generator.dsl_for_prompts.gsub(/\s+/, ' ') }

    it 'generates the correct DSL for prompts' do
      expect(subject)
        .to include('prompts do')
        .and include('prompt :working_idea, content: "Create 5 simple project ideas on: [idea]"')
        .and include('prompt :basic_factsheet, content: "I need you to gather detailed and reliable information about the idea"')
        .and include('end')
    end
  end

  describe '#dsl_for_sections' do
    subject { generator.dsl_for_sections.gsub(/\s+/, ' ') }

    it 'generates the correct DSL for sections' do
      expect(subject)
        .to include("section('Research') do")
        .and include("step('Basic Idea') do")
        .and include('input :idea')
        .and include('prompt :working_idea')
        .and include('output :ideas')
    end
  end

  describe '#dsl_for_settings' do
    subject { generator.dsl_for_settings.gsub(/\s+/, ' ') }

    it 'generates the correct DSL for settings' do
      expect(subject)
        .to include('settings do')
        .and include('prompt_path "spec/fixtures/prompts"')
        .and include('end')
    end
  end

  describe '#dsl_for_workflow' do
    subject { generator.dsl_for_workflow.gsub(/\s+/, ' ') }

    it 'generates the correct DSL for the entire workflow' do
      expect(subject)
        .to include("Agent.create('YouTube Script Writer') do")
        .and include('settings do')
        .and include('prompt_path "spec/fixtures/prompts"')
        .and include('attributes do')
        .and include('attribute :idea, type: :string')
        .and include('prompts do')
        .and include('prompt :working_idea, content: "Create 5 simple project ideas on: [idea]"')
        .and include("section('Research') do")
        .and include("step('Basic Idea') do")
        .and include('input :idea')
        .and include('prompt :working_idea')
        .and include('output :ideas')
    end
  end
end
