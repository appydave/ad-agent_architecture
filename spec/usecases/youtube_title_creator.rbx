# frozen_string_literal: true

# Usage via DSL
AgentWorkflow.create(name: 'YouTube Title Creator') do
  attributes do
    attribute :title, type: :string
    attribute :working_title, type: :string
    attribute :keywords, type: :array
    attribute :basic_research, type: :string
    attribute :titles, type: :array
  end

  section(name: 'Research') do
    step(name: 'Come up with a simple working title') do
      input :title
      output :working_title

      prompt 'Come up with a simple working title for the video based on [title].'
    end

    step(name: 'Perform basic keyword research') do
      input :working_title
      output :keywords

      prompt 'Perform basic keyword research to identify relevant keywords for [working_title]. Return a list of keywords'
    end

    step(name: 'Conduct basic topic research') do
      input :working_title
      input :keywords
      output :basic_research

      prompt 'Conduct basic topic research to gather information on the subject of [working_title]. Here are the keywords: [keywords].'
    end

    step(name: 'Create a list of potential titles') do
      input :working_title
      input :basic_research
      output :titles

      prompt 'Create a list of potential titles based on the working title, keywords, and basic research.'
    end
  end
end
