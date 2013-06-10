module AssignmentsHelper
  def reject_link_for(meeting)
    if meeting.state == "suggested"
      link_to 'reject', reject_profile_meeting_path(meeting.key)
    else
      'reject'
    end
  end

  def schedule_link_for(meeting)
    if meeting.state == "suggested"
      link_to 'schedule', schedule_profile_meeting_path(meeting.key)
    else
      'schedule'
    end
  end

  def matched(meetings, zone, time)
    meetings.detect do |meeting|
      meeting.start_at == time - 5.hours
    end
  end

  def first(meetings)
    meetings.first.start_at.to_i
  end

  def last(meetings)
    meetings.last.start_at.to_i
  end

  def iterate(meetings, increment = 1.hour)
    hour = first(meetings)
    ending = last(meetings)

    while hour < ending
      yield Time.at(hour)
      hour += increment
    end
  end
end
