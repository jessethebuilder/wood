module WoodApiHelper
  def api_template(path)
    "api/#{ENV.fetch('WOOD_API_VERSION')}/#{path}.json"
  end
end
