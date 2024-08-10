start_time = Time.now

dsl = Agent.create(:claim_investigation_assessment) do
  description 'This workflow is used to investigate and assess an insurance claim.'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/youtube/script_writer')
    default_llm :gpt4o
  end

  prompts do
    prompt :working_idea          , content: load_file("01-1-working-idea.txt")
  end

  attributes do
    attribute :claim_details, type: :string
    attribute :damage_report, type: :string
    attribute :policy_details, type: :string
    attribute :fraud_check_result, type: :string
    attribute :assessment_summary, type: :string
  end

  section('Initial Investigation') do
    step('Receive Initial Claim Report') do
      input :claim_details
      prompt :working_idea
      output :claim_details
    end

    step('Preliminary Damage Assessment') do
      input :claim_details
      prompt :working_idea
      output :damage_report
    end
  end

  section('Detailed Evaluation') do
    step('Evaluate Policy Coverage') do
      input :claim_details
      input :damage_report
      prompt :working_idea
      output :policy_details
    end

    step('Conduct Fraud Check') do
      input :claim_details
      input :damage_report
      prompt :working_idea
      output :fraud_check_result
    end
  end

  section('Final Assessment') do
    step('Compile Final Assessment') do
      input :claim_details
      input :damage_report
      input :policy_details
      input :fraud_check_result
      prompt :working_idea
      output :assessment_summary
    end
  end
end

file1 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/b.json'
dsl
  .save
  .save_json(file1)

last_workflow = Ad::AgentArchitecture::Database::Workflow.order(Sequel.desc(:id)).first

data = Ad::AgentArchitecture::Report::AgentDataBuilder.new(last_workflow.id).build

file1 = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/b.json'
File.write(file1, JSON.pretty_generate(data))

puts "Time taken: #{Time.now - start_time} seconds"
