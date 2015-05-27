class InstitutionsController < ApplicationController
  before_action :set_amenity, only: [:edit, :update, :new]
  before_action :set_institution, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update]

  # GET /institutions
  # GET /institutions.json
  def index
    @institutions = Institution.all
    locations = Array.new(Array.new)
    for institution in @institutions do
      locations.push([institution.name, institution.locations])  
    end
    # gon.locations2= locations
    
    #hard coded locations for testing
    gon.markers =  [
      ['<h4>Sigma Chi</h4>', 47.661520, -122.308676],
      ['<h4>Chipotle Mexican Grill</h4>', 47.659240, -122.313411],
      ['<h4>UW Tower</h4>', 47.660841, -122.314828],
      ['<h4>Mary Gates Hall</h4>', 47.655151, -122.307948]]

    lat = 0
    lon = 0
    gon.markers.each do |m|
      lat += m[1]
      lat += m[2]
    end
    gon.push({
      :latitude => lat/4,
      :longitude => lon/4
    })
  end

  # GET /amenity/1
  def amenity
    #hard coded locations for testing
    gon.markers =  [
      ['<h4>Sigma Chi</h4>', 47.661520, -122.308676],
      ['<h4>Chipotle Mexican Grill</h4>', 47.659240, -122.313411],
      ['<h4>UW Tower</h4>', 47.660841, -122.314828],
      ['<h4>Mary Gates Hall</h4>', 47.655151, -122.307948]]

    lat = 0
    lon = 0
    gon.markers.each do |m|
      lat += m[1]
      lat += m[2]
    end
    gon.push({
      :latitude => lat/4,
      :longitude => lon/4
    })
    
    @institutions = Amenity.find(params[:id]).institutions
    render 'index'
  end

  # GET /institutions/1
  # GET /institutions/1.json
  def show
    @id = @institution.id

    @location = Location.where(institution_id: @id).first
    @restrictions = @institution.restrictions
    
    address = @location.streetLine1 + " "
    address << @location.streetLine2 + " " if @location.streetLine2.present?
    address << @location.city + ", " + @location.state + " " + @location.zip.to_s
    
    gon.push({:address => address})
    render 'show'
  end

  # GET /institutions/new
  def new
    @institution = Institution.new
    @institution.locations.build
    @institution.restrictions.build
    @institution.filter.build
  end

  # GET /institutions/1/edit
  def edit
    @institution = Institution.where(id: params[:id]).first
    puts @institution
  end

  # POST /institutions
  # POST /institutions.json
  def create
    @institution = Institution.new(institution_params)
    puts params
    respond_to do |format|
      if @institution.save
        format.html { redirect_to @institution, notice: 'Institution was successfully created.' }
        format.json { render :show, status: :created, location: @institution }
      else
        format.html { render :new }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutions/1
  # PATCH/PUT /institutions/1.json
  def update
    respond_to do |format|
      if @institution.update(institution_params)
        format.html { redirect_to @institution, notice: 'Institution was successfully updated.' }
        format.json { render :show, status: :ok, location: @institution }
      else
        format.html { render :edit }
        format.json { render json: @institution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutions/1
  # DELETE /institutions/1.json
  def destroy
    @institution.destroy
    respond_to do |format|
      format.html { redirect_to institutions_url, notice: 'Institution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def print
    begin
      id = params.require(:id)
      @institution = Institution.where(id: id).first

      @contact = Contact.where(institution_id: id)
      @contact = @contact.first if @contact.present?

      @details = InstitutionDetail.where(institution_id: id)
      @details = @details.first if @details.present?

      @location = Location.where(institution_id: id)
      @location = @location.first if @location.present?

      @amenities = InstitutionHasAmenity.joins(:amenity, :institution).where(institution_id: id).map(&:amenity)

      # @restrictions = Restrictions.where(institution_id: id)
    rescue ActionController::ParameterMissing => e
      puts e.message
    end
    render 'print'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institution
      @institution = Institution.find(params[:id])
    end

    def set_amenity
      @amenities = Amenity.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institution_params
      params.require(:institution).permit(:name, :desc, :instructions, { :locations_attributes => [:streetLine1, :streetLine2, :city, :state, :zip]}, { :amenity_ids => []}, {:restrictions_attributes => [:name, :desc]}, :category)
    end
end
  
