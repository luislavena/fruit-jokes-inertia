require "http/server/context"

require "../../action"

module FruitJokes::Actions::Jokes
  struct Index
    include Action

    def call(context, params)
      # Get page parameter or default to 1
      page = if context.request.query_params.has_key?("page")
               context.request.query_params["page"].to_i? || 1
             else
               1
             end

      # Ensure page is at least 1
      page = 1 if page < 1

      # Get jokes and pagination info
      jokes, pagination = @app_env.jokes.list(page)

      # Format data for the frontend
      jokes_data = jokes.map do |joke|
        {
          id:            joke.id,
          setup:         joke.setup,
          punchline:     joke.punchline,
          fruit:         joke.fruit,
          comedian_id:   joke.comedian_id,
          comedian_name: joke.comedian_name,
          created_at:    joke.created_at.to_s("%Y-%m-%d"),
          updated_at:    joke.updated_at.to_s("%Y-%m-%d %H:%M"),
        }
      end

      @app_env.inertia.render(
        context: context,
        component: "Jokes/Index",
        props: {
          jokes:      jokes_data,
          pagination: {
            total:        pagination.total,
            current_page: pagination.page,
            per_page:     pagination.per_page,
            total_pages:  pagination.total_pages,
            has_previous: pagination.has_previous?,
            has_next:     pagination.has_next?,
          },
        }
      )
    end
  end
end
