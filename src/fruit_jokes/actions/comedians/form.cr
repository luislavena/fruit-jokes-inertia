require "json"

module FruitJokes::Actions::Comedians
  struct ComedianForm
    include JSON::Serializable

    getter name : String
    getter specialty : String
  end
end
