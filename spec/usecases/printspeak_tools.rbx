start_time = Time.now

dsl = Agent.create(:printspeak_tools) do
  description 'Rails Upgrade tools for Printspeak'
  settings do
    prompt_path Ad::AgentArchitecture.gem_relative_file('prompts/printspeak_tools')
    default_llm :gpt4o
  end

  prompts do
    prompt :new_route_prompt, content: load_file("1-1-new-route-prompt.md")
    prompt :extras_prompt, content: load_file("1-2-extras.md")
    prompt :analyse_controller_prompt, content: load_file("1-3-analyse-controller.md")
    prompt :analyse_view_prompt, content: load_file("1-4-analyse-view.md")
    prompt :improve_view_prompt, content: load_file("1-5-improve-view.md")
    prompt :query_equivalence, content: load_file("1-9-query_equivalence.md")

    prompt :sql_to_query_class, content: load_file("2-1-sql_to_query_class.md")
    prompt :sql_active_record_compare, content: load_file("2-2-sql_active_record_compare.md")
    
    prompt :query_class_spec, content: load_file("3-2-query_class_spec.md")
  end

  attributes do
    attribute :existing_route, type: :string
    attribute :existing_menu, type: :string
    attribute :report_routes, type: :array
    attribute :view, type: :string
    attribute :view_analysis, type: :string
    attribute :old_query, type: :string
    attribute :new_query, type: :string

    attribute :query_name, type: :string
    attribute :query, type: :string
    attribute :query_class, type: :string
    attribute :controller_class, type: :string
    attribute :presenter_class, type: :string
    attribute :sql, type: :string
    attribute :sql_active_record_compare, type: :string
  end

  section('Analyse Reports') do
    step('Setup Route') do
      input :existing_route
      input :report_routes
      prompt :new_route_prompt
      output :report_routes
    end

    step('Extras') do
      input :existing_route
      input :existing_menu
      prompt :extras_prompt
    end

    step('Analyse Controller') do
      input :old_controller
      prompt :analyse_controller_prompt
      output :controller
    end

    step('Analyse Presenter') do
      # input :controller
      # prompt :analyse_controller
      # output :controller_analysis
    end

    <<-STRING

    Can you find flaws in the view based on the following

    - Are there global @variables and that can be renamed to presenter
    - Is there logic that should be in a presenter and how would the code look for the presenter
    - Can you extract any SQL and put it into a code block and give it a 2-3 word name to represent the name of a QUERY object. If you there is more then one SQL block then create a named code block for each.
    - 



    Examples
    @tenant should be presenter.tenant

    Input:
    ```sql-in-view
    <%
    select id, name, title from tenants
    %>
    ```

    Output:
    # TenantListQuery

    ```named-sql
    select id, name, title from tenants
    ```

    
    STRING

    step('Analyse View') do
      input :view
      prompt :analyse_view_prompt
      output :view_analysis
    end

    step('Make View Improvements') do
      input :view
      input :view_analysis
      input :controller_class
      input :presenter_class
      input :query_class
      prompt :improve_view_prompt
      output :view
    end

    # step('Query Equivalence') do
    #   input :old_query
    #   input :new_query
    #   prompt :query_equivalence
    #   output :query_equivalence
    # end
  end

  section('DB Conversion') do
    step('SQL to Query Object') do
      input :query_name
      input :query
      prompt :sql_to_query_class
      output :query_class      
    end

    step('Check SQL/Active Record Equivalence') do
      input :sql
      input :query
      prompt :sql_active_record_compare
      output :sql_active_record_compare
    end
  end

  section('Generate Code') do
    step('Create Query') do
      input :query_class
      prompt :query_class_spec
      output :query_class_spec
    end

    step('Create Query Spec') do
      input :query_class
      prompt :query_class_spec
      output :query_class_spec
    end

    step('Create Presenter') do
      input :query_class
      prompt :query_class_spec
      output :query_class_spec
    end

    step('Create Controller') do
      input :query_class
      prompt :query_class_spec
      output :query_class_spec
    end
  end
end

file = '/Users/davidcruwys/dev/sites/working-with-sean/gpt-agents/src/content/gpt-workflows/printspeak-tools.json'
dsl
  .save
  .save_json(file)

puts "Time taken: #{Time.now - start_time} seconds"
