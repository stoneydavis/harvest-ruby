# frozen_string_literal: true

module Harvest
  ProjectAssignment = Struct.new(
    :id,
    :is_project_manager,
    :is_active,
    :use_default_rates,
    :budget,
    :created_at,
    :updated_at,
    :hourly_rate,
    :project,
    :client,
    :task_assignments,
    keyword_init: true
  )
end
