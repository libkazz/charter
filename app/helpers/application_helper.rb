module ApplicationHelper
  def markdown(doc)
    CommonMarker.render_html(doc).html_safe
  end
end
