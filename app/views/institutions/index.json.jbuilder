json.array!(@institutions) do |institution|
  json.merge! institution.attributes
  json.url institution_url(institution, format: :json)
end
