# frozen_string_literal: true

require_relative '../finderbase'

module Harvest
  module Finders
    class Projects < FinderBase
      def find(id)
        [@factory.project(@client.api_call(@client.api_caller("projects/#{id}")))]
      end
    end
  end
end
