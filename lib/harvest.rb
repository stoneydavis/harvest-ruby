# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require 'harvest/version'
require 'harvest/resources'

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

  # Harvest client interface
  class Client
    attr_reader :active_user, :client, :time_entries, :factory
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
      @factory = Harvest::ResourceFactory.new
      @state = ''
      @active_user = @factory.user(JSON.parse(@client['/users/me'].get))
    end

    # Change context to projects
    def projects
      change_context('projects')
    end

    # Change context to time_entry
    def time_entry
      case @state
      when 'project_tasks'
        raise NoProjectTasks if @tasks.length.zero?

        raise TooManyTasks if @tasks.length > 1

        change_context('time_entry')
      when ''
        change_context('time_entry')
      end
    end

    # Find task assignments for a project
    def tasks
      case @state
      when 'projects'
        raise TooManyProjects if @projects.length > 1

        raise NoProjectsFound if @projects.length.zero?

        raise ProjectError('No Task Assignments found') unless @projects[0].task_assignments

        change_context('project_tasks')
      when ''
        raise BadState 'Requires a state to call this method'
      end
    end

    # Find single instance of resource
    def find(id:)
      # binding.pry
      case @state
      when 'projects'
        @projects = [@factory.project(api_call("projects/#{id}"))]
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
      self
    end

    # Create an instance of object based on state
    def create(**kwargs)
      case @state
      when 'time_entry'
        # required_keys = %i[spent_date]
        # TODO: check if keys required are present and raise if not
        payload = time_entry_payload(kwargs)
        begin
          api_call(
            'time_entries',
            http_method: 'post',
            payload: payload.to_json,
            headers: { content_type: 'application/json' }
          )
        rescue RestClient::UnprocessableEntity => e
          puts "Harvest Error from Create Time Entry: #{JSON.parse(e.response.body)['message']}"
          binding.pry
        end
      end
    end

    # private

    # Make a api call to an endpoint.
    # @api private
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def api_call(path, http_method: 'get', param: nil, payload: nil, headers: nil)
      # RestClient::Request.process_url_params is looking for query params in the headers obj,
      headers ||= {}
      headers['params'] = param
      case http_method
      when 'get'
        http_resp = @client[path].get(headers)
        JSON.parse(http_resp)
      when 'post'
        @client[path].post(payload, headers)
      end
    end

    # Pagination through request
    # @api private
    # @param path [String] Url path part omitting preceeding slash
    # @param method [String] HTTP Method to call
    # @param param [Hash] Query Params to pass
    # @param data [Hash] Body of HTTP request
    def pagination(path, data_key, http_method: 'get', page_count: 1, param: nil, payload: nil, entries: nil)
      # TODO: tail call optimization
      param ||= {}
      entries ||= []

      param[:page] = page_count

      page = api_call(path, http_method: http_method, param: param, payload: payload)
      entries.concat(page[data_key])

      return entries if page_count >= page['total_pages']

      page_count += 1
      pagination(
        path,
        data_key,
        http_method: http_method,
        page_count: page_count,
        param: param,
        payload: payload,
        entries: entries
      )
    end

    # @api private
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
    def select_projects
    end

    # @api private
    def select_project_tasks
    end

    # @api private
    # All Projects
    def admin_projects
      api_call('projects')['projects']
        .map { |project| @factor.project(project) }
    end

    # @api private
    # Time Entries
    def select_time_entries(**params)
      pagination('time_entries', 'time_entries', param: params).map do |time_entry|
        @factory.time_entry(time_entry)
      end
    end

    # @api private
    # Projects assigned to the specified user_id
    def project_assignments(user_id: active_user.id)
      convert_to_sym(api_call("users/#{user_id}/project_assignments")['project_assignments'])
        .map do |project|
          @factory.project_assignment(project)
        end
    end

    # @api private
    def change_context(new_state)
      n = self.dup
      n.state = new_state
      n
    end

    # @api private
    def headers(personal_token, account_id)
      {
        'User-Agent' => 'Ruby Harvest API Sample',
        'Authorization' => "Bearer #{personal_token}",
        'Harvest-Account-ID' => account_id
      }
    end
  end
end
