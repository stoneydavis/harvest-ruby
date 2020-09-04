# frozen_string_literal: true

module Harvest
  module Exceptions
    class Error < StandardError; end
    class BadState < Error; end
    class ProjectError < Error; end
    class TooManyProjects < ProjectError; end
    class NoProjectsFound < ProjectError; end
  end
end
