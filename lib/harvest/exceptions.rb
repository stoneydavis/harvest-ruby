# frozen_string_literal: true

module Harvest
  class Error < StandardError; end
  class BadState < Error; end
  class ProjectError < Error; end
  class TooManyProjects < ProjectError; end
  class NoProjectsFound < ProjectError; end
end
