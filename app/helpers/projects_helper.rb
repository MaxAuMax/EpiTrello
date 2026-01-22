module ProjectsHelper

  def status_options
    statuses = ProjectStatus.all
    status_options = statuses.map { |status| [status.name, status.id] }
    return status_options
  end

  def column_color(color_name)
    case color_name
    when 'gray'
      'var(--color-slate-400)'
    when 'red'
      'var(--color-red-500)'
    when 'orange'
      'var(--color-orange-500)'
    when 'yellow'
      '#eab308'
    when 'green'
      'var(--color-green-500)'
    when 'blue'
      'var(--color-blue-500)'
    when 'purple'
      'var(--color-purple-500)'
    when 'pink'
      '#ec4899'
    else
      'var(--color-slate-400)'
    end
  end

end
