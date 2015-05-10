module ApplicationHelper

  def embedded_svg(filename, options = {})
    puts "Filename: " + filename
    assets = Rails.application.assets
    file = assets.find_asset(filename).body.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    # Add classes
    if options[:class].present?
      svg["class"] = options[:class]
    end
    # Add alt text
    if options[:alt].present?
      svg["alt"] = options[:alt]
    end
    raw doc
  end
  
end


