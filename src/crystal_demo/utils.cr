module CrystalDemo::Utils
  def write_ndjson(io, colums : Array(Symbol), instance)
    JSON.build(io) do |json|
      json.object do
        columns.each do |column|
          json_encode_field(json, column, instance.to_hash[column])
        end
      end
    end

    io << "\n"
  end

  def json_encode_field(json, col, value)
    case value
    when Bytes
      # custom json encoding. Avoid extra allocations.
      puts("Bytes")
      json.field col do
        json.array do
          value.each do |e|
            json.scalar e
          end
        end
      end
    else
      puts("NO Bytes")
      # encode the value as their built in json format.
      json.field col do
        value.to_json(json)
      end
    end
  end
end
