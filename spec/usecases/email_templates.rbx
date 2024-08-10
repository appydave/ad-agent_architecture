start_time = Time.now

dsl = Agent.create(:email_templates) do
  description 'This workflow generates email bodies for different scenarios.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/email_templates')
    default_llm :gpt4o
  end

  prompts do
    prompt :complaint_email           , content: load_file("1-1-complaint.txt")
    prompt :sponsorship_request       , content: load_file("1-2-sponsorship_request.txt")
    prompt :professional_tone         , content: load_file("2-1-professional_tone.txt")
    prompt :personal_tone             , content: load_file("2-2-personal_tone.txt")
  end

  attributes do
    attribute :email_context, type: :string
    attribute :email_body, type: :string
    attribute :improved_email_body, type: :string
  end

  section('Email Templates') do
    step('Complaint') do
      input :email_context
      prompt :complaint_email
      output :email_body
    end

    step('Sponsorship Request') do
      input :email_context
      prompt :sponsorship_request
      output :email_body
    end
  end

  section('Email Styles') do
    step('Professional Tone') do
      input :email_body
      prompt :professional_tone
      output :improved_email_body
    end

    step('Personal Tone') do
      input :email_body
      prompt :professional_tone
      output :improved_email_body
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/email-templates.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
