# frozen_string_literal: true

module Harvest
  class FinderBase
    def initialize(factory, client)
      @factory = factory
      @client = client
    end
  end
end
