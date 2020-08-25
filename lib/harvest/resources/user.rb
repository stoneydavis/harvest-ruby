# frozen_string_literal: true

module Harvest
  # @param :id
  # @param :first_name
  # @param :last_name
  # @param :email
  # @param :telephone
  # @param :timezone
  # @param :weekly_capacity
  # @param :has_access_to_all_future_projects
  # @param :is_contractor
  # @param :is_admin
  # @param :is_project_manager
  # @param :can_see_rates
  # @param :can_create_projects
  # @param :can_create_invoices
  # @param :is_active
  # @param :calendar_integration_enabled
  # @param :calendar_integration_source
  # @param :created_at
  # @param :updated_at
  # @param :roles
  # @param :avatar_url
  User = Struct.new(
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
    keyword_init: true
  )
end
