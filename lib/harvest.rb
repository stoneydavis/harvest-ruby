# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require "harvest/version"

def hash_to_struct(hash, struct)
  struct.new(*hash.values_at(*struct.members))
end

def convert_to_sym(data)
  return data.map { |k, v| [k.to_sym, convert_to_sym(v)] }.to_h if data.respond_to?('keys')

  return data.map { |v| convert_to_sym(v) } if data.respond_to?('each')

  data
end

module Harvest
  class Error < StandardError; end
  class BadState < Error; end
  class ProjectError < Error; end
  class TooManyProjects < ProjectError; end
  class NoProjectsFound < ProjectError; end

  # Harvest client, all other resources inherit from this class
  class Client
    attr_reader :active_user, :client
    attr_accessor :state
    # @param domain [String] Harvest domain ex: https://company.harvestapp.com
    # @param account_id [Integer] Harvest Account id
    # @param personal_token [String] Harvest Personal token
    # @param admin_api [Boolean] Changes functionality of how the interface works
    def initialize(domain:, account_id:, personal_token:, admin_api: false)
      @client = RestClient::Resource.new(
        domain.chomp('/') + '/api/v2',
        { headers: headers(personal_token, account_id) }
      )
      @admin_api = admin_api
      @state = ''
      @active_user = hash_to_struct(
        convert_to_sym(JSON.parse(@client['/users/me'].get)),
        Harvest::User
      )
    end

    # Find task assignments for a project
    def tasks
      case @state
      when 'projects'
        raise TooManyProjects if @projects.length > 1

        raise ProjectError('No Task Assignments found') unless @projects[0].task_assignments

        @projects[0].task_assignments
          .map { |ta| yield ta }.reject(&:nil?)
      when ''
        raise NoProjectsFound
      end
    end

    def find
      binding.pry
      # case @state
      # when 'projects'

      # end
    end

    # Select a subset of all items depending on state
    def select
      case @state
      when 'projects'
        if @admin_api && @active_user.is_admin
          # ex block: { |project| project if project.name == "Customer Name" }
          # TODO: Add support for all projects with pagination
          admin_projects
            .map { |project| yield(project) }.reject(&:nil?)
        else
          # ex block: { |pa| pa if pa.project.name == "Customer Name" }
          # ex block: { |pa| pa if pa.project[:name] == "Customer Name" }
          @projects = project_assignments
                      .map { |project| yield project }.reject(&:nil?)
        end
        self
      when ''
        raise BadState 'Requires a state to call this method'
      end
    end

    # Make a api call to an endpoint.
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def api_call(path, http_method: 'get', param: nil, data: nil)
      JSON.parse(@client[path].method(http_method).call(param: param, data: data))
    end

    # Pagination through request
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def pagination(path, data_key, http_method: 'get', param: nil, data: nil)
      # TODO: tail call optimization
      param ||= {}

      param[:page] = 1 unless param.key?(:page)

      http_resp = api_call(path, http_method, param, data)

      resp = http_resp[data_key]

      until http_resp['total_pages'] >= param[:page]
        param[:page] += 1
        http_resp = api_call(path, http_method, param, data)
        resp.concat(http_resp[data_key])
      end
      resp
    end

    # @api private
    # All Projects
    def admin_projects
      convert_to_sym(api_call('projects')['projects'])
        .map { |project| hash_to_struct(project, Harvest::Project) }
    end

    # @api private
    # Projects assigned to the specified user_id
    def project_assignments(user_id: active_user.id)
      convert_to_sym(api_call("users/#{user_id}/project_assignments")['project_assignments'])
        .map do |project|
          pa = hash_to_struct(project_assignment, Harvest::ProjectAssignment)
          pa.project = hash_to_struct(pa.project, Harvest::Project)
          pa.client = hash_to_struct(pa.client, Harvest::ResourceClient) # Had to change because my API Client is `Client`
          pa.task_assignments = pa.task_assignments.map { |ta| hash_to_struct(ta, Harvest::TaskAssignment) }
          pa.created_at = DateTime.strptime(pa.created_at)
          pa.updated_at = DateTime.strptime(pa.updated_at)

          pa
        end
    end

    # Change context to projects
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
    :updated_at,
    :task_assignments
  ) do
  end

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

  TaskAssignment = Struct.new(
    :id,
    :billable,
    :is_active,
    :created_at,
    :updated_at,
    :hourly_rate,
    :budget,
    :task
  ) do
    def to_task
      hash_to_struct(self.to_h[:task], Harvest::Task)
    end
  end

  Task = Struct.new(
    :id,
    :name,
    :billable_by_default,
    :default_hourly_rate,
    :is_default,
    :is_active,
    :created_at,
    :updated_at
  ) do
  end
  ResourceClient = Struct.new(
    :id,
    :name,
    :is_active,
    :address,
    :statement_key,
    :currency,
    :created_at,
    :updated_at
  ) do
  end
end
