class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  # before_action :user_institution
 
  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end
   
  # Get locale from top-level domain or return nil if such locale is not available
  # You have to put something like:
  #   127.0.0.1 application.com
  #   127.0.0.1 application.it
  #   127.0.0.1 application.pl
  # in your /etc/hosts file to try this out locally
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def user_institution
    if user_signed_in?
      @user_institution = Institution.where(id: current_user.institution_id).first
    end
  end

  def load_google_maps
    gon.google_maps_url = Settings.google.maps.url + 
                          "key=" + Settings.google.maps.token +
                          "&callback=" + Settings.google.maps.callback
    @load_google_maps = true
  end
end
