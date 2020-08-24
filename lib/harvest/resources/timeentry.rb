# frozen_string_literal: true

module Harvest
  # @param id [integer]
  #   Unique ID for the time entry.
  # @param spent_date [date]
  #   Date of the time entry.
  # @param user [object]
  #   An object containing the id and name of the associated user.
  # @param user_assignment [object]
  #   A user assignment object of the associated user.
  # @param client [object]
  #   An object containing the id and name of the associated client.
  # @param project [object]
  #   An object containing the id and name of the associated project.
  # @param task [object]
  #   An object containing the id and name of the associated task.
  # @param task_assignment [object]
  #   A task assignment object of the associated task.
  # @param external_reference [object]
  #   An object containing the id, group_id, permalink, service, and service_icon_url of the associated external reference.
  # @param invoice [object]
  #   Once the time entry has been invoiced, this field will include the associated invoice’s id and number.
  # @param hours [decimal]
  #   Number of (decimal time) hours tracked in this time entry.
  # @param rounded_hours [decimal]
  #   Number of (decimal time) hours tracked in this time entry used in summary reports and invoices. This value is rounded according to the Time Rounding setting in your Preferences.
  # @param notes [string]
  #   Notes attached to the time entry.
  # @param is_locked [boolean]
  #   Whether or not the time entry has been locked.
  # @param locked_reason [string]
  #   Why the time entry has been locked.
  # @param is_closed [boolean]
  #   Whether or not the time entry has been approved via Timesheet Approval.
  # @param is_billed [boolean]
  #   Whether or not the time entry has been marked as invoiced.
  # @param timer_started_at [datetime]
  #   Date and time the timer was started (if tracking by duration). Use the ISO 8601 Format.
  # @param started_time [time]
  #   Time the time entry was started (if tracking by start/end times).
  # @param ended_time [time]
  #   Time the time entry was ended (if tracking by start/end times).
  # @param is_running [boolean]
  #   Whether or not the time entry is currently running.
  # @param billable [boolean]
  #   Whether or not the time entry is billable.
  # @param budgeted [boolean]
  #   Whether or not the time entry counts towards the project budget.
  # @param billable_rate [decimal]
  #   The billable rate for the time entry.
  # @param cost_rate [decimal]
  #   The cost rate for the time entry.
  # @param created_at [datetime]
  #   Date and time the time entry was created. Use the ISO 8601 Format.
  # @param updated_at [datetime]
  #   Date and time the time entry was last updated. Use the ISO 8601 Format.
  TimeEntry = Struct.new(
    :id,
    :spent_date,
    :user,
    :user_assignment,
    :client,
    :project,
    :task,
    :task_assignment,
    :external_reference,
    :invoice,
    :hours,
    :rounded_hours,
    :notes,
    :is_locked,
    :locked_reason,
    :is_closed,
    :is_billed,
    :timer_started_at,
    :started_time,
    :ended_time,
    :is_running,
    :billable,
    :budgeted,
    :billable_rate,
    :cost_rate,
    :created_at,
    :updated_at
  ) do
  end
end
