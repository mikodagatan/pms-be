module JsonHelper
  def from_json(response_data)
    JSON.parse(response_data).deep_symbolize_keys!
  end
end
