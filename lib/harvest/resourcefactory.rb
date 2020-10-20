# frozen_string_literal: true

require 'harvest/resources'

module Harvest
  # Conversion for hash to Struct including nested items.
  # TODO: Refactor for figuring out what Struct should be used
  class NoValidStruct < ArgumentError
  end

  class ResourceFactory
    def resource(klass, data)
      data ||= {}
      send(klass.to_sym, data)
    end

    def message_recipient(data)
      data ||= {}
      Struct::MessageRecipient.new(data)
    end

    def company(data)
      data ||= {}
      Struct::Company.new(data)
    end

    def estimate(data)
      data ||= {}
      convert_estimate_line_items(convert_client(Struct::Estimate.new(data)))
    end

    def estimate_line_item(data)
      data ||= {}
      Struct::EstimateLineItem.new(data)
    end

    def estimate_message(data)
      data ||= {}
      Struct::EstimateMessage.new(data)
    end

    def estimate_item_category(data)
      data ||= {}
      Struct::EstimateItemCategory.new(data)
    end

    def expense_category(data)
      data ||= {}
      Struct::ExpenseCategory.new(data)
    end

    def expense(data)
      data ||= {}
      Struct::Expense.new(data)
    end

    def invoice(data)
      data ||= {}
      Struct::Invoice.new(data)
    end

    def invoice_line_item(data)
      data ||= {}
      Struct::InvoiceLineItem.new(data)
    end

    def invoice_message(data)
      data ||= {}
      Struct::InvoiceMessage.new(data)
    end

    def invoice_payment(data)
      data ||= {}
      Struct::InvoicePayment.new(data)
    end

    def invoice_item_category(data)
      data ||= {}
      Struct::InvoiceItemCategory.new(data)
    end

    def project_assignment(data)
      data ||= {}
      unless data.nil?
        convert_dates(
          convert_project_client(
            convert_task_assignments(
              Struct::ProjectAssignment.new(data)
            )
          )
        )
      end
    end

    def project(data)
      data ||= {}
      convert_dates(Struct::Project.new(data)) unless data.nil?
    end

    def client(data)
      data ||= {}
      convert_dates(Struct::ResourceClient.new(data)) unless data.nil?
    end

    def task_assignment(data)
      data ||= {}
      convert_dates(convert_task(Struct::TaskAssignment.new(data))) unless data.nil?
    end

    def task(data)
      data ||= {}
      convert_dates(Struct::Task.new(data)) unless data.nil?
    end

    def user(data)
      data ||= {}
      convert_dates(Struct::User.new(data)) unless data.nil?
    end

    def user_assignment(data)
      data ||= {}
      convert_dates(Struct::UserAssignment.new(data)) unless data.nil?
    end

    def time_entry_external_reference(data)
      data ||= {}
      Struct::TimeEntryExternalReference.new(data)
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
                    Struct::TimeEntry.new(data)
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
      unless data.line_items.nil?
        data.line_items = data.line_items.map { |ta| estimate_line_item(ta) }
      end
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
      unless data.task_assignments.nil?
        data.task_assignments = data.task_assignments.map { |ta| task_assignment(ta) }
      end
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
      %i[created_at updated_at sent_at accepted_at declined_at spent_date].each do |key|
        if data.members.include?(key) && !data.method(key).call.nil?
          data.method("#{key}=").call(DateTime.strptime(data.method(key).call))
        end
      end
      data
    end
  end
end
