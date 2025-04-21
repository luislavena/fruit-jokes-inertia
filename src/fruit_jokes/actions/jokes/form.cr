require "json"

module StringToInt64
  def self.from_json(value : JSON::PullParser) : Int64
    int = value.read?(Int64)
    return int if int

    str = value.read?(String)
    return 0_i64 if str.nil? || str.empty?
    return str.to_i64
  end
end

module FruitJokes::Actions::Jokes
  struct JokeForm
    include JSON::Serializable

    getter setup : String
    getter punchline : String
    getter fruit : String

    @[JSON::Field(converter: StringToInt64)]
    getter comedian_id : Int64
  end
end
