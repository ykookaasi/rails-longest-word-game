require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }.join(" ")
  end

  def score
    @attempt = params[:attempt].downcase
    @letters = params[:letter_list].downcase
    if @attempt.chars.all? { |letter| @attempt.count(letter) <= @letters.count(letter) }
      if english_word?(@attempt)
        @result = "Congratulations! #{@attempt} is a valid English word!"
        @score = "Your score is at #{compute_score(@attempt)}"
      else
        @result = "Sorry but #{@attempt} does not seem to be an English word..."
        @score = "Your score is at #{session[:score] += 0}"
      end
    else
      @result = "Sorry but #{@attempt} can't be built out of #{@letters}."
      @score = "Your score is at #{session[:score] += 0}"
    end
  end

  def compute_score(attempt)
    if session[:score] == "" || session[:score].nil?
      session[:score] += 0
    else
      session[:score] += attempt.length
    end
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
