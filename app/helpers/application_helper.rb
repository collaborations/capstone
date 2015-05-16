module ApplicationHelper

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

  def search_bar(options = {})
    @search_label = true if options[:label].present?
    render 'shared/search'
  end

  def loading_spinner
    render 'shared/loading'
  end
end


