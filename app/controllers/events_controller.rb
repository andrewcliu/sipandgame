require "net/http"
require "uri"
require "icalendar"

class EventsController < ApplicationController
  def index
  end

  def feed
    ics_url = calendar_ics_url
    return render(json: { error: "Missing calendar ICS URL configuration" }, status: 500) if ics_url.blank?

    uri = URI.parse(ics_url)
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == "https"

    request = Net::HTTP::Get.new(uri)
    request["Cache-Control"] = "no-cache"
    request["Pragma"] = "no-cache"

    ics_response = http.request(request)
    unless ics_response.is_a?(Net::HTTPSuccess)
      return render(json: { error: "Calendar feed request failed with status #{ics_response.code}" }, status: 502)
    end

    ics_data = ics_response.body

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

  private

  def calendar_ics_url
    ENV["GOOGLE_ICS_URL"].presence ||
      Rails.application.credentials.google_ics_url.presence ||
      Rails.application.credentials.dig(:google, :ics_url).presence
  end
end
