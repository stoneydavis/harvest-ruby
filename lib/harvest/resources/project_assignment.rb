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
    :task_assignments
  ) do
    def to_project
      binding.pry
      project = self.to_h[:project]
      project[:client] = client
      project[:task_assignments] = task_assignments
      hash_to_struct(project, Harvest::Project)
    end
  end
end
