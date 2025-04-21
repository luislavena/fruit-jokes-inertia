require "digest/md5"
require "ecr"
require "http/server"
require "log"

require "drift"
require "inertia"
require "sqlite3"
require "vite"

require "./router"
require "./repositories/*"

# Provides Fruit Jokes configuration
module FruitJokes
  class ViteRenderer
    include Inertia::Renderer

    def initialize(@vite : Vite)
    end

    def render(inertia : Inertia, context : HTTP::Server::Context, locals)
      # avoids single quotes in JSON data that causes issues in the Frontend
      data = HTML.escape(locals[:page])

      context.response.content_type = "text/html"
      context.response << <<-HTML
        <!DOCTYPE html>
        <html lang="en" class="h-full">
          <head>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>Fruit Jokes</title>
            #{@vite.style_tag("@/entrypoints/app.css")}
            #{@vite.client_tag}
            #{@vite.script_tag("@/entrypoints/app.js")}
          </head>
          <body class="h-full bg-gray-100">
            <div id="app" data-page='#{data}'></div>
          </body>
        </html>
        HTML
    end
  end

  class AppEnv
    Log = ::Log.for(self)

    getter inertia : Inertia
    getter comedians : ComedianRepository
    getter jokes : JokeRepository

    @db : DB::Database
    @vite : Vite

    def initialize(@address : String = "0.0.0.0", @port : Int32 = 8080)
      # Initialize database with persistent storage
      db_path = ENV.fetch("DB_PATH") { Dir.current }
      @db = DB.open("sqlite3:#{File.join(db_path, "app.db")}?journal_mode=wal&foreign_keys=1&synchronous=normal&busy_timeout=5000")

      # Initialize repositories
      @comedians = ComedianRepository.new(@db)
      @jokes = JokeRepository.new(@db)

      # prepare the frontend elements
      if File.exists?("public/build/manifest.json")
        version = Digest::MD5.hexdigest(File.read("public/build/manifest.json"))
      else
        version = "1"
      end

      @vite = Vite.new
      @inertia = Inertia.new(version: version, renderer: ViteRenderer.new(@vite))
    end

    def handlers
      stack = [
        HTTP::LogHandler.new,
        HTTP::StaticFileHandler.new("public", directory_listing: false),
      ] of HTTP::Handler

      # only in development mode
      {% if !flag?(:release) %}
        stack << @vite.dev_handler
      {% end %}

      stack << @inertia.http_handler
      stack << Router.new(self)

      stack
    end

    def start
      prepare_database
    end

    def stop
      Log.info { "Closing database." }
      @db.close
    end

    Drift.embed_as("drift_context", "../../database/migrations")

    private def prepare_database
      Log.info { "Running migrations..." }
      migrator = Drift::Migrator.new(@db, drift_context)
      migrator.after_apply do |id, span|
        Log.info { "Applied: #{migrator.context[id].filename}" }
      end
      migrator.apply!
    end
  end
end
