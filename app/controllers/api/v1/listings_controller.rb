class Api::V1::ListingsController < ApplicationController
  before_action :set_listing, only: %i[show update destroy]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all.includes(:user)
    @listings.each do |listing|
      listing.owner = listing.user.username
    end

    render json: @listings
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
    render json: @listing
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)
    @listing.user_id = current_user.id
    if listing_params[:image] != 'undefined'
      @image = Cloudinary::Uploader.upload(listing_params[:image], folder: 'isleeptoday/listings')
      @listing.image = @image['url']
    end

    if @listing.save && listing_params[:image] != 'undefined'
      render json: @listing, status: :created
    else
      Cloudinary::Uploader.destroy(@image['public_id']) unless listing_params[:image] == 'undefined'

      full_errors = []

      @listing.errors.each do |x|
        full_errors.append(x.full_message)
      end

      full_errors.append('Photo needs to be added') if listing_params[:image] == 'undefined'

      render json: {
        errors: full_errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    if @listing.update(listing_params)
      render :show, status: :ok, location: api_v1_listing_path(@listing)
    else
      render json: @listing.errors, status: :unprocessable_entity
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_listing
    @listing = Listing.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def listing_params
    params.require(:listing).permit(:name, :description, :image)
  end
end
