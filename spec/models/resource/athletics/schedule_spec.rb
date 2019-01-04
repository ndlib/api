require 'spec_helper'

describe Resource::Athletics::Schedule do


  def schedule_cassette(year)
    "athletics/schedule_spec/#{year}"
  end

  def event_xml
    document = Nokogiri::XML(File.open(File.join(Rails.root,"spec/fixtures/xml/athletics_schedule_event.xml")))
    (document/"event").first
  end

  describe 'instance' do
    let :schedule do
      @year = 2013
      schedule_instance = nil
      VCR.use_cassette(schedule_cassette(@year)) do
        schedule_instance = described_class.new(@year)
        schedule_instance.events_cache
      end
      schedule_instance
    end

    subject { schedule }

    describe '#schedule_url' do
      it "includes the year" do
        expect(subject.schedule_url).to match(/2013/)
      end
    end

    describe '#initialize' do
      it "sets the count" do
        expect(subject.count).to be > 0
        count = 0
        VCR.use_cassette(schedule_cassette(subject.year)) do
          document = Nokogiri::XML(open(subject.schedule_url))
          count = (document/"event").count
        end
        expect(subject.count).to be == count
      end
    end

    describe '#events' do
      it "has event data" do
        event = subject.events.first
        expect(event['year']).to be == "2013"
      end
    end

    describe '#events_by_sport' do
      it "returns events for football" do
        events = subject.events_by_sport("m-footbl")
        expect(events.count).to be == 14
        events.each do |event|
          expect(event['sport']).to be == "m-footbl"
        end
      end
    end

    describe '#sports' do
      it "lists all of the sports for the year" do
        sports = subject.sports
        expect(sports.count).to be == 22
        expect(sports.first["sport_fullname"]).to be == "Baseball"
      end
    end

    describe '#to_hash' do
      it 'returns a hash' do
        hash = subject.to_hash
        expect(hash).to be_a_kind_of Hash
        expect(hash['year']).to be == 2013
        expect(hash['sports'].count).to be == 22
        football_events = hash['events']['m-footbl']
        expect(football_events.count).to be == 14
        event = football_events.first
        expect(event['sport']).to be == 'm-footbl'
      end
    end

    describe '#to_json' do
      it 'returns a JSON string' do
        json = subject.to_json
        expect(json).to be_a_kind_of String
        hash = JSON.parse(json)
        expect(hash).to be_a_kind_of Hash
        expect(hash['year']).to be == 2013
        expect(hash['sports'].count).to be == 22
        football_events = hash['events']['m-footbl']
        expect(football_events.count).to be == 14
        event = football_events.first
        expect(event['sport']).to be == 'm-footbl'
      end
    end

    describe '#parse_event_xml' do
      it "loads attributes from event xml attributes and child elements" do
        event = subject.parse_event_xml(event_xml)
        expect(event['id']).to be == "1579221"
        expect(event['year']).to be == "2013"
        expect(event['sport']).to be == "m-footbl"
      end
    end
  end

  describe 'self' do
    subject { described_class }
    describe '#current_school_year' do
      it "returns the current year if the it is August or later" do
        current_year = Date.today.year
        (8..12).each do |month|
          Date.stub(:today) { Date.parse("#{current_year}-#{month}-01") }
          expect(subject.current_school_year).to be == current_year
        end
      end

      it "returns the previous year if the it is earlier than August" do
        current_year = Date.today.year
        (1..7).each do |month|
          Date.stub(:today) { Date.parse("#{current_year}-#{month}-01") }
          expect(subject.current_school_year).to be == current_year - 1
        end
      end
    end
  end
end
