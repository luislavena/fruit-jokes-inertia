require "http/server/context"

require "../../action"

module FruitJokes::Actions::Comedians
  struct Edit
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Find the comedian
      comedian = @app_env.comedians.find(id)

      if comedian.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      # Format data for the frontend
      comedian_data = {
        id:         comedian.id,
        name:       comedian.name,
        specialty:  comedian.specialty,
        created_at: comedian.created_at.to_s("%Y-%m-%d"),
        updated_at: comedian.updated_at.to_s("%Y-%m-%d %H:%M"),
      }

      @app_env.inertia.render(
        context: context,
        component: "Comedians/Edit",
        props: {
          comedian: comedian_data,
        }
      )
    end
  end
end
