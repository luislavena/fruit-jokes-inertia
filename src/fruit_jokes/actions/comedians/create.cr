require "http/server/context"
require "json"

require "../../action"
require "./form"

module FruitJokes::Actions::Comedians
  struct Create
    include Action

    def call(context, params)
      body = context.request.body
      return context.response.respond_with_status(:bad_request) unless body

      begin
        form_data = ComedianForm.from_json(body)

        # Validate form data
        errors = validate_form(form_data)

        if errors.empty?
          # Insert the data into the database
          insert_comedian(form_data)

          # Redirect to comedians list
          context.response.status_code = 302
          context.response.headers["Location"] = "/comedians"
          return
        else
          return @app_env.inertia.render(
            context,
            component: "Comedians/New",
            props: {
              errors: errors,
            })
        end
      rescue JSON::ParseException | JSON::Error
        context.response.respond_with_status(:bad_request)
      end
    end

    private def validate_form(form : ComedianForm)
      errors = {} of String => String

      errors["name"] = "Name is required" if form.name.empty?
      errors["specialty"] = "Specialty is required" if form.specialty.empty?

      errors
    end

    private def insert_comedian(form : ComedianForm)
      @app_env.comedians.create(
        form.name,
        form.specialty
      )
    end
  end
end
