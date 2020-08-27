# frozen_string_literal: true

require 'pry'
require 'harvest/resources'

module Harvest
  # Conversion for hash to Struct including nested items.
  # TODO: Refactor for figuring out what Struct should be used
  class NoValidStruct <ArgumentError
  end

  class ResourceFactory
    # def factory(data)
    #   # I don't care what data is other than that Struct will accept it.
    #   data ||= {}
    # end

    def message_recipient(data)
      data ||= {}
      Harvest::MessageRecipient.new(data)
    end

    def company(data)
      data ||= {}
      Harvest::Company.new(data)
    end

    def estimate(data)
      data ||= {}
      convert_estimate_line_items(convert_client(Harvest::Estimate.new(data)))
    end

    def estimate_line_item(data)
      data ||= {}
      Harvest::EstimateLineItem.new(data)
    end

    def estimate_message(data)
      data ||= {}
      Harvest::EstimateMessage.new(data)
    end

    def estimate_item_category(data)
      data ||= {}
      Harvest::EstimateItemCategory.new(data)
    end

    def expense_category(data)
      data ||= {}
      Harvest::ExpenseCategory.new(data)
    end

    def expense(data)
      data ||= {}
      Harvest::Expense.new(data)
    end

    def invoice(data)
      data ||= {}
      Harvest::Invoice.new(data)
    end

    def invoice_line_item(data)
      data ||= {}
      Harvest::InvoiceLineItem.new(data)
    end

    def invoice_message(data)
      data ||= {}
      Harvest::InvoiceMessage.new(data)
    end

    def invoice_payment(data)
      data ||= {}
      Harvest::InvoicePayment.new(data)
    end

    def invoice_item_category(data)
      data ||= {}
      Harvest::InvoiceItemCategory.new(data)
    end

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

    private

    def convert_estimate_line_items(data)
      data.line_items = data.line_items.map { |ta| estimate_line_item(ta) } unless data.line_items.nil?
      data
    end

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

    # @param data [Struct] passed a struct which contains an attribute client
    def convert_client(data)
      data.client = client(data.client)
      data
    end

    def convert_project(data)
      data.project = project(data.project)
      data
    end

    def convert_project_client(data)
      convert_project(convert_client(data))
    end

    def convert_dates(data)
      %i[created_at updated_at sent_at accepted_at declined_at].each do |key|
        if data.members.include?(key) && !data.method(key).call.nil?
          data.method("#{key}=").call(DateTime.strptime(data.method(key).call))
        end
      end
      data
    end
  end
end