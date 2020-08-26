# frozen_string_literal: true

require 'harvest/resources/client'
require 'harvest/resources/project'
require 'harvest/resources/project_assignment'
require 'harvest/resources/task'
require 'harvest/resources/task_assignment'
require 'harvest/resources/timeentry'
require 'harvest/resources/user'
require 'harvest/resources/user_assignment'

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
      # task may not be present in TaskAssignment's from TimeEntry
      d.task = task(d.task) unless d.task.nil?
      convert_dates(d)
    end

    def task(data)
      d = Harvest::Task.new(data)
      convert_dates(d)
    end

    def user(data)
      d = Harvest::User.new(data)
      convert_dates(d)
    end

    def user_assignment(data)
      d = Harvest::UserAssignment.new(data)
      convert_dates(d)
    end

    def time_entry_external_reference(data)
      Harvest::TimeEntryExternalReference.new(data)
    end

    def time_entry(data)
      d = Harvest::TimeEntry.new(data)
      d.user = user(d.user)
      d.task_assignment = task_assignment(d.task_assignment)
      d.task = task(d.task)
      d.user_assignment = user_assignment(d.user_assignment)
      d = convert_project_client(d)
      d.external_reference = time_entry_external_reference(d.external_reference)
      convert_dates(d)
    end

    private

    def convert_project_client(data)
      data.project = project(data.project)
      data.client = client(data.client)
      data
    end

    def convert_dates(data)
      data.created_at = DateTime.strptime(data.created_at) unless data.created_at.nil?
      data.updated_at = DateTime.strptime(data.updated_at) unless data.updated_at.nil?
      data
    end
  end
end
