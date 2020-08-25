# frozen_string_literal: true

module Harvest
  TaskAssignment = Struct.new(
    :id,
    :billable,
    :is_active,
    :created_at,
    :updated_at,
    :hourly_rate,
    :budget,
    :task,
    keyword_init: true
  )
end
