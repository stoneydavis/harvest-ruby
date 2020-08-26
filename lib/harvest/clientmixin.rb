# frozen_string_literal: true

module HarvestClientMixin
  # Change context to projects
  def projects
    change_context('projects')
  end

  # Change context to time_entry
  def time_entry
    case @state
    when 'project_tasks'
      raise NoProjectTasks if @tasks.length.zero?

      raise TooManyTasks if @tasks.length > 1

      change_context('time_entry')
    when ''
      change_context('time_entry')
    end
  end

  # Find task assignments for a project
  def tasks
    case @state
    when 'projects'
      raise TooManyProjects if @projects.length > 1

      raise NoProjectsFound if @projects.length.zero?

      raise ProjectError('No Task Assignments found') unless @projects[0].task_assignments

      change_context('project_tasks')
    when ''
      raise BadState 'Requires a state to call this method'
    end
  end

  # @api private
  def change_context(new_state)
    n = self.dup
    n.state = new_state
    n
  end
end
