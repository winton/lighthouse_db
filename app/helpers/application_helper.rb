module ApplicationHelper

  def active?(path)
    'active' if request.path[0..path.length-1] == path
  end
end
