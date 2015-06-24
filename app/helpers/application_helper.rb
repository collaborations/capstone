module ApplicationHelper

  def embedded_amenity(amenity, options = {})
    @label = true if options[:label].present?
    render 'shared/amenity', amenity: amenity 
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename)
    if file.present?
      file = file.body.force_encoding("UTF-8")
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css "svg"

      svg["class"] = options[:class] if options[:class].present?  # Add classes
      svg["alt"] = options[:alt] if options[:alt].present?        # Add alt text
      raw doc
    end

  end

  def full_url(link)
    if link.starts_with?("http://", "https://")
      return link_to link, link
    else
      return link_to link, "http://#{link}" 
    end
  end

  def search_bar(options = {})
    @search_label = true if options[:label].present?
    render 'shared/search'
  end

  def loading_spinner
    render 'shared/loading'
  end
end


