module ProjectsHelper

  def status_options
    statuses = ProjectStatus.all
    status_options = statuses.map { |status| [status.name, status.id] }
    return status_options
  end

end
