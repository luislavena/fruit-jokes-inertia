require "http/server/context"

require "../../action"

module FruitJokes::Actions::Jokes
  struct Delete
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Check if joke exists
      joke = @app_env.jokes.find(id)

      if joke.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      # Delete the joke
      @app_env.jokes.delete(id)

      # Redirect to jokes list
      context.response.status_code = 302
      context.response.headers["Location"] = "/jokes"
    end
  end
end
