# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require "harvest/version"
# Struct.new('IOFiber', :read, :write, :fiber, keyword_init: true)
module Harvest
  class Error < StandardError; end

  # Harvest client, all other resources inherit from this class
  class Client
    attr_reader :active_user
    def initialize(domain:, account_id:, personal_token:)
      @client = RestClient::Resource.new(
        domain.chomp('/') + '/api/v2',
        {
          headers: headers(personal_token, account_id)
        }
      )
      @state = ''
      @active_user = Harvest::User.new(
        *JSON.parse(@client['/users/me'].get)
        .transform_keys { |k| k.to_sym }
        .values_at(*Harvest::User.members)
      )
    end

    def find
    end

    def select
      case @state
      when 'projects'

      end
    end

    def projects
      n = self.dup
      n.state = 'projects'
      n
    end

    private

    def headers(personal_token, account_id)
      {
        'User-Agent' => 'Ruby Harvest API Sample',
        'Authorization' => "Bearer #{personal_token}",
        'Harvest-Account-ID' => account_id
      }
    end
  end

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
    :avatar_url
  ) do
  end

  # https://help.getharvest.com/api-v2/projects-api/projects/projects/
  # @param id [integer]
  #   Unique ID for the project.
  # @param client [object]
  #   An object containing the project’s client id, name, and currency.
  # @param name [string]
  #   Unique name for the project.
  # @param code [string]
  #   The code associated with the project.
  # @param is_active [boolean]
  #   Whether the project is active or archived.
  # @param is_billable [boolean]
  #   Whether the project is billable or not.
  # @param is_fixed_fee [boolean]
  #   Whether the project is a fixed-fee project or not.
  # @param bill_by [string]
  #   The method by which the project is invoiced.
  # @param hourly_rate [decimal]
  #   Rate for projects billed by Project Hourly Rate.
  # @param budget [decimal]
  #   The budget in hours for the project when budgeting by time.
  # @param budget_by [string]
  #   The method by which the project is budgeted.
  # @param budget_is_monthly [boolean]
  #   Option to have the budget reset every month.
  # @param notify_when_over_budget [boolean]
  #   Whether Project Managers should be notified when the project goes over budget.
  # @param over_budget_notification_percentage [decimal]
  #   Percentage value used to trigger over budget email alerts.
  # @param over_budget_notification_date [date]
  #   Date of last over budget notification. If none have been sent, this will be null.
  # @param show_budget_to_all [boolean]
  #   Option to show project budget to all employees. Does not apply to Total Project Fee projects.
  # @param cost_budget [decimal]
  #   The monetary budget for the project when budgeting by money.
  # @param cost_budget_include_expenses [boolean]
  #   Option for budget of Total Project Fees projects to include tracked expenses.
  # @param fee [decimal]
  #   The amount you plan to invoice for the project. Only used by fixed-fee projects.
  # @param notes [string]
  #   Project notes.
  # @param starts_on [date]
  #   Date the project was started.
  # @param ends_on [date]
  #   Date the project will end.
  # @param created_at [datetime]
  #   Date and time the project was created.
  # @param updated_at [datetime]
  #   Date and time the project was last updated.
  Project = Struct.new(
    :bill_by,
    :budget,
    :budget_by,
    :budget_is_monthly,
    :client,
    :code,
    :cost_budget,
    :cost_budget_include_expenses,
    :created_at,
    :ends_on,
    :fee,
    :hourly_rate,
    :id,
    :is_active,
    :is_billable,
    :is_fixed_fee,
    :name,
    :notes,
    :notify_when_over_budget,
    :over_budget_notification_date,
    :over_budget_notification_percentage,
    :show_budget_to_all,
    :starts_on,
    :updated_at
  ) do
  end
end
