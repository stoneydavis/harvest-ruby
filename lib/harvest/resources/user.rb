# frozen_string_literal: true

module Harvest
  module Resources
    # @param id [Integer]
    #   Unique ID for the user.
    # @param first_name [String]
    #   The first name of the user.
    # @param last_name [String]
    #   The last name of the user.
    # @param email [String]
    #   The email address of the user.
    # @param timezone [String]
    #   The users timezone.
    # @param has_access_to_all_future_projects [Boolean]
    #   Whether the user should be automatically added to future projects.
    # @param is_contractor [Boolean]
    #   Whether the user is a contractor or an employee.
    # @param is_admin [Boolean]
    #   Whether the user has Admin permissions.
    # @param is_project_manager [Boolean]
    #   Whether the user has Project Manager permissions.
    # @param can_see_rates [Boolean]
    #   Whether the user can see billable rates on projects. Only applicable to Project Managers.
    # @param can_create_projects [Boolean]
    #   Whether the user can create projects. Only applicable to Project Managers.
    # @param can_create_invoices [Boolean]
    #   Whether the user can create invoices. Only applicable to Project Managers.
    # @param is_active [Boolean]
    #   Whether the user is active or archived.
    # @param weekly_capacity [Integer]
    #   The number of hours per week this person is available to work in seconds,
    #   in half hour increments. For example, if a persons capacity is 35 hours,i
    #   the API will return 126000 seconds.
    # @param default_hourly_rate [decimal]
    #   The billable rate to use for this user when they are added to a project.
    # @param cost_rate [decimal]
    #   The cost rate to use for this user when calculating a projects costs vs billable amount.
    # @param roles [List]
    #   of Strings    The role names assigned to this person.
    # @param avatar_url [String]
    #   The URL to the users avatar image.
    # @param created_at [DateTime]
    #   Date and time the user was created.
    # @param updated_at [DateTime]
    #   Date and time the user was last updated.
    # @param name [String] combined first name and last name, only used in TimeEntry
    User = Struct.new(
      'User',
      :id,
      :first_name,
      :last_name,
      :email,
      :telephone,
      :timezone,
      :weekly_capacity,
      :has_access_to_all_future_projects,
      :is_contractor,
      :is_admin,
      :is_project_manager,
      :can_see_rates,
      :can_create_projects,
      :can_create_invoices,
      :is_active,
      :calendar_integration_enabled,
      :calendar_integration_source,
      :created_at,
      :updated_at,
      :roles,
      :avatar_url,
      :name,
      keyword_init: true
    )
  end
end
