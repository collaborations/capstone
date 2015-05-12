module ApplicationHelper

  def amenity_path(amenity_id)
    "/amenity/" + amenity_id.to_s
  end

  def breadcrumbs
    @url = request.env['PATH_INFO'].sub(/\A\//, '').split("/")
    if @url.size >= 1
      render 'shared/breadcrumbs'
    end
  end

  def embedded_amenity(amenity, options = {})
    @amenity = amenity
    @label = true if options[:label].present?
    render 'shared/amenity'
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).body.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"

    svg["class"] = options[:class] if options[:class].present?  # Add classes
    svg["alt"] = options[:alt] if options[:alt].present?        # Add alt text
    raw doc
  end

  def loadGoogleMaps()
    javascript_include_tag(Settings.google.maps.url + Settings.google.maps.token)
  end

  def search_bar(options = {})
    @search_label = true if options[:label].present?
    render 'shared/search'
  end

  def send_email(options = {})

  end

  def send_text(options = {})

  end

  def send_printer(options = {})

  end
end


