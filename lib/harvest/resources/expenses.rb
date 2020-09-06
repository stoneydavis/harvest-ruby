# frozen_string_literal: true

module Harvest
  module Resources
    # @param id [Integer]
    #   Unique ID for the expense category.
    # @param name [String]
    #   The name of the expense category.
    # @param unit_name [String]
    #   The unit name of the expense category.
    # @param unit_price [decimal]
    #   The unit price of the expense category.
    # @param is_active [Boolean]
    #   Whether the expense category is active or archived.
    # @param created_at [DateTime]
    #   Date and time the expense category was created.
    # @param updated_at [DateTime]
    #   Date and time the expense category was last updated.
    ExpenseCategory = Struct.new(
      'ExpenseCategory',
      :id,
      :name,
      :unit_name,
      :unit_price,
      :is_active,
      :created_at,
      :updated_at,
      keyword_init: true
    )

    # @param id [Integer]
    #   Unique ID for the expense.
    # @param client [Struct]
    #   An object containing the expense's client id, name, and currency.
    # @param project [Struct]
    #   An object containing the expense's project id, name, and code.
    # @param expense_category [Struct]
    #   An object containing the expense's expense category id, name, unit_price,
    #   and unit_name.
    # @param user [Struct]
    #   An object containing the id and name of the user that recorded the expense.
    # @param user_assignment [Struct]
    #   A user assignment object of the user that recorded the expense.
    # @param receipt [Struct]
    #   An object containing the expense's receipt URL and file name.
    # @param invoice [Struct]
    #   Once the expense has been invoiced, this field will include the associated
    #   invoice's id and number.
    # @param notes [String]
    #   Textual notes used to describe the expense.
    # @param billable [Boolean]
    #   Whether the expense is billable or not.
    # @param is_closed [Boolean]
    #   Whether the expense has been approved or closed for some other reason.
    # @param is_locked [Boolean]
    #   Whether the expense has been been invoiced, approved, or the project or
    #   person related to the expense is archived.
    # @param is_billed [Boolean]
    #   Whether or not the expense has been marked as invoiced.
    # @param locked_reason [String]
    #   An explanation of why the expense has been locked.
    # @param spent_date [Date]
    #   Date the expense occurred.
    # @param created_at [DateTime]
    #   Date and time the expense was created.
    # @param updated_at [DateTime]
    #   Date and time the expense was last updated.
    Expense = Struct.new(
      'Expense',
      :id,
      :client,
      :project,
      :expense_category,
      :user,
      :user_assignment,
      :receipt,
      :invoice,
      :notes,
      :billable,
      :is_closed,
      :is_locked,
      :is_billed,
      :locked_reason,
      :spent_date,
      :created_at,
      :updated_at,
      keyword_init: true
    )
  end
end
