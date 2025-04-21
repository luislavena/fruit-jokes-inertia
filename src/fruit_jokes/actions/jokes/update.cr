require "http/server/context"
require "json"

require "../../action"
require "./form"

module FruitJokes::Actions::Jokes
  struct Update
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Check if joke exists
      joke = @app_env.jokes.find(id)

      if joke.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      body = context.request.body
      return context.response.respond_with_status(:bad_request) unless body

      begin
        form_data = JokeForm.from_json(body)

        # Validate form data
        errors = validate_form(form_data)

        if errors.empty?
          # Update the joke
          update_joke(id, form_data)

          # Redirect to jokes list
          context.response.status_code = 302
          context.response.headers["Location"] = "/jokes"
          return
        else
          # Get all comedians for the dropdown (in case of validation failure)
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

          return @app_env.inertia.render(
            context,
            component: "Jokes/Edit",
            props: {
              joke:      joke_data,
              comedians: comedians_data,
              fruits:    fruits,
              errors:    errors,
            })
        end
      rescue JSON::ParseException | JSON::Error
        context.response.respond_with_status(:bad_request)
      end
    end

    private def validate_form(form : JokeForm)
      errors = {} of String => String

      errors["setup"] = "Setup is required" if form.setup.empty?
      errors["punchline"] = "Punchline is required" if form.punchline.empty?
      errors["fruit"] = "Fruit is required" if form.fruit.empty?

      # Check if comedian exists
      comedian = @app_env.comedians.find(form.comedian_id)
      errors["comedian_id"] = "Comedian not found" if comedian.nil?

      errors
    end

    private def update_joke(id : Int64, form : JokeForm)
      @app_env.jokes.update(
        id,
        form.setup,
        form.punchline,
        form.fruit,
        form.comedian_id
      )
    end
  end
end
