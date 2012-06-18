class Rankings
  TYPES = %w[stackoverflow coderwall twitter ml]
  SIZE = 10

  def initialize(attendees)
    @attendees = attendees
  end

  def value
    @rankings ||= fetch_rankings
  end

  private
  def fetch_rankings
    TYPES.each_with_object({}) do |type, object|
      object[type] = sorted_by_type(type).reverse.first(SIZE)
      object[type].map! {|x| "#{x['email']} => #{x['scores'][type]}"}
    end.merge(lucker_ranking)
  end

  def sorted_by_type(type)
    @attendees.sort do |a, b|
      a['scores'][type] <=> b['scores'][type]
    end
  end

  def lucker_ranking
    {lucker: @attendees.shuffle.first(SIZE).map {|attendee| attendee['email']}}
  end
end
