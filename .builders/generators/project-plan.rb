KManager.action :project_plan do
  action do

    DrawioDsl::Drawio
      .init(k_builder, on_exist: :write, on_action: :execute)
      .diagram(rounded: 1, glass: 1)
      .page('In progress', theme: :style_03, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: -50, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y: 190, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        # Prompts need to support file read operation

        todo(title: 'Migrate from alpine to svelte, vue or react')
        
        # todo(title: '')
      end
      .page('To Do', theme: :style_02, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        todo(title: 'SSR/SSG/CLIENT HIBRID')
        todo(title: 'Local Tunnel Integration: https://www.youtube.com/watch?v=D5ArCEjV0gU')
        todo(title: 'Turn into mobile phone app: https://www.youtube.com/watch?v=ZFNwTJiDEvU')
        todo(title: 'Excalabr and TLDraw Integration')
        # todo(title: 'Add hydrate DSL from saved workflow ID')
        # todo(title: 'Add hydrate DSL from saved JSON')
        # todo(title: 'Geneate DSL structure from saved YAML')
        todo(title: 'Add side draw or modal to see the final prompt')
        todo(title: 'Add copy to clipboard button to the final prompt')
        todo(title: 'Add copy to clipboard button to input attribute name as placeholder')
        todo(title: 'Visual graph of the workflow')
        todo(title: 'Visual steps of the workflow')
        todo(title: 'Add select action or custom action to any steps')
        todo(title: 'Add output window for LLM run')
        todo(title: 'Clicking on sections will show the steps in that section')
        todo(title: 'Clicking on attributes will show all attributes in the workflow')
        todo(title: 'Clicking on prompts will show all prompts in the workflow')
        todo(title: 'Clicking on dashboard will show visual hierarchy of the workflow')
        todo(title: 'Need a runs button')
        todo(title: 'VCode Editor: https://chatgpt.com/c/e09e1367-db5e-4786-b362-db35805b1e20')
        todo(title: 'Report: Simple hierarchy of the workflow')
        todo(title: 'Connect to LLM')
        todo(title: 'Connect to Elevenlabs or other TTS')
        todo(title: 'Export: Mindmap')
        todo(title: 'Export: Agent Framework CrewAI')
        todo(title: 'Export: Agent Framework Langchain')
        todo(title: 'Export: Agent Framework Rasa')
        todo(title: 'Export: Agent Framework Botpress')
        todo(title: 'Export: Agent Framework Dialogflow')
        todo(title: 'Export: Agent Framework Microsoft Bot Framework')
      end      
      .page('Done', theme: :style_06, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        todo(title: 'Add dynamic menu support for attributes, prompts, settings and section menus')
        todo(title: 'Fix Alpine Javascript Issues')
        todo(title: 'Steps display horizontally')
        todo(title: 'Add saved workflow ID and save? to the DSL')
        todo(title: 'Prompt set in step DSL will now lookup common prompts')
        todo(title: 'Create tests for Agent Data Builder and hook up to save YAML/JSON')
        todo(title: 'Settings need to persist in the settings or workflow table')
        todo(title: 'Add add title name & description support to Agent Data Builder')
        todo(title: 'Add fluent method access to all DSLs')
        todo(title: 'Generate DSL for an Agent Architecture workflow')
        todo(title: 'Attributes are auto created when used in a step, but not preconfigured')
        todo(title: 'Add support for project plan')
        todo(title: 'Fix the DB issue introduced via DSL refactor')
      end
      .cd(:docs)
      .save('project-plan/project.drawio')
      .export_svg('project-plan/project_in_progress', page: 1)
      .export_svg('project-plan/project_todo'       , page: 2)
      .export_svg('project-plan/project_done'       , page: 3)
  end
end
