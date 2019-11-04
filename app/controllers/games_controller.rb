# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def english_word(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word.join}")
    json = JSON.parse(response.read)
    json['found']
  end

  def including(user_world, letters)
    result = []
    user_world.each do |letter|
      if letters.include?(letter)
        result << letter
        letters.delete(letter)
      else
        result = []
      end
    end
    result
  end

  def score
    @user_world = params[:world].split('')
    @letters = params[:letters].split(' ')
    @result = including(@user_world, @letters)
    if @result.length == @user_world.length && english_word(@user_world)
      @what = "Congratulations! #{@user_world.join} is a valid English world! Score: #{@user_world.length}"
    elsif @result.length == @user_world.length && !english_word(@user_world)
      @what = "Sorry, but #{@user_world.join} isn't a valid English world."
    else
      @what = "Sorry, but #{@user_world.join} can't be built out of #{@letters}"
    end
  end

end
