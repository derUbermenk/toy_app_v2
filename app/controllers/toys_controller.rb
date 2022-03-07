class ToysController < ApplicationController
  before_action :set_toy, only: %i[edit update destroy]
  before_action :authenticate_user, only: %i[new edit update destroy]
  before_action :confirm_ownership, only: %i[edit update destroy]

  def index
    @toys = Toy.all.includes(:owner)
  end

  def new
    @toy = Toy.new
  end

  def create
    @toy = current_user.toys.build(toy_params)

    if @toy.save
      flash[:success] = 'Toy was successfully created'
      redirect_to profile_path 
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @toy.update(toy_params)
      flash[:success] = "#{@toy.name} successfully updated"
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  def destroy 
    @toy.destroy

    flash[:success] = "#{@toy.name} successfully destroyed"
    redirect_to root_path
  end

  private

  def toy_params
    params.require(:toy).permit(:name, :description, image: [])
  end

  def set_toy
    @toy = Toy.find(params[:id])
  end

  def confirm_ownership
    if @toy.owner == current_user
      @toy
    else
      flash[:warning] = 'You can only play with your own toys'
      redirect_to profile_path
    end
  end
end
