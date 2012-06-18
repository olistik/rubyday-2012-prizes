require_relative 'attendee'

class AttendeeCollection
  attr_reader :collection

  def initialize(csv)
    @collection = File.
      read(csv).
      lines.
      map {|line| line.split(',')}[1..-1].
      map do |row|
        Attendee.build_from_row(row)
      end
  end

  def set_scores
    @collection.each do |attendee|
      attendee.set_scores
      append_scores(attendee)
    end
  end

  def append_scores(attendee)
    File.open('scores.txt', 'a+') do |file|
      file.write(attendee.to_json + "\n")
    end
  end
end
