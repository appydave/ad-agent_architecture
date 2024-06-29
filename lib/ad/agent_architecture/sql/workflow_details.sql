SELECT
  workflows.id AS workflow_id,
  workflows.name AS workflow_name,
  workflows.description AS workflow_description,
  sections.id AS section_id,
  sections.name AS section_name,
  sections.description AS section_description,
  sections."order" AS section_order,
  steps.id AS step_id,
  steps.name AS step_name,
  steps."order" AS step_order,
  steps.prompt AS step_prompt,
  json_group_array(
    json_object(
      'name', input_attr.name,
      'type', input_attr.type,
      'is_array', input_attr.is_array
    )
  ) AS inputs,
  json_group_array(
    json_object(
      'name', output_attr.name,
      'type', output_attr.type,
      'is_array', output_attr.is_array
    )
  ) AS outputs
FROM workflows
LEFT JOIN sections ON workflows.id = sections.workflow_id
LEFT JOIN steps ON sections.id = steps.section_id
LEFT JOIN input_attributes ON steps.id = input_attributes.step_id
LEFT JOIN attributes AS input_attr ON input_attributes.attribute_id = input_attr.id
LEFT JOIN output_attributes ON steps.id = output_attributes.step_id
LEFT JOIN attributes AS output_attr ON output_attributes.attribute_id = output_attr.id
GROUP BY workflows.id, sections.id, steps.id
ORDER BY workflows.name, sections."order", steps."order";
