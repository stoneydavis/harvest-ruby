# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require 'harvest/version'
require 'harvest/resources'

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

    # Change context to projects
    def projects
      n = self.dup
      n.state = 'projects'
      n
    end

    # 
    def time_entry()
      case @state
      when 'project_tasks'
        raise NoProjectTasks if @tasks.length == 0

        raise TooManyTasks if @tasks.length > 1

        api_call('time_entry', 'post')
      end
    end

    # Find task assignments for a project
    def tasks
      case @state
      when 'projects'
        raise TooManyProjects if @projects.length > 1

        raise NoProjectsFound if @projects.nil?

        raise ProjectError('No Task Assignments found') unless @projects[0].task_assignments

        n = self.dup
        n.state = 'project_tasks'
        n

      when ''
        raise BadState 'Requires a state to call this method'
      end
    end

    def find
      binding.pry
      # case @state
      # # when 'projects'
      # when 'project_tasks'
      #   @projects[0].task_assignments
      #     .map { |ta| yield ta }.reject(&:nil?)
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
      when 'project_tasks'
        @tasks = @projects[0].task_assignments
          .map { |ta| yield ta }.reject(&:nil?)
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
          pa = hash_to_struct(project, Harvest::ProjectAssignment)
          pa.project = hash_to_struct(pa.project, Harvest::Project)
          pa.client = hash_to_struct(pa.client, Harvest::ResourceClient) # Had to change because my API Client is `Client`
          pa.task_assignments = pa.task_assignments.map { |ta| hash_to_struct(ta, Harvest::TaskAssignment) }
          pa.created_at = DateTime.strptime(pa.created_at)
          pa.updated_at = DateTime.strptime(pa.updated_at)
          pa
        end
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
end
