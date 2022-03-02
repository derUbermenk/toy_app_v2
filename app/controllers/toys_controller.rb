class ToysController < ApplicationController
  before_action :set_toy, only: [:edit, :destroy]

  def new
    @toy = Toy.new
  end

  def create
    @toy = Toy.new(toy_params)

    if @toy.save
      flash[:success] = 'Toy was successfully created'
      redirect root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy 
    @toy.destroy

    flash[:success] = "#{@toy.name} successfully destroyed"
    redirect_to root_path
  end

  def index
    @toys = Toy.all.includes(:owner)
  end

  private

  def toy_params
    params.require(:toy).permit(:name, :description)
  end

  def set_toy
    @toy = Toy.find(params[:id])
  end
end
