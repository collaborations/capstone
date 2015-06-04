class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_institution


  private
    def set_institution
      @institution = Institution.find(current_user.institution_id)
    end
end
