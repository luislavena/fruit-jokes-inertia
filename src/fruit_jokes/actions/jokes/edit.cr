require "http/server/context"

require "../../action"

module FruitJokes::Actions::Jokes
  struct Edit
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Find the joke
      joke = @app_env.jokes.find(id)

      if joke.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      # Get all comedians for the dropdown
      comedians = @app_env.comedians.latest(100)

      # Format comedians data for the frontend
      comedians_data = comedians.map do |comedian|
        {
          id:   comedian.id,
          name: comedian.name,
        }
      end

      # Common fruits list for dropdown
      fruits = [
        "apple", "banana", "cherry", "grape", "kiwi", "lemon", "lime",
        "mango", "orange", "peach", "pear", "pineapple", "strawberry",
        "watermelon", "blueberry", "blackberry", "coconut", "fig",
        "grapefruit", "guava", "melon", "papaya", "plum", "pomegranate",
        "raspberry", "tangerine", "tomato", "carrot",
      ]

      # Format joke data for the frontend
      joke_data = {
        id:          joke.id,
        setup:       joke.setup,
        punchline:   joke.punchline,
        fruit:       joke.fruit,
        comedian_id: joke.comedian_id,
        created_at:  joke.created_at.to_s("%Y-%m-%d"),
        updated_at:  joke.updated_at.to_s("%Y-%m-%d %H:%M"),
      }

      @app_env.inertia.render(
        context: context,
        component: "Jokes/Edit",
        props: {
          joke:      joke_data,
          comedians: comedians_data,
          fruits:    fruits,
        }
      )
    end
  end
end
