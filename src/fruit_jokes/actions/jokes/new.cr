require "http/server/context"

require "../../action"

module FruitJokes::Actions::Jokes
  struct New
    include Action

    def call(context, params)
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

      @app_env.inertia.render(
        context: context,
        component: "Jokes/New",
        props: {
          comedians: comedians_data,
          fruits:    fruits,
        }
      )
    end
  end
end
