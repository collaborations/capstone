class InstitutionsController < ApplicationController
  before_action :set_amenity, only: [:edit, :update, :new]
  before_action :set_institution, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :load_google_maps, only: [:amenity, :index, :show]

  # GET /institutions
  # GET /institutions.json
  def index
    @institutions = Institution.search(params[:search])
    set_locations()
  end

  # GET /amenity/1
  def amenity
    @institutions = Amenity.find(params[:id]).institutions
    set_locations()
    render 'index'
  end

  # GET /institutions/1
  # GET /institutions/1.json
  def show
    @location = Location.where(institution_id: @institution.id).first
    @restrictions = @institution.restrictions
    set_locations()
  end

  # GET /institutions/new
  def new
    @institution = Institution.new
    @institution.locations.build
    @institution.restrictions.build
    @institution.filter = Filter.new
    @institution.build_hours
  end

  # GET /institutions/1/edit
  def edit
    @institution = Institution.where(id: params[:id]).first
  end

  # POST /institutions
  # POST /institutions.json
  def create
    @institution = Institution.new(institution_params)
    getLatLong(@institution)
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
      params.require(:institution).permit(:name, :desc, :instructions, :category,
        { :locations_attributes => [:id, :institution_id, :streetLine1, :streetLine2, :city, :state, :zip]}, 
        { :amenity_ids => []}, 
        { :restrictions_attributes => [:name, :desc]},
        { :hours_attributes => [:id, :institution_id, :mon_open, :mon_close, :tue_open, :tue_close, :wed_open, :wed_close, :thu_open, :thu_close, :fri_open, :fri_close, :sat_open, :sat_close, :sun_open, :sun_close]},
        { :filter_attributes => [:individual, :family, :male, :female, :min_age, :max_age, :physical_disability, :mental_disability, :veteran, :abuse_victim]} )
    end

    def set_locations
      lat = 0
      long = 0
      gon.markers = []
      institutions = @institution.present? ? [@institution] : @institutions
      institutions.each do |i|
        loc = i.locations.first
        if !loc.lat.present? or !loc.long.present?
          getLatLong(i)
          # Update data with current database values
          loc = i.locations.first
        end
        lat += loc.lat
        long += loc.long
        gon.markers << [i.id, i.name, loc.lat, loc.long]
      end
      unless lat == 0 and long == 0
        gon.push({
          :latitude => lat/gon.markers.length,
          :longitude => long/gon.markers.length
        })
      end
    end

    def getLatLong(institution)
      begin
        location = institution.locations.first
        address = location.streetLine1 + " "
        address << location.streetLine2 + " " if location.streetLine2.present?
        address << location.city + ", " + location.state + " " + location.zip.to_s
        url = Settings.google.geocode.url + "api_key=" + Settings.google.geocode.token + "&address=" + address.sub(/\s/, "+")
        response = JSON.parse(Faraday.get(url).body)['results']
        data = response[0]['geometry']['location']
        location.lat = data['lat']
        location.long = data['lng']
        location.save
      rescue NoMethodError => e
        Rails.logger.error e
      end
    end
end
  
