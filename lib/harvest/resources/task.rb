# frozen_string_literal: true

module Harvest
  # @param id [Integer]
  #   Unique ID for the task.
  # @param name [String]
  #   The name of the task.
  # @param billable_by_default [Boolean]
  #   Used in determining whether default tasks should be marked billable when
  #   creating a new project.
  # @param default_hourly_rate [decimal]
  #   The hourly rate to use for this task when it is added to a project.
  # @param is_default [Boolean]
  #   Whether this task should be automatically added to future projects.
  # @param is_active [Boolean]
  #   Whether this task is active or archived.
  # @param created_at [DateTime]
  #   Date and time the task was created.
  # @param updated_at [DateTime]
  #   Date and time the task was last updated.
  Struct.new(
    'Task',
    :id,
    :name,
    :billable_by_default,
    :default_hourly_rate,
    :is_default,
    :is_active,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
