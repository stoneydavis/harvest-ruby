# frozen_string_literal: true

module Harvest
  # @param id [Integer]
  #   Unique ID for the time entry.
  # @param spent_date [Date]
  #   Date of the time entry.
  # @param user [Struct]
  #   An object containing the id and name of the associated user.
  # @param user_assignment [Struct]
  #   A user assignment object of the associated user.
  # @param client [Struct]
  #   An object containing the id and name of the associated client.
  # @param project [Struct]
  #   An object containing the id and name of the associated project.
  # @param task [Struct]
  #   An object containing the id and name of the associated task.
  # @param task_assignment [Struct]
  #   A task assignment object of the associated task.
  # @param external_reference [Struct]
  #   An object containing the id, group_id, permalink, service, and
  #   service_icon_url of the associated external reference.
  # @param invoice [Struct]
  #   Once the time entry has been invoiced, this field will include the
  #   associated invoice's id and number.
  # @param hours [decimal]
  #   Number of (decimal time) hours tracked in this time entry.
  # @param rounded_hours [decimal]
  #   Number of (decimal time) hours tracked in this time entry used in summary
  #   reports and invoices. This value is rounded according to the Time Rounding
  #   setting in your Preferences.
  # @param notes [String]
  #   Notes attached to the time entry.
  # @param is_locked [Boolean]
  #   Whether or not the time entry has been locked.
  # @param locked_reason [String]
  #   Why the time entry has been locked.
  # @param is_closed [Boolean]
  #   Whether or not the time entry has been approved via Timesheet Approval.
  # @param is_billed [Boolean]
  #   Whether or not the time entry has been marked as invoiced.
  # @param timer_started_at [DateTime]
  #   Date and time the timer was started (if tracking by duration). Use the ISO 8601 Format.
  # @param started_time [Time]
  #   Time the time entry was started (if tracking by start/end times).
  # @param ended_time [Time]
  #   Time the time entry was ended (if tracking by start/end times).
  # @param is_running [Boolean]
  #   Whether or not the time entry is currently running.
  # @param billable [Boolean]
  #   Whether or not the time entry is billable.
  # @param budgeted [Boolean]
  #   Whether or not the time entry counts towards the project budget.
  # @param billable_rate [decimal]
  #   The billable rate for the time entry.
  # @param cost_rate [decimal]
  #   The cost rate for the time entry.
  # @param created_at [DateTime]
  #   Date and time the time entry was created. Use the ISO 8601 Format.
  # @param updated_at [DateTime]
  #   Date and time the time entry was last updated. Use the ISO 8601 Format.
  TimeEntry = Struct.new(
    'TimeEntry',
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
    :updated_at,
    keyword_init: true
  )

  TimeEntryExternalReference = Struct.new(
    'TimeEntryExternalReference',
    :id,
    :group_id,
    :permalink,
    :service,
    :service_icon_url,
    keyword_init: true
  )
end
