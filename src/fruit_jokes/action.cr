module FruitJokes
  module Action
    macro included
      def initialize(@app_env : AppEnv)
      end
    end

    abstract def call(context : HTTP::Server::Context, params : Hash(String, String))
  end
end
