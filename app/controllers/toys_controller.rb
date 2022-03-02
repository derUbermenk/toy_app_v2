class ToysController < ApplicationController
  def index
    @toys = Toy.all.includes(:owner)
  end
end
