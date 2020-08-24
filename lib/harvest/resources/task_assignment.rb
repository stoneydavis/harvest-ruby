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
    :task
  ) do
    def to_task
      hash_to_struct(self.to_h[:task], Harvest::Task)
    end
  end

end
