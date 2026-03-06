require "net/http"
require "uri"
require "icalendar"

class EventsController < ApplicationController
  def index
  end

  def feed
    ics_url = ENV["GOOGLE_ICS_URL"]
    return render(json: { error: "Missing GOOGLE_ICS_URL env var" }, status: 500) if ics_url.blank?

    uri = URI.parse(ics_url)
    ics_data = Net::HTTP.get(uri)

    cal = Icalendar::Calendar.parse(ics_data).first

    events = cal.events.map do |e|
      {
        id: e.uid.to_s,
        title: e.summary.to_s,
        start: e.dtstart&.to_time&.iso8601,
        end: (e.dtend ? e.dtend.to_time.iso8601 : nil),
        description: e.description.to_s,
        location: e.location.to_s
      }
    end

    render json: events
  rescue => ex
    render json: { error: ex.message }, status: 500
  end
end