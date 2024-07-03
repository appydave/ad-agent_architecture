KManager.action :project_plan do
  action do

    DrawioDsl::Drawio
      .init(k_builder, on_exist: :write, on_action: :execute)
      .diagram(rounded: 1, glass: 1)
      .page('In progress', theme: :style_03, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: -50, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y: 190, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        # Prompts need to support file read operation
        todo(title: 'Visual graph of the workflow')

      end
      .page('To Do', theme: :style_02, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

        todo(title: 'Horizontal')
        todo(title: 'Clicking on sections will show the steps in that section')
        todo(title: 'Clicking on attributes will show all attributes in the workflow')
        todo(title: 'Clicking on prompts will show all prompts in the workflow')
        todo(title: 'Clicking on dashboard will show visual hierarchy of the workflow')
        todo(title: 'Need a runs button')
        todo(title: 'VCode Editor: https://chatgpt.com/c/e09e1367-db5e-4786-b362-db35805b1e20')

      end
      .page('Done', theme: :style_06, margin_left: 0, margin_top: 0) do

        # h5(x: 300, y: 0, w: 400, h: 80, title: 'DrawIO DSL')

        grid_layout(y:90, direction: :horizontal, grid_h: 80, grid_w: 320, wrap_at: 3, grid: 0)

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
