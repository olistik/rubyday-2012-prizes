require_relative 'stackoverflow'
require_relative 'coderwall'
require_relative 'ml'
require 'twitter-stats'
require 'ostruct'

class Attendee
  attr_accessor :email, :stackoverflow, :coderwall, :twitter, :ml
  attr_reader :scores

  def initialize(email, stackoverflow, coderwall, twitter, ml)
    @email = email
    @stackoverflow = stackoverflow
    @coderwall = coderwall
    if !@coderwall.include?('http://coderwall.com/') && @coderwall.length > 0
      @coderwall = 'http://coderwall.com/' + @coderwall
    end
    @twitter = twitter
    @ml = ml.chomp == 'Yes'
    @scores = OpenStruct.new
  end

  def self.build_from_row(row)
    new(*row[1..-1])
  end

  def set_scores
    set_score_stackoverflow
    set_score_twitter
    set_score_coderwall
    set_score_ml
  end

  def set_score_stackoverflow
    puts "SO: #{@email}"
    @scores.stackoverflow = if @stackoverflow.length > 0
       StackOverflow::API::Reputation.build_from_profile_url(@stackoverflow).value
    else
      0
    end
  end

  def set_score_twitter
    puts "TW: #{@twitter}"
    @scores.twitter = if @twitter.length > 0
      Twitter::Stats::Count.new(@twitter, 'ruby', 356).value
    else
      0
    end
  end

  def set_score_coderwall
    puts "CW: #{@coderwall}"
    @scores.coderwall = if @coderwall.length > 0
      Coderwall::API::BadgesCount.build_from_profile_url(@coderwall).value
    else
      0
    end
  end

  def set_score_ml
    puts "ML: #{@email}"
    @scores.ml = if @ml
      ML.new(@email).posts_count
    else
      0
    end
  end

  def to_json
    {
      email: @email,
      scores: {
        stackoverflow: @scores.stackoverflow,
        coderwall: @scores.coderwall,
        twitter: @scores.twitter,
        ml: @scores.ml
      }
    }.to_json
  end
end
