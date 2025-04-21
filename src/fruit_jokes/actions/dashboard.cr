require "http/server/context"

require "../action"

module FruitJokes::Actions
  struct Dashboard
    include Action

    def call(context, params)
      # Get data from repositories
      comedians_repo = @app_env.comedians
      jokes_repo = @app_env.jokes

      @app_env.inertia.render(
        context: context,
        component: "Dashboard",
        props: {
          stats: [
            {
              id:    1,
              name:  "Comedians",
              total: comedians_repo.total_count,
              delta: comedians_repo.month_over_month_delta,
            },
            {
              id:    2,
              name:  "Jokes",
              total: jokes_repo.total_count,
              delta: jokes_repo.month_over_month_delta,
            },
          ],
        }
      )
    end
  end
end
