# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the user assignment.
  # @param project [object]
  #   An object containing the id, name, and code of the associated project.
  # @param user [object]
  #   An object containing the id and name of the associated user.
  # @param is_active [boolean]
  #   Whether the user assignment is active or archived.
  # @param is_project_manager [boolean]
  #   Determines if the user has Project Manager permissions for the project.
  # @param use_default_rates [boolean]
  #   Determines which billable rate(s) will be used on the project for this user when bill_by is People. When true, the project will use the user’s default billable rates. When false, the project will use the custom rate defined on this user assignment.
  # @param hourly_rate [decimal]
  #   Custom rate used when the project’s bill_by is People and use_default_rates is false.
  # @param budget [decimal]
  #   Budget used when the project’s budget_by is person.
  # @param created_at [datetime]
  #   Date and time the user assignment was created.
  # @param updated_at [datetime]
  #   Date and time the user assignment was last updated.
  Struct.new(
    'UserAssignment',
    :id,
    :project,
    :user,
    :is_active,
    :is_project_manager,
    :use_default_rates,
    :hourly_rate,
    :budget,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
