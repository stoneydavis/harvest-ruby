# frozen_string_literal: true

require 'json'
require 'date'
require 'rest-client'

require 'harvest/version'
require 'harvest/resourcefactory'
require 'harvest/httpclient'
require 'harvest/exceptions'
require 'harvest/finders'
require 'harvest/discovers'
require 'harvest/creates'

def to_class_name(key)
  key.to_s.split('_').map { |e| e.capitalize }.join.to_sym
end

module Harvest
  # Harvest client interface
  class Client
    attr_reader :active_user, :client, :time_entries, :factory, :state

    # @param domain [String] Harvest domain ex: https://company.harvestapp.com
    # @param account_id [Integer] Harvest Account id
    # @param personal_token [String] Harvest Personal token
    # @param admin_api [Boolean] Changes functionality of how the interface works
    def initialize(domain:, account_id:, personal_token:, admin_api: false, state: { filtered: {} })
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
      @state[@state[:active]] = Harvest::Finders.const_get(to_class_name(@state[:active])).new.find(@factory, @client, id)
      self
    end

    # Discover resources
    def discover(**params)
      @state[@state[:active]] = Harvest::Discovers.const_get(to_class_name(@state[:active])).new.discover(
        @admin_api, @client, @factory, active_user, @state, params
      )
      self
    end

    # Select a subset of all items depending on state
    def select(&block)
      @state[:filtered][@state[:active]] = @state[@state[:active]].select(&block)
      self
    end

    # Create an instance of object based on state
    def create(**kwargs)
      @state[@state[:active]] = Harvest::Create.const_get(to_class_name(@state[:active])).new.create(
        @factory, @client, active_user, @state, kwargs
      )
      self
    end

    # private

    # @api private
    # Some API calls will return Project others ProjectAssignment.
  end
end
