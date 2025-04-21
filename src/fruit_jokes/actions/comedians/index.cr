require "http/server/context"

require "../../action"

module FruitJokes::Actions::Comedians
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

      # Get data from repository (filtered or unfiltered)
      comedians, pagination = @app_env.comedians.list(page)

      # Format data for the frontend
      comedians_data = comedians.map do |comedian|
        {
          id:         comedian.id,
          name:       comedian.name,
          specialty:  comedian.specialty,
          joke_count: comedian.joke_count,
          created_at: comedian.created_at.to_s("%Y-%m-%d"),
          updated_at: comedian.updated_at.to_s("%Y-%m-%d %H:%M"),
        }
      end

      @app_env.inertia.render(
        context: context,
        component: "Comedians/Index",
        props: {
          comedians:  comedians_data,
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
