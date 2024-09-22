start_time = Time.now

dsl = Agent.create(:rails_generators) do
  description 'Rails Code Generators'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/rails_generators')
    default_llm :gpt4o
  end

  prompts do
    prompt :create_table_migration, content: load_file("1-1-create_table_migration.txt")
  end

  attributes do
    attribute :table_name, type: :string
    attribute :schema, type: :string
    attribute :migration, type: :string
  end

  section('DB Layer') do
    step('Generate Migration') do
      input :table_name
      input :schema
      prompt :create_table_migration
      output :migration
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/rails-generators.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
