class LandingController < ApplicationController
  def index
    @superheroes = Superhero.all.limit(3).order(id: :desc)
  end
end
