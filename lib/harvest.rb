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
require 'harvest/changers'

# Conform to naming pattern of Finder, Discover, Creators.
# @param key [Symbol] symbol of state
def to_class_name(key)
  key.to_s.split('_').map(&:capitalize).join.to_sym
end

def merge_state(state, meth, args)
  state.merge(
    meth => args.first ? !args.first.nil? : [],
    active: meth
  )
end

# Harvest
module Harvest
  # Harvest client interface
  class Client
    attr_reader :active_user, :client, :time_entries, :factory, :state

    # @param config [Struct::Config] Configuration Struct which provides attributes
    # @param state [Hash] State of the Client for FluentAPI
    def initialize(config, state: { filtered: {} })
      @config = config
      @client = Harvest::HTTP::Api.new(**@config)
      @factory = Harvest::ResourceFactory.new
      @state = state
      @admin_api = if active_user.is_admin
                     config.admin_api
                   else
                     false
                   end
    end

    def active_user
      @state[:active_user] ||= @factory.user(@client.api_call(@client.api_caller('/users/me')))
    end

    def allowed?(meth)
      %i[
        projects
        project_tasks
        time_entry
        tasks
      ].include?(meth)
    end

    def clone
      Harvest::Client.new(@config, state: @state.clone)
    end

    # @param meth [Symbol]
    # @return [Boolean]
    def respond_to_missing?(meth)
      allowed?(meth)
    end

    # @param meth [Symbol]
    # @param *args [Array] arguments passed to method.
    def method_missing(meth, *args)
      if allowed?(meth)
        Harvest::Client.new(
          @config,
          state: merge_state(@state, meth, args)
        )
      else

        super
      end
    rescue NoMethodError
      # require 'pry'; binding.pry
      raise Harvest::Exceptions::BadState, "#{meth} is an invalid state change."
    end

    # Find single instance of resource
    def find(id)
      @state[@state[:active]] = Harvest::Finders.const_get(
        to_class_name(@state[:active])
      ).new.find(@factory, @client, id)
      self
    end

    # Find single instance of resource
    def change(**kwargs)
      @state[@state[:active]].map do |obj|
        Harvest::Changers.const_get(to_class_name(@state[:active])).new.change(
          @factory, @client, active_user, @state, kwargs
        )
      end
      self
    end
    # Discover resources
    def discover(**params)
      @state[@state[:active]] = Harvest::Discovers
                                .const_get(to_class_name(@state[:active]))
                                .new
                                .discover(
                                  @admin_api, @client, @factory, active_user, @state, params
                                )
      self
    end

    # Create an instance of object based on state
    def create(**kwargs)
      @state[@state[:active]] = Harvest::Create.const_get(
        to_class_name(@state[:active])
      ).new.create(
        @factory, @client, active_user, @state, kwargs
      )
      self
    end

    # Select a subset of all items depending on state
    def select(&block)
      @state[@state[:active]] = @state[@state[:active]].select(&block)
      self
    end

    # Map block of filtered items
    def map(&block)
      @state[@state[:active]].map(&block)
    end

    # Return data from the active state in the base state or filtered.
    def data
      @state[@state[:active]]
    end
  end
end
