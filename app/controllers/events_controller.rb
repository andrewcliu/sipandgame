require "net/http"
require "icalendar"

class EventsController < ApplicationController
  def feed
    ics_url = Rails.application.credentials.dig(:google, :ics_url)

    uri = URI(ics_url)
    ics_data = Net::HTTP.get(uri)

    calendars = Icalendar::Calendar.parse(ics_data)
    cal = calendars.first

    events = cal.events.map do |e|
      {
        title: e.summary.to_s,
        start: e.dtstart.to_time.iso8601,
        end:   (e.dtend ? e.dtend.to_time.iso8601 : nil),
        description: e.description.to_s,
        location: e.location.to_s
      }
    end

    render json: events
  end
end

