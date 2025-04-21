require "yaml"
require "log"

require "drift"
require "sqlite3"

module FruitJokes
  struct Comedian
    include YAML::Serializable

    property id : Int32
    property name : String
    property specialty : String
    property created_at : Time?
    property updated_at : Time?
  end

  struct Joke
    include YAML::Serializable

    property id : Int32
    property setup : String
    property punchline : String
    property fruit : String
    property comedian_id : Int32?
    property created_at : Time?
    property updated_at : Time?
  end

  class Seeder
    Log = ::Log.for("Seeder")

    @db : DB::Database

    Drift.embed_as("drift_context", "../../database/migrations")

    def initialize
      # (same pattern as AppEnv)
      db_path = ENV.fetch("DB_PATH") { Dir.current }
      @db = DB.open("sqlite3:#{File.join(db_path, "app.db")}?journal_mode=wal&foreign_keys=1&synchronous=normal&busy_timeout=5000")
    end

    def run
      # apply migrations first
      run_migrations

      # Seed
      seed_comedians
      seed_jokes
    ensure
      @db.close
    end

    private def run_migrations
      Log.info { "Running migrations..." }
      migrator = Drift::Migrator.new(@db, drift_context)
      migrator.after_apply do |id, span|
        Log.info { "Applied: #{migrator.context[id].filename}" }
      end
      migrator.apply!
    end

    private def seed_comedians
      comedians_file = File.join(Dir.current, "database", "seeds", "comedians.yml")

      if File.exists?(comedians_file)
        Log.info { "Loading comedians from #{comedians_file}..." }

        comedians_data = File.open(comedians_file) do |file|
          Array(Comedian).from_yaml(file)
        end

        # Upsert comedians into the database using INSERT OR REPLACE
        comedians_data.each do |comedian|
          begin
            # Handle created_at and updated_at timestamps
            created_at = comedian.created_at || Time.utc
            updated_at = comedian.updated_at || Time.utc

            # Use INSERT with ON CONFLICT for upsert operation
            @db.exec(
              "INSERT INTO comedians (id, name, specialty, created_at, updated_at) VALUES (?, ?, ?, ?, ?)
               ON CONFLICT(id) DO UPDATE SET
               name = excluded.name,
               specialty = excluded.specialty,
               created_at = excluded.created_at,
               updated_at = excluded.updated_at",
              comedian.id, comedian.name, comedian.specialty, created_at, updated_at
            )
            Log.info { "Upserted comedian: #{comedian.name} (ID: #{comedian.id})" }
          rescue ex
            Log.warn { "Could not upsert comedian #{comedian.name} (ID: #{comedian.id}): #{ex.message}" }
          end
        end

        Log.info { "Comedian seeding completed." }
      else
        Log.warn { "Comedians file not found at #{comedians_file}" }
      end
    end

    private def seed_jokes
      jokes_file = File.join(Dir.current, "database", "seeds", "jokes.yml")

      if File.exists?(jokes_file)
        Log.info { "Loading jokes from #{jokes_file}..." }

        jokes_data = File.open(jokes_file) do |file|
          Array(Joke).from_yaml(file)
        end

        # Upsert jokes into the database
        jokes_data.each do |joke|
          begin
            # Handle created_at and updated_at timestamps
            created_at = joke.created_at || Time.utc
            updated_at = joke.updated_at || Time.utc

            # Use INSERT with ON CONFLICT for upsert operation
            @db.exec(
              "INSERT INTO jokes (id, setup, punchline, fruit, comedian_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)
               ON CONFLICT(id) DO UPDATE SET
               setup = excluded.setup,
               punchline = excluded.punchline,
               fruit = excluded.fruit,
               comedian_id = excluded.comedian_id,
               created_at = excluded.created_at,
               updated_at = excluded.updated_at",
              joke.id, joke.setup, joke.punchline, joke.fruit, joke.comedian_id, created_at, updated_at
            )
            Log.info { "Upserted joke: #{joke.setup} (ID: #{joke.id})" }
          rescue ex
            Log.warn { "Could not upsert joke #{joke.id}: #{ex.message}" }
          end
        end

        Log.info { "Joke seeding completed." }
      else
        Log.warn { "Jokes file not found at #{jokes_file}" }
      end
    end
  end
end

# Run the seeder
FruitJokes::Seeder.new.run
