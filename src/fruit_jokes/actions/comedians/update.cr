require "http/server/context"
require "json"

require "../../action"
require "./form"

module FruitJokes::Actions::Comedians
  struct Update
    include Action

    def call(context, params)
      id = params["id"].to_i64

      # Check if comedian exists
      comedian = @app_env.comedians.find(id)

      if comedian.nil?
        context.response.respond_with_status(:not_found)
        return
      end

      body = context.request.body
      return context.response.respond_with_status(:bad_request) unless body

      begin
        form_data = ComedianForm.from_json(body)

        # Validate form data
        errors = validate_form(form_data)

        if errors.empty?
          # Update the comedian
          update_comedian(id, form_data)

          # Redirect to comedians list
          context.response.status_code = 302
          context.response.headers["Location"] = "/comedians"
          return
        else
          # Format comedian data for the frontend
          comedian_data = {
            id:         comedian.id,
            name:       comedian.name,
            specialty:  comedian.specialty,
            created_at: comedian.created_at.to_s("%Y-%m-%d"),
            updated_at: comedian.updated_at.to_s("%Y-%m-%d %H:%M"),
          }

          return @app_env.inertia.render(
            context,
            component: "Comedians/Edit",
            props: {
              comedian: comedian_data,
              errors:   errors,
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

    private def update_comedian(id : Int64, form : ComedianForm)
      @app_env.comedians.update(
        id,
        form.name,
        form.specialty
      )
    end
  end
end
