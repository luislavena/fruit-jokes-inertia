require "http/server/context"

require "../../action"

module FruitJokes::Actions::Comedians
  struct Delete
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Check if comedian exists
      comedian = @app_env.comedians.find(id)

      if comedian.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      # Delete the comedian
      @app_env.comedians.delete(id)

      # Redirect to comedians list
      context.response.status_code = 302
      context.response.headers["Location"] = "/comedians"
    end
  end
end
