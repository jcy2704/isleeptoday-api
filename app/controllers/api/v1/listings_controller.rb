class Api::V1::ListingsController < ApplicationController
  before_action :set_listing, only: %i[show update destroy]

  # GET /listings
  # GET /listings.json
  def index
    @listings = Listing.all

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
    image = Cloudinary::Uploader.upload(params[:image])
    @item = Item.create(item_image: image['url'])
    @lisiting.image = @item

    if @listing.save
      render :show, status: :created, location: api_v1_listing_path(@listing)
    else
      render json: @listing.errors, status: :unprocessable_entity
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
    params.require(:listing).permit(:name, :description, :user_id)
  end
end
