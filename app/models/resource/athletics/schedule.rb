class Resource::Athletics::Schedule
  include CacheHelper

  attr_reader :year

  def initialize(year)
    @year = year.to_i
  end

  def expires_in
    if self.year == self.class.current_school_year
      1.day
    else
      1.week
    end
  end

  def events_cache
    @events_cache ||= Rails.cache.fetch(cache_key, :expires_in => expires_in) do
      tmp_events_cache = {}
      event_array = []
      each_event_element do |event_element|
        event_array << parse_event_xml(event_element)
      end
      tmp_events_cache[:events] = event_array
      tmp_events_cache[:events_by_sport] = tmp_events_cache[:events].group_by{|e| e['sport']}
      sports_array = []
      tmp_events_cache[:events_by_sport].each do |sport_key, sport_events|
        event = sport_events.first
        sports_array << {
          "sport" => event['sport'],
          "sport_abbr_name" => event['sport_abbr_name'],
          "sport_fullname" => event['sport_fullname'],
          "sport_shortname" => event['sport_shortname']
        }
      end
      tmp_events_cache[:sports] = sports_array.sort!{|a,b| a["sport_fullname"] <=> b["sport_fullname"]}
      tmp_events_cache[:to_hash] = {
        'year' => year,
        'sports' => tmp_events_cache[:sports],
        'events' => tmp_events_cache[:events_by_sport]
      }
      tmp_events_cache[:to_json] = tmp_events_cache[:to_hash].to_json
      tmp_events_cache
    end
  end

  def events
    events_cache[:events]
  end

  def events_by_sport(sport_code)
    events_by_sport_hash[sport_code.to_s]
  end

  def events_by_sport_hash
    events_cache[:events_by_sport]
  end

  def sports
    events_cache[:sports]
  end

  def parse_event_xml(node)
    data = {}
    data["id"] = node.attributes["id"].value
    node.elements.each do |element|
      data[element.name] = element.text
    end
    data
  end

  def to_hash
    events_cache[:to_hash]
  end

  def to_json
    events_cache[:to_json]
  end

  def count
    events.count
  end

  def each_event_element
    (document/"event").each do |event|
      yield event
    end
  end

  def document
    @document ||= Nokogiri::XML(open_schedule)
  end

  def schedule_url
    "http://www.und.com/data/nd-event-info-#{year}.xml"
  end

  def open_schedule
    require 'open-uri'
    open(schedule_url)
  end

  def cache_key
    "#{self.class.base_cache_key}/#{year}-v2"
  end

  def self.current_school_year
    year = Date.today.year
    if Date.today.month < 8
      year -= 1
    end
    year
  end
end
