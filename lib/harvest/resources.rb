# frozen_string_literal: true

require 'harvest/resources/message'
require 'Hharvest/resources/company'
require 'harvest/resources/user'
require 'harvest/resources/task_assignment'
require 'harvest/resources/user_assignment'
require 'harvest/resources/timeentry'
require 'harvest/resources/estimates'
require 'harvest/resources/client'
require 'harvest/resources/expenses'
require 'harvest/resources/task'
require 'harvest/resources/project'
require 'harvest/resources/project_assignment'
require 'harvest/resources/invoices'

module Harvest
  # Conversion for hash to Struct including nested items.
  # TODO: Refactor for figuring out what Struct should be used
  class ResourceFactory
    def project_assignment(data)
      data ||= {}
      convert_dates(convert_project_client(convert_task_assignments(Harvest::ProjectAssignment.new(data)))) unless data.nil?
    end

    def project(data)
      data ||= {}
      convert_dates(Harvest::Project.new(data)) unless data.nil?
    end

    def client(data)
      data ||= {}
      convert_dates(Harvest::ResourceClient.new(data)) unless data.nil?
    end

    def task_assignment(data)
      data ||= {}
      convert_dates(convert_task(Harvest::TaskAssignment.new(data))) unless data.nil?
    end

    def task(data)
      data ||= {}
      convert_dates(Harvest::Task.new(data)) unless data.nil?
    end

    def user(data)
      data ||= {}
      convert_dates(Harvest::User.new(data)) unless data.nil?
    end

    def user_assignment(data)
      data ||= {}
      convert_dates(Harvest::UserAssignment.new(data)) unless data.nil?
    end

    def time_entry_external_reference(data)
      data ||= {}
      Harvest::TimeEntryExternalReference.new(data)
    end

    def time_entry(data)
      data ||= {}
      unless data.nil?
        convert_dates(
          convert_project_client(
            convert_task_assignment(
              convert_task(
                convert_user_assignment(
                  convert_user(
                    convert_external_reference(
                      Harvest::TimeEntry.new(data)
                    )
                  )
                )
              )
            )
          )
        )
      end
    end

    private

    def convert_external_reference(data)
      data.external_reference = time_entry_external_reference(data.external_reference)
      data
    end

    def convert_user(data)
      data.user ||= {}
      data.user = user(data.user) unless data.nil?
      data
    end

    def convert_user_assignment(data)
      data.user_assignment ||= {}
      data.user_assignment = user_assignment(data.user_assignment) unless data.nil?
      data
    end

    def convert_task_assignment(data)
      data.task_assignment ||= {}

      data.task_assignment = task_assignment(data.task_assignment) unless data.task_assignment.nil?
      data
    end

    def convert_task_assignments(data)
      data.task_assignments = data.task_assignments.map { |ta| task_assignment(ta) } unless data.task_assignments.nil?
      data
    end

    def convert_task(data)
      data.task ||= {}
      data.task = task(data.task) unless data.task.nil?
      data
    end

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
