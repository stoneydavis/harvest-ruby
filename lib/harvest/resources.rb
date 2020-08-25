# frozen_string_literal: true

require 'harvest/resources/client'
require 'harvest/resources/project'
require 'harvest/resources/project_assignment'
require 'harvest/resources/task'
require 'harvest/resources/task_assignment'
require 'harvest/resources/timeentry'
require 'harvest/resources/user'

module Harvest
  # Conversion for hash to Struct including nested items.
  class ResourceFactory
    def project_assignment(data)
      d = Harvest::ProjectAssignment.new(data)
      d.project = project(d.project)
      d.task_assignments = d.task_assignments.map { |ta| task_assignment(ta) }
      d.client = client(d.client)
      convert_dates(d)
    end

    def project(data)
      d = Harvest::Project.new(data)
      convert_dates(d)
    end

    def client(data)
      d = Harvest::ResourceClient.new(data)
      convert_dates(d)
    end

    def task_assignment(data)
      d = Harvest::TaskAssignment.new(data)
      d.task = task(d.task)
      convert_dates(d)
    end

    def task(data)
      d = Harvest::Task.new(data)
      d
    end

    def user(data)
      d = Harvest::User.new(data)
      convert_dates(d)
    end

    def time_entry(data)
      # binding.pry
      d = Harvest::TimeEntry.new(data)
      convert_dates(d)
    end

    private

    def convert_dates(data)
      data.created_at = DateTime.strptime(data.created_at) unless data.created_at.nil?
      data.updated_at = DateTime.strptime(data.updated_at) unless data.updated_at.nil?
      data
    end
  end
end
