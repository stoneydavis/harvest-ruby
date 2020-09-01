# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the expense category.
  # @param name [string]
  #   The name of the expense category.
  # @param unit_name [string]
  #   The unit name of the expense category.
  # @param unit_price [decimal]
  #   The unit price of the expense category.
  # @param is_active [boolean]
  #   Whether the expense category is active or archived.
  # @param created_at [datetime]
  #   Date and time the expense category was created.
  # @param updated_at [datetime]
  #   Date and time the expense category was last updated.
  Struct.new(
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

  # @param id [integer]
  #   Unique ID for the expense.
  # @param client [object]
  #   An object containing the expense's client id, name, and currency.
  # @param project [object]
  #   An object containing the expense's project id, name, and code.
  # @param expense_category [object]
  #   An object containing the expense's expense category id, name, unit_price,
  #   and unit_name.
  # @param user [object]
  #   An object containing the id and name of the user that recorded the expense.
  # @param user_assignment [object]
  #   A user assignment object of the user that recorded the expense.
  # @param receipt [object]
  #   An object containing the expense's receipt URL and file name.
  # @param invoice [object]
  #   Once the expense has been invoiced, this field will include the associated
  #   invoice's id and number.
  # @param notes [string]
  #   Textual notes used to describe the expense.
  # @param billable [boolean]
  #   Whether the expense is billable or not.
  # @param is_closed [boolean]
  #   Whether the expense has been approved or closed for some other reason.
  # @param is_locked [boolean]
  #   Whether the expense has been been invoiced, approved, or the project or
  #   person related to the expense is archived.
  # @param is_billed [boolean]
  #   Whether or not the expense has been marked as invoiced.
  # @param locked_reason [string]
  #   An explanation of why the expense has been locked.
  # @param spent_date [date]
  #   Date the expense occurred.
  # @param created_at [datetime]
  #   Date and time the expense was created.
  # @param updated_at [datetime]
  #   Date and time the expense was last updated.
  Struct.new(
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
