class ToysController < ApplicationController
  before_action :set_toy, only: %i[edit update destroy show]
  before_action :authenticate_user
  before_action :confirm_ownership, only: %i[edit update destroy]

  def index
    @toys = current_user.toys
  end

  def new
    @toy = Toy.new
  end

  def create
    @toy = current_user.toys.build(toy_params)

    if @toy.save
      flash[:success] = 'Toy was successfully created'
      redirect_to dashboard_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    # add image of toy has image attributes
    if params[:toy].nil?
      flash[:warning] = "Can't update with no images attached"
      redirect_back(fallback_location: @toy)
    elsif params[:toy][:images]
      add_images
    # update toys text attribtes: name and description
    elsif @toy.update(toy_update_params)
      flash[:success] = "#{@toy.name} successfully updated"
      redirect_to @toy 
    # else rerender edit page
    else
      render 'edit'
    end
  end

  def show
  end

  def destroy 
    @toy.destroy

    flash[:success] = "#{@toy.name} successfully destroyed"
    redirect_to root_path
  end

  def destroy_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge

    respond_to do |format|
      format.js {}
      format.html{ redirect_back(fallback_location: request.referrer) }
    end
  end

  private

  def toy_params
    params.require(:toy).permit(:name, :description, images: [])
  end

  def toy_params_update
    # do not allow images field on toy update
    #   will delete previous images
    params.require(:toy).permit(:name, :description)
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

  def add_images
    @images = params[:toy][:images]

    if @toy.images.attach(@images)
      render partial: 'image', collection: @toy.images.where('created_at > ?', 4.seconds.ago)
    else
      render 'application/error_messages', model: @toy, status: :bad_request
    end
  end
end
