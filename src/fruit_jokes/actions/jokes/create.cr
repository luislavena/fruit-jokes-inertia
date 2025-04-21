require "http/server/context"
require "json"

require "../../action"
require "./form"

module FruitJokes::Actions::Jokes
  struct Create
    include Action

    def call(context, params)
      body = context.request.body
      return context.response.respond_with_status(:bad_request) unless body

      begin
        form_data = JokeForm.from_json(body)

        # Validate form data
        errors = validate_form(form_data)

        if errors.empty?
          # Insert the data into the database
          insert_joke(form_data)

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

          return @app_env.inertia.render(
            context,
            component: "Jokes/New",
            props: {
              errors:    errors,
              comedians: comedians_data,
              fruits:    fruits,
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

    private def insert_joke(form : JokeForm)
      @app_env.jokes.create(
        form.setup,
        form.punchline,
        form.fruit,
        form.comedian_id
      )
    end
  end
end
