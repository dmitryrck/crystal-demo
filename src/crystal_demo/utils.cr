module CrystalDemo::Utils
  def invalid_message(changeset)
    {
      "error" => 406,
      "message" => "Invalid",
      "errors" => changeset.errors
    }.to_json
  end

  def not_found_message
    {
      "error" => 404,
      "message" => "Not Found"
    }.to_json
  end

  def forbidden_message
    {
      "error" => 403,
      "message" => "Forbidden"
    }.to_json
  end
end
