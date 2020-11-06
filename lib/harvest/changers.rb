# frozen_string_literal: true

module Harvest
  module Changers
    class TimeEntry
      def change(factory, client, _active_user, state, kwargs)
        # binding.pry
        state[state[:active]].map do |te|
          self.send(kwargs[:action].to_sym, factory, client, te)
        end
      end
      private 
      def restart(factory, client, te)
        # PATCH /v2/time_entries/{TIME_ENTRY_ID}/restart
        # binding.pry
        [factory.time_entry(client.api_call(client.api_caller("time_entries/#{te.id}/restart", http_method: 'patch')))]
      end
      def stop(factory, client, te)
        # PATCH /v2/time_entries/{TIME_ENTRY_ID}/stop
        [factory.time_entry(client.api_call(client.api_caller("time_entries/#{te.id}/stop", http_method: 'patch')))]
      end
    end
  end
end
