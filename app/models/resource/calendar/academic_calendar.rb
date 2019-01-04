class AcademicCalendar

  attr_reader :all_calendars, :first_calendar 
  attr_accessor :term_id

  @@today = Date.today
  # @@today = Date.parse("10th June 2014")

  def initialize(term)
    cal_file = calendar_file(term)
    if !cal_file.blank?
      @all_calendars = Icalendar.parse(cal_file)
      @first_calendar = @all_calendars.first
      @term_id = term
    end
  end


  def start_date
    self.first_calendar.events.first.dtstart
  end


  def end_date
    self.first_calendar.events.last.dtstart
  end

  private

  def calendar_file(term)
    filename = parse_term(term) + '.ics'
    filepath = Rails.root + 'calendar_data' + filename
    if File.exists?(filepath)
      return File.open(File.join(filepath))
    else
      return nil
    end
  end


  def self.current_term
    term_calendar = nil
    if try_guessed(guess_term)
      term_calendar = self.new(guess_term)
    elsif previous_guessed(guess_term)
      term_calendar = self.new(previous_term(guess_term))
    elsif next_guessed(guess_term)
      term_calendar = self.new(next_term(guess_term))
    else
      term_calendar = self.new(guess_term)
    end
    !term_calendar.all_calendars.blank? ? term_calendar : nil
  end


  def self.guess_term
    current_date = @@today
    if approximate_summer(current_date)
      year = current_date.year
      "#{year}" + '00'
    elsif approximate_fall(current_date)
      year = current_date.year
      "#{year}" + '10'
    elsif approximate_spring(current_date)
      year = current_date.year - 1
      "#{year}" + '20'
    end
  end

  
  def self.try_guessed(guess_term)
    ac = self.new(guess_term)
    !ac.all_calendars.blank? && ac.start_date <= @@today && ac.end_date >= @@today
  end


  def self.previous_guessed(guess_term)
    ac = self.new(previous_term(guess_term))
    !ac.all_calendars.blank? && ac.start_date <= @@today && ac.end_date >= @@today
  end


  def self.next_guessed(guess_term)
    ac = self.new(next_term(guess_term))
    !ac.all_calendars.blank? && ac.start_date <= @@today && ac.end_date >= @@today
  end


  def self.previous_term(term)
    (year, number) = term_parts(term)
    case number
    when '00'
      year = year.to_i - 1
      "#{year}" + '20'
    when '10'
      "#{year}" + '00'
    when '20'
      "#{year}" + '10'
    end
  end


  def self.next_term(term)
    (year, number) = term_parts(term)
    case number
    when '00'
      "#{year}" + '10'
    when '10'
      "#{year}" + '20'
    when '20'
      year = year.to_i + 1
      "#{year}" + '00'
    end
  end


  def self.approximate_summer(current_date)
    current_date >= Date.parse('1st June ' + @@today.year.to_s) && current_date <= Date.parse('10th August ' + @@today.year.to_s)
  end


  def self.approximate_fall(current_date)
    current_date >= Date.parse('11th August ' + @@today.year.to_s) && current_date <= Date.parse('31st December ' + @@today.year.to_s)
  end


  def self.approximate_spring(current_date)
    current_date >= Date.parse('1st January ' + @@today.year.to_s) && current_date <= Date.parse('31st May ' + @@today.year.to_s)
  end


  def parse_term(term)
    (year, number) = AcademicCalendar.term_parts(term)
    term_name = nil
    case number
    when '00'
      term_name = 'Summer'
    when '10'
      term_name = 'Fall'
    when '20'
      year = year.to_i + 1
      term_name = 'Spring'
    end
    term_name + '_' + year.to_s + '_'
  end

  def self.term_parts(term)
    term_regex = /(?<year>\d{4})(?<number>\d{2})/
    m = term.match term_regex
    return [m[:year], m[:number]]
  end

end
