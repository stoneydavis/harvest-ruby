# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the task assignment.
  # @param project [object]
  #   An object containing the id, name, and code of the associated project.
  # @param task [object]
  #   An object containing the id and name of the associated task.
  # @param is_active [boolean]
  #   Whether the task assignment is active or archived.
  # @param billable [boolean]
  #   Whether the task assignment is billable or not. For example: if set to true, all time tracked on this project for the associated task will be marked as billable.
  # @param hourly_rate [decimal]
  #   Rate used when the project’s bill_by is Tasks.
  # @param budget [decimal]
  #   Budget used when the project’s budget_by is task or task_fees.
  # @param created_at [datetime]
  #   Date and time the task assignment was created.
  # @param updated_at [datetime]
  #   Date and time the task assignment was last updated.
  Struct.new(
    'TaskAssignment',
    :id,
    :billable,
    :is_active,
    :created_at,
    :updated_at,
    :hourly_rate,
    :budget,
    :task,
    keyword_init: true
  )
end
