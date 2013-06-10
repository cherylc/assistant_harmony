module ProfilesHelper
  def subscribe_to(calendar)
    link_to (calendar.selected ? "unsubscribe" : "subscribe"), profile_calendar_subscribe_path(calendar, selected: !calendar.selected)
  end
end
