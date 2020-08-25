# frozen_string_literal: true

module Harvest
  Task = Struct.new(
    :id,
    :name,
    :billable_by_default,
    :default_hourly_rate,
    :is_default,
    :is_active,
    :created_at,
    :updated_at,
    keyword_init: true
  )
end
