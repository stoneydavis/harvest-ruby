# frozen_string_literal: true

module Harvest
  module Discovers
    class Projects
      def discover(admin_api, client, factory, active_user, _state, _params)
        @client = client
        @factory = factory
        @active_user = active_user
        admin_api ? admin_projects : project_assignments
      end

      private

      # @api private
      # All Projects
      def admin_projects
        @client
          .api_call(
            @client.api_caller('projects')
          )['projects']
          .map { |project| @factory.project(project) }
      end

      # @api private
      # Projects assigned to the specified user_id
      def project_assignments(user_id: @active_user.id)
        @client
          .api_call(
            @client.api_caller(
              "users/#{user_id}/project_assignments"
            )
          )['project_assignments']
          .map do |project|
            @factory.project_assignment(project)
          end
      end
    end

    class TimeEntry
      def discover(_admin_api, client, factory, _active_user, _state, params)
        paginator = client.paginator
        paginator.path = 'time_entries'
        paginator.data_key = 'time_entries'
        paginator.param = params
        client.pagination(paginator).map do |time_entry|
          factory.time_entry(time_entry)
        end
      end
    end

    class ProjectTasks
      def discover(_admin_api, _client, _factory, _active_user, state, _params)
        state[:filtered][:projects][0].task_assignments
      end
    end
  end
end
