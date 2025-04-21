require "http/server/handler"
require "log"

require "radix"

require "./action"
require "./actions/**"

module FruitJokes
  class Router
    include HTTP::Handler

    Log = ::Log.for(self)

    def initialize(@app_env : AppEnv)
      # Initialize the Radix tree for routing
      @routeset = Hash(String, Radix::Tree(Action)).new do |hash, key|
        hash[key] = Radix::Tree(Action).new
      end

      # Main dashboard route
      add_route("GET", "/", Actions::Dashboard)

      # Comedians routes
      add_route("GET", "/comedians", Actions::Comedians::Index)
      add_route("GET", "/comedians/new", Actions::Comedians::New)
      add_route("POST", "/comedians", Actions::Comedians::Create)
      add_route("GET", "/comedians/:id/edit", Actions::Comedians::Edit)
      add_route("PUT", "/comedians/:id", Actions::Comedians::Update)
      add_route("DELETE", "/comedians/:id", Actions::Comedians::Delete)

      # Jokes routes
      add_route("GET", "/jokes", Actions::Jokes::Index)
      add_route("GET", "/jokes/new", Actions::Jokes::New)
      add_route("POST", "/jokes", Actions::Jokes::Create)
      add_route("GET", "/jokes/:id/edit", Actions::Jokes::Edit)
      add_route("PUT", "/jokes/:id", Actions::Jokes::Update)
      add_route("DELETE", "/jokes/:id", Actions::Jokes::Delete)
    end

    def call(context)
      # Lookup the route in the Radix tree
      result = @routeset[context.request.method].find(context.request.path)

      # Return 404 if no route was found
      return context.response.respond_with_status(:not_found) unless result.found?

      # call the action from payload
      result.payload.call(context, result.params)
    end

    private def add_route(method, path, action : Action.class)
      @routeset[method].add(path, action.new(@app_env))
    end
  end
end
