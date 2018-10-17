module ApplicationHelper
  def current_correlation_id
    Application.current.correlation_id
  end

  def current_event
    Application.current.event
  end

  def current_payload
    Application.current.payload
  end
end
