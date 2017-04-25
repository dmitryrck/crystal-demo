module CrystalDemo::MessageUtils
  def invalid(changeset)
    {
      "error" => 406,
      "message" => "Invalid",
      "errors" => changeset.errors
    }.to_json
  end

  def not_found
    {
      "error" => 404,
      "message" => "Not Found"
    }.to_json
  end

  def forbidden
    {
      "error" => 403,
      "message" => "Forbidden"
    }.to_json
  end
end
