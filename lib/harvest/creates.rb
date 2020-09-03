# frozen_string_literal: true

# Some API calls will return Project others ProjectAssignment.
def true_project(project)
  return project.project if project.respond_to?(:project)

  project
end

module Harvest
  module Create
    class TimeEntry
      def create(factory, client, active_user, state, kwargs)
        @state = state
        @active_user = active_user
        begin
          factory.time_entry(
            client.api_call(
              client.api_caller(
                'time_entries',
                http_method: 'post',
                payload: time_entry_payload(kwargs).to_json,
                headers: { content_type: 'application/json' }
              )
            )
          )
        rescue RestClient::UnprocessableEntity => e
          puts "Harvest Error from Create Time Entry: #{JSON.parse(e.response.body)['message']}"
          raise
        end
      end

      private

      # @api private
      def time_entry_payload(kwargs)
        possible_keys = %i[spent_date notes external_reference user_id]
        payload = kwargs.map { |k, v| [k, v] if possible_keys.include?(k) }.to_h
        payload[:user_id] ||= @active_user.id
        payload[:task_id] = @state[:filtered][:project_tasks][0].task.id
        payload[:project_id] = true_project(@state[:filtered][:projects][0]).id
        payload
      end
    end
  end
end
