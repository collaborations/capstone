class InstitutionsController < ApplicationController
  before_action :set_institution, only: [:show, :edit, :update, :destroy]
  before_action :set_amenity, only: [:edit, :update, :new]

  # GET /institutions
  # GET /institutions.json
  def index
    @institutions = Institution.all
    locations = Array.new(Array.new)
    for institution in @institutions do
      locations.push([institution.name, institution.locations])  
    end
    gon.locations2= locations

    #hard coded locations for testing
    gon.locations =  [
      ['<h4>Sigma Chi</h4>', 47.661520, -122.308676],
      ['<h4>Chipotle Mexican Grill</h4>', 47.659240, -122.313411],
      ['<h4>UW Tower</h4>', 47.660841, -122.314828],
      ['<h4>Mary Gates Hall</h4>', 47.655151, -122.307948]]

  end

  def amenity
    @institutions = Amenity.find(params[:id]).institutions
    render 'index'
  end

  # GET /institutions/1
  # GET /institutions/1.json
  def show
    @hours = InstitutionHasAmenity.where(institution_id: @institution.id).first.hours
    @location = Location.where(institution_id: @institution.id).first
    @contact = Contact.where(institution_id: @institution.id).first
    @restrictions = @institution.restrictions
  end

  # GET /institutions/new
  def new
    @institution = Institution.new
    @institution.locations.build
    @institution.restrictions.build
  end

  # GET /institutions/1/edit
  def edit
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
  
