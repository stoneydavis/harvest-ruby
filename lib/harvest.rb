# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require 'harvest/version'
require 'harvest/resourcefactory'
require 'harvest/httpclient'
require 'harvest/exceptions'
require 'harvest/finders'

module Harvest
  # Harvest client interface
  class Client
    attr_reader :active_user, :client, :time_entries, :factory, :state

    # @param domain [String] Harvest domain ex: https://company.harvestapp.com
    # @param account_id [Integer] Harvest Account id
    # @param personal_token [String] Harvest Personal token
    # @param admin_api [Boolean] Changes functionality of how the interface works
    def initialize(domain:, account_id:, personal_token:, admin_api: false, state: { filtered: {} })
      # load_finders
      @FINDERS = {
        projects: lambda do |id|
          [@factory.resource(:project, @client.api_call(@client.api_caller("projects/#{id}")))]
        end,
        time_entry: lambda do |id|
          [@factory.time_entry(@client.api_call(@client.api_caller("time_entry/#{id}")))]
        end
      }

      @DISCOVERER = {
        projects: ->(_params) { @admin_api ? admin_projects : project_assignments },
        project_tasks: ->(_params) { @state[:filtered][:projects][0].task_assignments },
        time_entry: ->(params) { select_time_entries(**params) }
      }

      @CREATORS = {
        projects: ->(_kwargs) {},
        project_tasks: ->(_kwargs) {},
        time_entry: lambda do |kwargs|
          # required_keys = %i[spent_date]
          # TODO: check if keys required are present and raise if not
          payload = time_entry_payload(kwargs)
          begin
            @factory.time_entry(
              @client.api_call(
                @client.api_caller(
                  'time_entries',
                  http_method: 'post',
                  payload: payload.to_json,
                  headers: { content_type: 'application/json' }
                )
              )
            )
          rescue RestClient::UnprocessableEntity => e
            puts "Harvest Error from Create Time Entry: #{JSON.parse(e.response.body)['message']}"
            raise
          end
        end

      }

      @config = { domain: domain, account_id: account_id, personal_token: personal_token }
      @client = Harvest::HTTP::Api.new(**@config)
      @factory = Harvest::ResourceFactory.new
      @state = state
      @active_user = @factory.user(@client.api_call(@client.api_caller('/users/me')))
      @admin_api = if @active_user.is_admin
                     admin_api
                   else
                     false
                   end
    end

    def allowed?(meth)
      %i[
        projects
        project_tasks
        time_entry
        tasks
      ].include?(meth)
    end

    def method_missing(meth, *args)
      if allowed?(meth)
        Harvest::Client.new(
          **@config.merge(
            {
              admin_api: @admin_api,
              state: @state.merge(meth => args.first ? !args.first.nil? : [], active: meth)
            }
          )
        )
      else

        super
      end
    rescue NoMethodError
      # binding.pry
    end

    # Find single instance of resource
    def find(id)
      @state[@state[:active]] = @FINDERS[@state[:active]].call(id)
      self
    end

    # Discover resources
    def discover(**params)
      @state[@state[:active]] = @DISCOVERER[@state[:active]].call(params)
      self
    end

    # Select a subset of all items depending on state
    def select(&block)
      @state[:filtered][@state[:active]] = @state[@state[:active]].select(&block)
      self
    end

    # Create an instance of object based on state
    def create(**kwargs)
      @state[@state[:active]] = @CREATORS[@state[:active]].call(kwargs)
      self
    end

    # private

    # @api private
    # Some API calls will return Project others ProjectAssignment.
    def true_project(project)
      return project.project if project.respond_to?(:project)

      project
    end

    # @api private
    def time_entry_payload(kwargs)
      possible_keys = %i[spent_date notes external_reference user_id]
      payload = kwargs.map { |k, v| [k, v] if possible_keys.include?(k) }.to_h
      payload[:user_id] ||= @active_user.id
      payload[:task_id] = @state[:filtered][:project_tasks][0].task.id
      payload[:project_id] = true_project(@state[:filtered][:projects][0]).id
      payload
    end

    # @api private
    # All Projects
    def admin_projects
      @client
        .api_call(
          @client.api_caller('projects')
        )['projects']
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
      @client
        .api_call(
          @client.api_caller(
            "users/#{user_id}/project_assignments"
          )
        )['project_assignments']
        .map do |project|
          @factory.project_assignment(project)
        end
    end

    def load_finders
      binding.pry
      Harvest::Finders.constants.each do |finder|
        @FINDERS[finder.downcase] = finder.new(@client, @factory)
      end
    end
  end
end
