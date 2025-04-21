require "http/server/context"

require "../../action"

module FruitJokes::Actions::Comedians
  struct New
    include Action

    def call(context, params)
      @app_env.inertia.render(
        context: context,
        component: "Comedians/New",
      )
    end
  end
end
