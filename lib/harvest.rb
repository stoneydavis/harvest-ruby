# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require 'harvest/version'
require 'harvest/resourcefactory'
require 'harvest/httpclient'
require 'harvest/exceptions'
require 'harvest/clientmixin'

def convert_to_sym(data)
  return data.map { |k, v| [k.to_sym, convert_to_sym(v)] }.to_h if data.respond_to?('keys')

  return data.map { |v| convert_to_sym(v) } if data.respond_to?('each')

  data
end

module Harvest
  # Harvest client interface
  class Client
    include HarvestClientContextMixin
    attr_reader :active_user, :client, :time_entries, :factory
    attr_accessor :state

    # @param domain [String] Harvest domain ex: https://company.harvestapp.com
    # @param account_id [Integer] Harvest Account id
    # @param personal_token [String] Harvest Personal token
    # @param admin_api [Boolean] Changes functionality of how the interface works
    def initialize(domain:, account_id:, personal_token:, admin_api: false)
      @client = Harvest::HTTP::Client.new(
        domain: domain,
        account_id: account_id,
        personal_token: personal_token
      )
      @admin_api = admin_api
      @factory = Harvest::ResourceFactory.new
      @state = ''
      @active_user = @factory.user(@client.api_call('/users/me'))
    end

    # Find single instance of resource
    def find(id:)
      # binding.pry
      case @state
      when 'projects'
        @projects = [@factory.project(@client.api_call("projects/#{id}"))]
        self
      end
    end

    # Discover resources
    def discover(**params)
      case @state
      when 'projects'
        if @admin_api && @active_user.is_admin
          @projects = admin_projects
        else
          @projects = project_assignments
        end
      when 'project_tasks'
        @tasks = @projects[0]
                 .task_assignments
      when 'time_entry'
        @time_entries = select_time_entries(**params)
      when ''
        raise BadState 'Requires a state to call this method'
      end
      self
    end

    # Select a subset of all items depending on state
    def select(&block)
      case @state
      when 'projects'
        @projects.select(&block)
      when 'project_tasks'
        @tasks.select(&block)
      when 'time_entry'
        @time_entries.select(&block)
      when ''
        raise BadState 'Requires a state to call this method'
      end
    end

    # Create an instance of object based on state
    def create(**kwargs)
      case @state
      when 'time_entry'
        # required_keys = %i[spent_date]
        # TODO: check if keys required are present and raise if not
        payload = time_entry_payload(kwargs)
        begin
          @client.api_call(
            'time_entries',
            http_method: 'post',
            payload: payload.to_json,
            headers: { content_type: 'application/json' }
          )
        rescue RestClient::UnprocessableEntity => e
          puts "Harvest Error from Create Time Entry: #{JSON.parse(e.response.body)['message']}"
          raise
        end
      end
    end

    # private

    # @api private
    # Some API calls will return Project others ProjectAssignment.
    def true_project(project)
      return project.project if project.is_a?(Harvest::ProjectAssignment)

      project
    end

    # @api private
    def time_entry_payload(kwargs)
      possible_keys = %i[spent_date notes external_reference user_id]
      payload = kwargs.map { |k, v| [k, v] if possible_keys.include?(k) }.to_h
      payload[:user_id] ||= @active_user.id
      payload[:task_id] = @tasks[0].task.id
      payload[:project_id] = true_project(@projects[0]).id
      payload
    end

    # @api private
    # All Projects
    def admin_projects
      @client.api_call('projects')['projects']
        .map { |project| @factor.project(project) }
    end

    # @api private
    # Time Entries
    def select_time_entries(**params)
      paginator = @client.paginator
      paginator.path = 'time_entries'
      paginator.data_key = 'time_entries'
      paginator.param = params
      @client.pagination(paginator).map do |time_entry|
        @factory.time_entry(time_entry)
      end
    end

    # @api private
    # Projects assigned to the specified user_id
    def project_assignments(user_id: active_user.id)
      convert_to_sym(@client.api_call("users/#{user_id}/project_assignments")['project_assignments'])
        .map do |project|
          @factory.project_assignment(project)
        end
    end
  end
end
