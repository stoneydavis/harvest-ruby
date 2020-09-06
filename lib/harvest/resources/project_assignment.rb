# frozen_string_literal: true

module Harvest
  # @param id [Integer]
  #   Unique ID for the project assignment.
  # @param is_active [Boolean]
  #   Whether the project assignment is active or archived.
  # @param is_project_manager [Boolean]
  #   Determines if the user has Project Manager permissions for the project.
  # @param use_default_rates [Boolean]
  #   Determines which billable rate(s) will be used on the project for this
  #   user when bill_by is People. When true, the project will use the user's
  #   default billable rates. When false, the project will use the custom rate
  #   defined on this user assignment.
  # @param hourly_rate [decimal]
  #   Custom rate used when the project's bill_by is People and use_default_rates is false.
  # @param budget [decimal]
  #   Budget used when the project's budget_by is person.
  # @param created_at [DateTime]
  #   Date and time the project assignment was created.
  # @param updated_at [DateTime]
  #   Date and time the project assignment was last updated.
  # @param project [Struct]
  #   An object containing the assigned project id, name, and code.
  # @param client [Struct]
  #   An object containing the project's client id and name.
  # @param task_assignments [List]
  #   Array of task assignment objects associated with the project.
  ProjectAssignment = Struct.new(
    'ProjectAssignment',
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
