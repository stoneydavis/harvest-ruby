# frozen_string_literal: true

module Harvest
  module Finders
    class Projects
      def find(factory, client, id)
        [factory.project(client.api_call(client.api_caller("projects/#{id}")))]
      end
    end

    class TimeEntry
      def find(factory, client, id)
        [factory.time_entry(client.api_call(client.api_caller("time_entry/#{id}")))]
      end
    end
  end
end
