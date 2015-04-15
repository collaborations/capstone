module ApplicationHelper
  def inline_svg(path)
    file = File.open("app/assets/images/#{path}", "rb")
    raw file.read
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).body.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css "svg"
    if options[:class].present?
      svg["class"] = options[:class]
    end
    raw doc
  end
end


